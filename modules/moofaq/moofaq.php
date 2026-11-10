<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

/**
 * moonia FAQ — per-category Q/A pairs managed from a simple BO form.
 * Renders a visible <details> accordion (SEO content) and FAQPage JSON-LD.
 */
class Moofaq extends Module
{
    protected const TABLE = 'moofaq';

    public function __construct()
    {
        $this->name = 'moofaq';
        $this->tab = 'seo';
        $this->version = '1.0.0';
        $this->author = 'moonia';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->trans('Moonia FAQ', [], 'Modules.Moofaq.Admin');
        $this->description = $this->trans('Per-category FAQ: visible accordion + FAQPage JSON-LD. One data source for both.', [], 'Modules.Moofaq.Admin');
        $this->ps_versions_compliancy = ['min' => '9.0.0', 'max' => _PS_VERSION_];
    }

    public function install()
    {
        return parent::install()
            && $this->installDb()
            && $this->registerHook('displayHeader')
            && $this->registerHook('displayCategoryFaq');
    }

    public function uninstall()
    {
        return parent::uninstall() && $this->uninstallDb();
    }

    protected function installDb(): bool
    {
        return (bool) Db::getInstance()->execute(
            'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . pSQL(self::TABLE) . '` (
                `id_moofaq` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `id_category` INT UNSIGNED NOT NULL,
                `id_lang` INT UNSIGNED NOT NULL,
                `question` VARCHAR(512) NOT NULL,
                `answer` TEXT NOT NULL,
                `position` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
                PRIMARY KEY (`id_moofaq`),
                KEY `idx_cat_lang` (`id_category`, `id_lang`)
            ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8mb4'
        );
    }

    protected function uninstallDb(): bool
    {
        return (bool) Db::getInstance()->execute('DROP TABLE IF EXISTS `' . _DB_PREFIX_ . pSQL(self::TABLE) . '`');
    }

    /* ---------------------------------- BO ---------------------------------- */

    public function getContent()
    {
        $output = '';
        $langId = (int) $this->context->language->id;

        if (Tools::isSubmit('moofaq_save')) {
            $output .= $this->processSave();
        }

        $idCategory = (int) Tools::getValue('moofaq_cat');
        $categories = Category::getSimpleCategories($langId);
        $items = $idCategory ? $this->getFaqRows($idCategory, $langId) : [];

        $action = $this->context->link->getAdminLink('AdminModules', true)
            . '&configure=' . $this->name . '&tab_module=' . $this->tab . '&module_name=' . $this->name;
        $token = Tools::getAdminTokenLite('AdminModules');

        $this->context->smarty->assign([
            'moofaq_action' => $action . '&token=' . $token,
            'moofaq_categories' => $categories,
            'moofaq_cat' => $idCategory,
            'moofaq_items' => $items,
            'moofaq_max_pos' => empty($items) ? 0 : (int) max(array_column($items, 'position')),
        ]);

        return $output . $this->display(__FILE__, 'views/templates/admin/configure.tpl');
    }

    protected function processSave()
    {
        $idCategory = (int) Tools::getValue('moofaq_cat');
        $langId = (int) $this->context->language->id;

        if ($idCategory <= 0) {
            return $this->displayError($this->trans('Pasirinkite kategoriją.', [], 'Modules.Moofaq.Admin'));
        }

        // Update existing rows
        foreach ((array) Tools::getValue('moofaq_q', []) as $id => $question) {
            $id = (int) $id;
            $question = trim((string) $question);
            $answer = trim((string) Tools::getValue('moofaq_a')[$id] ?? '');
            $position = (int) (Tools::getValue('moofaq_pos')[$id] ?? 0);

            if (Tools::getValue('moofaq_del')[$id] ?? false) {
                Db::getInstance()->delete(self::TABLE, 'id_moofaq=' . $id . ' AND id_category=' . $idCategory);
                continue;
            }
            if ($question === '' || $answer === '') {
                continue;
            }
            Db::getInstance()->update(self::TABLE, [
                'question' => pSQL($question),
                'answer' => pSQL($answer, true),
                'position' => $position,
            ], 'id_moofaq=' . $id . ' AND id_category=' . $idCategory);
        }

        // Insert new rows
        foreach ((array) Tools::getValue('moofaq_new_q', []) as $i => $question) {
            $question = trim((string) $question);
            $answer = trim((string) (Tools::getValue('moofaq_new_a')[$i] ?? ''));
            if ($question === '' || $answer === '') {
                continue;
            }
            Db::getInstance()->insert(self::TABLE, [
                'id_category' => $idCategory,
                'id_lang' => $langId,
                'question' => pSQL($question),
                'answer' => pSQL($answer, true),
                'position' => (int) (Tools::getValue('moofaq_new_pos')[$i] ?? 0),
            ]);
        }

        return $this->displayConfirmation($this->trans('FAQ išsaugota.', [], 'Modules.Moofaq.Admin'));
    }

    /* --------------------------------- Front -------------------------------- */

    public function hookDisplayCategoryFaq($params)
    {
        $idCategory = $this->currentCategoryId();
        if (!$idCategory) {
            return '';
        }

        $items = $this->getFaqRows($idCategory, (int) $this->context->language->id);
        if (empty($items)) {
            return '';
        }

        $this->context->smarty->assign(['moofaq_items' => $items]);
        return $this->display(__FILE__, 'views/templates/front/faq.tpl');
    }

    public function hookDisplayHeader()
    {
        try {
            $controller = $this->context->controller;
            if (!$controller || $controller->php_self !== 'category') {
                return '';
            }

            $idCategory = $this->currentCategoryId();
            if (!$idCategory) {
                return '';
            }

            $items = $this->getFaqRows($idCategory, (int) $this->context->language->id);
            if (empty($items)) {
                return '';
            }

            $entities = [];
            foreach ($items as $item) {
                $entities[] = [
                    '@type' => 'Question',
                    'name' => $item['question'],
                    'acceptedAnswer' => [
                        '@type' => 'Answer',
                        'text' => trim(strip_tags((string) $item['answer'])),
                    ],
                ];
            }

            $data = [
                '@context' => 'https://schema.org',
                '@type' => 'FAQPage',
                'mainEntity' => $entities,
            ];

            return '<script type="application/ld+json">'
                . json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
                . '</script>';
        } catch (\Throwable $e) {
            return '';
        }
    }

    protected function currentCategoryId(): int
    {
        $controller = $this->context->controller;
        if ($controller instanceof CategoryControllerCore && method_exists($controller, 'getCategory')) {
            $cat = $controller->getCategory();
            if ($cat && $cat->id) {
                return (int) $cat->id;
            }
        }

        return (int) Tools::getValue('id_category');
    }

    protected function getFaqRows(int $idCategory, int $idLang): array
    {
        return Db::getInstance()->executeS(
            'SELECT `id_moofaq`, `question`, `answer`, `position`
            FROM `' . _DB_PREFIX_ . pSQL(self::TABLE) . '`
            WHERE `id_category`=' . $idCategory . ' AND `id_lang`=' . $idLang . '
            ORDER BY `position`, `id_moofaq`'
        ) ?: [];
    }
}
