/**
 * Generates theme icon assets from lucide-static (ISC License, https://lucide.dev):
 *
 *   templates/_partials/icons/<name>.tpl   - Smarty partials for server-side rendering
 *   src/js/helpers/icons.ts                - inline SVG map for JS-injected icons
 *   src/scss/abstract/variables/_icons.scss- CSS mask data-URIs for pseudo-elements
 *
 * Usage: npm run icons
 * Add new names to ICONS below (or extend MATERIAL_MAP when migrating old markup).
 */
import {readFileSync, writeFileSync, mkdirSync, readdirSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {dirname, resolve} from 'node:path';

const themeRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const lucideDir = resolve(themeRoot, 'node_modules/lucide-static/icons');

// Material Icons codepoint -> Lucide name (used by the tpl migration script only)
export const MATERIAL_MAP = {
  e000: 'circle-x', // error
  e001: 'circle-alert', // error_outline
  e002: 'triangle-alert', // warning
  e0b0: 'phone', // call
  e0be: 'mail', // email
  e0cd: 'phone', // phone
  e145: 'plus', // add
  e148: 'circle-plus', // add_circle_outline
  e14b: 'ban', // block
  e14c: 'x', // clear
  e151: 'mail-open', // drafts
  e152: 'list-filter', // filter_list
  e153: 'flag', // flag
  e158: 'mail', // mail
  e15b: 'minus', // remove
  e254: 'square-pen', // mode_edit
  e2c4: 'file-down', // file_download
  e313: 'chevron-down', // keyboard_arrow_down
  e314: 'chevron-left', // keyboard_arrow_left
  e315: 'chevron-right', // keyboard_arrow_right
  e316: 'chevron-up', // keyboard_arrow_up
  e415: 'file-text', // picture_as_pdf
  e417: 'eye', // remove_red_eye
  e547: 'shopping-cart', // local_grocery_store
  e54e: 'tag', // local_offer
  e5c4: 'arrow-left', // arrow_back
  e5c5: 'chevron-down', // arrow_drop_down
  e5c8: 'arrow-right', // arrow_forward
  e5ca: 'check', // check
  e5cb: 'chevron-left', // chevron_left
  e5cc: 'chevron-right', // chevron_right
  e5cd: 'x', // close
  e5d2: 'menu', // menu
  e853: 'circle-user-round', // account_circle
  e854: 'shopping-cart', // add_shopping_cart
  e860: 'undo-2', // assignment_return
  e86c: 'circle-check', // check_circle
  e872: 'trash-2', // delete
  e879: 'log-out', // exit_to_app
  e87d: 'heart', // favorite
  e88a: 'house', // home
  e88e: 'info', // info
  e88f: 'info', // info_outline
  e8ad: 'printer', // print
  e8b0: 'receipt', // receipt
  e8b1: 'gift', // redeem
  e8b6: 'search', // search
  e8cc: 'shopping-cart', // shopping_cart
  e8db: 'thumbs-down', // thumb_down
  e8dc: 'thumbs-up', // thumb_up
  e8f4: 'eye', // visibility
  e916: 'calendar', // date_range
  ef3a: 'map-pin', // add_location_alt
  f00f: 'map-pin', // fmd_good
  f02e: 'user-round-cog', // manage_accounts
  f05b: 'tag', // sell
  f090: 'download', // download
  f1cc: 'shopping-bag', // shopping_bag
};

// Lucide names inlined for CSS pseudo-elements (caret, carousel, submenu arrows)
const MASK_ICONS = ['chevron-up', 'chevron-down', 'chevron-left', 'chevron-right'];

// Extra icons used only from JS (alert types, password visibility toggle)
const JS_ONLY = ['eye-off', 'triangle-alert', 'circle-x', 'circle-check', 'info', 'check', 'x', 'plus', 'minus'];

const tplHeader = (name) => `{**
 * Lucide icon "${name}" (https://lucide.dev - ISC License)
 * Usage: {include file="_partials/icons/${name}.tpl" size=20 class="extra-class"}
 *}
`;

const loadSvg = (name) => {
  const raw = readFileSync(resolve(lucideDir, `${name}.svg`), 'utf8');
  const match = raw.match(/<svg[\s\S]*<\/svg>/);

  if (!match) throw new Error(`No <svg> in ${name}.svg`);
  return match[0];
};

const svgInner = (svg) => svg.replace(/^<svg[^>]*>/, '').replace(/<\/svg>\s*$/, '').trim();

const encodeDataUri = (svg) => `url("data:image/svg+xml,${svg
  .replace(/"/g, "'")
  .replace(/</g, '%3C')
  .replace(/>/g, '%3E')
  .replace(/#/g, '%23')
  .replace(/\s+/g, ' ')}")`;

const names = [...new Set([...Object.values(MATERIAL_MAP), ...JS_ONLY])];
const tplIcons = [...new Set(Object.values(MATERIAL_MAP))];

// 1. Smarty partials
const iconsDir = resolve(themeRoot, 'templates/_partials/icons');
mkdirSync(iconsDir, {recursive: true});

for (const name of tplIcons) {
  const tpl = loadSvg(name)
    .replace('width="24"', 'width="{$size|default:24}"')
    .replace('height="24"', 'height="{$size|default:24}"')
    .replace('stroke-width="2"', 'stroke-width="{$stroke_width|default:2}"')
    .replace(
      `class="lucide lucide-${name}"`,
      `class="lucide lucide-${name}{if !empty($class)} {$class}{/if}" aria-hidden="{if !empty($label)}false{else}true{/if}"{if !empty($label)} role="img" aria-label="{$label|escape}"{/if} focusable="false"{if !empty($attrs)} {$attrs nofilter}{/if}`,
    )
    .replace(/\s+/g, ' ');

  writeFileSync(resolve(iconsDir, `${name}.tpl`), `${tplHeader(name)}${tpl}\n`);
}

// 2. JS icon map
const jsEntries = names
  .map((name) => `  '${name}': ${JSON.stringify(
    loadSvg(name)
      .replace(`class="lucide lucide-${name}"`, `class="icon lucide lucide-${name}" aria-hidden="true" focusable="false"`)
      .replace(/\s+/g, ' '),
  )},`)
  .join('\n');

writeFileSync(
  resolve(themeRoot, 'src/js/helpers/icons.ts'),
  `/**
 * Inline Lucide SVG icons for JS-injected markup (https://lucide.dev - ISC License).
 * Generated by tools/generate-icons.mjs - run "npm run icons" to regenerate.
 */

export const icons: Record<string, string> = {
${jsEntries}
};

export default icons;
`,
);

// 3. SCSS mask variables
const scssVars = MASK_ICONS.map((name) => {
  const uri = encodeDataUri(loadSvg(name).replace('stroke="currentColor"', 'stroke="black"'));
  return `$icon-${name}: ${uri};`;
}).join('\n');

writeFileSync(
  resolve(themeRoot, 'src/scss/abstract/variables/_icons.scss'),
  `// Lucide icons as CSS masks for pseudo-elements (https://lucide.dev - ISC License).
// Generated by tools/generate-icons.mjs - run "npm run icons" to regenerate.
// Usage: &::after { @include icon-mask($icon-chevron-down); }

${scssVars}
`,
);

console.log(`Generated ${tplIcons.length} icon partials, ${names.length} JS icons, ${MASK_ICONS.length} mask variables.`);
