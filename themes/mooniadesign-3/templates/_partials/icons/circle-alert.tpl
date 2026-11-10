{**
 * Lucide icon "circle-alert" (https://lucide.dev - ISC License)
 * Usage: {include file="_partials/icons/circle-alert.tpl" size=20 class="extra-class"}
 *}
<svg class="lucide lucide-circle-alert{if !empty($class)} {$class}{/if}" aria-hidden="{if !empty($label)}false{else}true{/if}"{if !empty($label)} role="img" aria-label="{$label|escape}"{/if} focusable="false"{if !empty($attrs)} {$attrs nofilter}{/if} xmlns="http://www.w3.org/2000/svg" width="{$size|default:24}" height="{$size|default:24}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="{$stroke_width|default:2}" stroke-linecap="round" stroke-linejoin="round" > <circle cx="12" cy="12" r="10" /> <line x1="12" x2="12" y1="8" y2="12" /> <line x1="12" x2="12.01" y1="16" y2="16" /> </svg>
