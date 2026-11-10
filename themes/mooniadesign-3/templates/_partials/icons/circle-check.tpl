{**
 * Lucide icon "circle-check" (https://lucide.dev - ISC License)
 * Usage: {include file="_partials/icons/circle-check.tpl" size=20 class="extra-class"}
 *}
<svg class="lucide lucide-circle-check{if !empty($class)} {$class}{/if}" aria-hidden="{if !empty($label)}false{else}true{/if}"{if !empty($label)} role="img" aria-label="{$label|escape}"{/if} focusable="false"{if !empty($attrs)} {$attrs nofilter}{/if} xmlns="http://www.w3.org/2000/svg" width="{$size|default:24}" height="{$size|default:24}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="{$stroke_width|default:2}" stroke-linecap="round" stroke-linejoin="round" > <circle cx="12" cy="12" r="10" /> <path d="m16 9-5.5 5.5L8 12" /> </svg>
