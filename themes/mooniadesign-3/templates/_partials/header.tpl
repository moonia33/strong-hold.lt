{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}

{$headerBanner = 'header-banner'}
{$headerTop = 'header-top'}
{$headerMenu = 'header-menu'}
{$headerNavFullWidth = 'header-nav-full-width'}

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

{block name='header_main'}
  <div class="site-header">
    <div class="site-header__container container-md">
      <div class="site-header__row row align-items-stretch">

        {* Logo (left column, spans both rows) *}
        <div class="site-header__logo col-6 col-md-3 col-xxl-2 d-flex align-items-center">
          {if $shop.logo_details}
            {if $page.page_name == 'index'}<h1 class="site-header__h1 mb-0">{/if}
              {renderLogo}
            {if $page.page_name == 'index'}</h1>{/if}
          {/if}
        </div>

        {* Right column: topbar + menu row *}
        <div class="site-header__main col-6 col-md-9 col-xxl-10 d-flex flex-column">

          {block name='header_nav'}
            {if !empty($smarty.capture.header_nav_1) || !empty($smarty.capture.header_nav_2)}
              <div class="{$headerTop} d-none d-md-flex">
                <div class="{$headerTop}__left">
                  {$smarty.capture.header_nav_1 nofilter}
                </div>

                <div class="{$headerTop}__right ms-auto">
                  {$smarty.capture.header_nav_2 nofilter}
                </div>
              </div>
            {/if}
          {/block}

          <div class="{$headerMenu}">
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
          </div>
        </div>
      </div>
    </div>

    {capture name="nav_full_width"}{hook h='displayNavFullWidth'}{/capture}
    {if !empty($smarty.capture.nav_full_width)}
      <div class="{$headerNavFullWidth}">
        {$smarty.capture.nav_full_width nofilter}
      </div>
    {/if}
  </div>
{/block}
