{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}

{$headerBanner = 'header-banner'}
{$headerTop = 'header-top'}
{$headerMain = 'header-main'}
{$headerMenu = 'menu-bar'}

{capture name="header_banner"}{hook h='displayBanner'}{/capture}
{block name='header_banner'}
  {if !empty($smarty.capture.header_banner)}
    <div class="{$headerBanner}">
      {$smarty.capture.header_banner nofilter}
    </div>
  {/if}
{/block}

{capture name="header_nav_1"}{hook h='displayNav1'}{/capture}
{capture name="header_nav_2"}{hook h='displayNav2'}{/capture}

{* 1) Full-width topbar: contacts / info links | language & currency *}
{block name='header_nav'}
  {if !empty($smarty.capture.header_nav_1) || !empty($smarty.capture.header_nav_2)}
    <div class="{$headerTop} d-none d-md-block">
      <div class="container-md d-flex align-items-center">
        <div class="{$headerTop}__left">
          {$smarty.capture.header_nav_1 nofilter}
        </div>

        <div class="{$headerTop}__right ms-auto">
          {$smarty.capture.header_nav_2 nofilter}
        </div>
      </div>
    </div>
  {/if}
{/block}

{* 2) Main row: logo | search | signin | cart *}
{block name='header_main'}
  <div class="{$headerMain}">
    <div class="{$headerMain}__container container-md">
      <div class="{$headerMain}__row d-flex align-items-center gap-2 gap-md-3">
        <div class="{$headerMain}__logo d-flex align-items-center me-auto">
          {if $shop.logo_details}
            {if $page.page_name == 'index'}<h1 class="{$headerMain}__h1 mb-0">{/if}
              {renderLogo}
            {if $page.page_name == 'index'}</h1>{/if}
          {/if}
        </div>

        {hook h='displayTop'}

        <div id="_mobile_ps_customersignin" class="d-md-none d-flex col-auto">
          {* JUST PLACEHOLDER FOR RESPONSIVE COMPONENT TO LOAD REAL ONE *}
          <div class="header-block">
            <a href="{$urls.pages.my_account}" class="header-block__action-btn">
              {include file="_partials/icons/circle-user-round.tpl" class="header-block__icon"}
            </a>
          </div>
          {* JUST PLACEHOLDER FOR RESPONSIVE COMPONENT TO LOAD REAL ONE *}
        </div>

        {if !$configuration.is_catalog}
          <div id="_mobile_ps_shoppingcart" class="d-md-none d-flex col-auto">
            {* JUST PLACEHOLDER FOR RESPONSIVE COMPONENT TO LOAD REAL ONE *}
            <div class="header-block">
              <a href="{$urls.pages.cart}" class="header-block__action-btn">
                {include file="_partials/icons/shopping-cart.tpl" class="header-block__icon"}
                <span class="header-block__badge">{$cart.products_count}</span>
              </a>
            </div>
            {* JUST PLACEHOLDER FOR RESPONSIVE COMPONENT TO LOAD REAL ONE *}
          </div>
        {/if}

        <div class="d-xl-none d-flex col-auto">
          <div class="header-block">
            <button
              class="header-block__action-btn menu-toggle"
              type="button"
              data-bs-toggle="offcanvas"
              data-bs-target="#mobileMenu"
              aria-controls="mobileMenu"
              aria-label="{l s='Open mobile menu' d='Shop.Theme.Menu'}"
            >
              {include file="_partials/icons/menu.tpl" class="header-block__icon"}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
{/block}

{* 3) Full-width menu bar: main menu | secondary links (right) *}
{block name='header_menu_bar'}
  {capture name="nav_full_width"}{hook h='displayNavFullWidth'}{/capture}
  {if !empty($smarty.capture.nav_full_width)}
    <div class="{$headerMenu} d-none d-xl-block">
      <div class="{$headerMenu}__container container-md">
        <div class="{$headerMenu}__row">
          {$smarty.capture.nav_full_width nofilter}
        </div>
      </div>
    </div>
  {/if}
{/block}
