<?php
/**
 * Moonia Theme Config
 *
 * Lightweight BO color configuration for the mooniadesign-3 theme.
 * Writes a static custom-vars.css file on save — zero per-request overhead:
 * the file is served as a regular cacheable stylesheet with a filemtime version.
 */

if (!defined('_PS_VERSION_')) {
    exit;
}

class Mooniatheme extends Module
{
    protected const CSS_FILE = 'views/css/custom-vars.css';

    protected const COLORS = [
        'MOONIATHEME_PRIMARY' => [
            'var' => '--md-color-primary',
            'default' => '#111',
            'label' => 'Pagrindinė spalva',
        ],
        'MOONIATHEME_ACCENT' => [
            'var' => '--md-color-accent',
            'default' => '#ff6a00',
            'label' => 'Akcentinė spalva (mygtukai)',
        ],
        'MOONIATHEME_ACCENT_HOVER' => [
            'var' => '--md-color-accent-hover',
            'default' => '#e65a00',
            'label' => 'Akcentinė spalva (hover)',
        ],
        'MOONIATHEME_DANGER' => [
            'var' => '--md-color-danger',
            'default' => '#d32f2f',
            'label' => 'Įspėjimo (warning) spalva',
        ],
    ];

    public function __construct()
    {
        $this->name = 'mooniatheme';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'moonia';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->trans('Moonia Theme Config', [], 'Modules.Mooniatheme.Admin');
        $this->description = $this->trans(
            'Greitas pagrindinių temos spalvų keitimas (mooniadesign-3).',
            [],
            'Modules.Mooniatheme.Admin'
        );
        $this->ps_versions_compliancy = ['min' => '9.0.0', 'max' => '9.99.99'];
    }

    public function install(): bool
    {
        foreach (self::COLORS as $key => $color) {
            Configuration::updateValue($key, $color['default']);
        }

        return parent::install()
            && $this->registerHook('actionFrontControllerSetMedia')
            && $this->generateCss();
    }

    public function uninstall(): bool
    {
        foreach (self::COLORS as $key => $color) {
            Configuration::deleteByName($key);
        }

        $file = $this->getCssPath();

        if (is_file($file)) {
            unlink($file);
        }

        return parent::uninstall();
    }

    public function getContent(): string
    {
        $output = '';

        if (Tools::isSubmit('submit' . $this->name)) {
            $errors = [];
            $values = [];

            foreach (self::COLORS as $key => $color) {
                $value = trim((string) Tools::getValue($key));
                $value = $value === '' ? $color['default'] : $value;

                if (!$this->isHexColor($value)) {
                    $errors[] = sprintf('%s: "%s" — neteisingas HEX formatas', $color['label'], $value);
                    continue;
                }

                $values[$key] = Tools::strtolower($value);
            }

            if ($errors) {
                $output .= $this->displayError(implode('<br>', $errors));
            } else {
                foreach ($values as $key => $value) {
                    Configuration::updateValue($key, $value);
                }

                $output .= $this->generateCss()
                    ? $this->displayConfirmation($this->trans('Nustatymai išsaugoti, custom-vars.css atnaujintas.', [], 'Modules.Mooniatheme.Admin'))
                    : $this->displayError($this->trans('Nepavyko įrašyti custom-vars.css — patikrinkite rašymo teises.', [], 'Modules.Mooniatheme.Admin'));
            }
        }

        return $output . $this->renderForm();
    }

    protected function renderForm(): string
    {
        $fields = [];

        foreach (self::COLORS as $key => $color) {
            $fields[] = [
                'type' => 'color',
                'label' => $color['label'],
                'name' => $key,
                'desc' => sprintf('CSS kintamasis %s (numatytoji %s)', $color['var'], $color['default']),
            ];
        }

        $helper = new HelperForm();
        $helper->show_toolbar = false;
        $helper->module = $this;
        $helper->default_form_language = (int) Configuration::get('PS_LANG_DEFAULT');
        $helper->allow_employee_form_lang = (int) Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG');
        $helper->identifier = $this->identifier;
        $helper->submit_action = 'submit' . $this->name;
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false)
            . '&configure=' . $this->name . '&tab_module=' . $this->tab . '&module_name=' . $this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');
        $helper->tpl_vars = [
            'fields_value' => $this->getConfigValues(),
            'languages' => $this->context->controller->getLanguages(),
            'id_language' => $this->context->language->id,
        ];

        $form = [
            'form' => [
                'legend' => ['title' => $this->displayName],
                'description' => $this->trans(
                    'Spalvos įrašomos į statinį custom-vars.css failą — jokio poveikio našumui. Palikite tuščią lauką, kad būtų naudojama numatytoji reikšmė.',
                    [],
                    'Modules.Mooniatheme.Admin'
                ),
                'input' => $fields,
                'submit' => ['title' => $this->trans('Išsaugoti', [], 'Modules.Mooniatheme.Admin')],
            ],
        ];

        return $helper->generateForm([$form]);
    }

    public function hookActionFrontControllerSetMedia(): void
    {
        $path = $this->getCssPath();

        if (!is_file($path)) {
            return;
        }

        $this->context->controller->registerStylesheet(
            'module-mooniatheme-vars',
            'modules/' . $this->name . '/' . self::CSS_FILE,
            [
                'media' => 'all',
                'priority' => 200,
                'version' => (string) filemtime($path),
            ]
        );
    }

    protected function getConfigValues(): array
    {
        $values = [];

        foreach (self::COLORS as $key => $color) {
            $values[$key] = Configuration::get($key) ?: $color['default'];
        }

        return $values;
    }

    protected function generateCss(): bool
    {
        $values = $this->getConfigValues();
        $lines = [':root {'];

        foreach (self::COLORS as $key => $color) {
            $lines[] = sprintf('  %s: %s;', $color['var'], $values[$key]);
        }

        $rgb = $this->hexToRgb($values['MOONIATHEME_ACCENT']);

        if ($rgb) {
            $lines[] = sprintf('  --md-color-accent-rgb: %s;', implode(', ', $rgb));
        }

        $lines[] = '}';
        $lines[] = '';

        $file = $this->getCssPath();

        if (!is_dir(dirname($file)) && !mkdir(dirname($file), 0755, true)) {
            return false;
        }

        return file_put_contents($file, implode("\n", $lines)) !== false;
    }

    protected function getCssPath(): string
    {
        return $this->getLocalPath() . self::CSS_FILE;
    }

    protected function isHexColor(string $value): bool
    {
        return (bool) preg_match('/^#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/', $value);
    }

    protected function hexToRgb(string $hex): ?array
    {
        $hex = ltrim($hex, '#');

        if (strlen($hex) === 3) {
            $hex = $hex[0] . $hex[0] . $hex[1] . $hex[1] . $hex[2] . $hex[2];
        }

        if (strlen($hex) !== 6) {
            return null;
        }

        return [
            hexdec(substr($hex, 0, 2)),
            hexdec(substr($hex, 2, 2)),
            hexdec(substr($hex, 4, 2)),
        ];
    }
}
