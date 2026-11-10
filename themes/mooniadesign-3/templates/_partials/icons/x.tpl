{**
 * Lucide icon "x" (https://lucide.dev - ISC License)
 * Usage: {include file="_partials/icons/x.tpl" size=20 class="extra-class"}
 *}
<svg class="lucide lucide-x{if !empty($class)} {$class}{/if}" aria-hidden="{if !empty($label)}false{else}true{/if}"{if !empty($label)} role="img" aria-label="{$label|escape}"{/if} focusable="false"{if !empty($attrs)} {$attrs nofilter}{/if} xmlns="http://www.w3.org/2000/svg" width="{$size|default:24}" height="{$size|default:24}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="{$stroke_width|default:2}" stroke-linecap="round" stroke-linejoin="round" > <path d="M18 6 6 18" /> <path d="m6 6 12 12" /> </svg>
