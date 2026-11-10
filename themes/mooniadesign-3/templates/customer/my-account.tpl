{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}
{extends file='customer/page.tpl'}

{$componentName = 'account-menu'}

{block name='page_title'}
  {l s='Welcome' d='Shop.Theme.Customeraccount'} {$customer.firstname} {$customer.lastname}
{/block}

{block name='page_content'}
  <div class="{$componentName} {$componentName}--main">
    {block name='display_customer_account_top'}
      {hook h='displayCustomerAccountTop'}
    {/block}

    <a class="{$componentName}__link" id="identity_main_link" href="{$urls.pages.identity}">
      {include file="_partials/icons/circle-user-round.tpl" class="{$componentName}__icon"}
      {l s='Information' d='Shop.Theme.Customeraccount'}
    </a>

    {if $customer.addresses|count}
      <a class="{$componentName}__link" id="addresses_main_link" href="{$urls.pages.addresses}">
        {include file="_partials/icons/map-pin.tpl" class="{$componentName}__icon"}
        {l s='Addresses' d='Shop.Theme.Customeraccount'}
      </a>
    {else}
      <a class="{$componentName}__link" id="address_main_link" href="{$urls.pages.address}">
        {include file="_partials/icons/map-pin.tpl" class="{$componentName}__icon"}
        {l s='Add first address' d='Shop.Theme.Customeraccount'}
      </a>
    {/if}

    {if !$configuration.is_catalog}
      <a class="{$componentName}__link" id="history_main_link" href="{$urls.pages.history}">
        {include file="_partials/icons/calendar.tpl" class="{$componentName}__icon"}
        {l s='Order history and details' d='Shop.Theme.Customeraccount'}
      </a>
    {/if}

    {if !$configuration.is_catalog}
      <a class="{$componentName}__link" id="order_slips_main_link" href="{$urls.pages.order_slip}">
        {include file="_partials/icons/receipt.tpl" class="{$componentName}__icon"}
        {l s='Credit slips' d='Shop.Theme.Customeraccount'}
      </a>
    {/if}

    {if $configuration.voucher_enabled && !$configuration.is_catalog}
      <a class="{$componentName}__link" id="discounts_main_link" href="{$urls.pages.discount}">
        {include file="_partials/icons/tag.tpl" class="{$componentName}__icon"}
        {l s='Vouchers' d='Shop.Theme.Customeraccount'}
      </a>
    {/if}

    {if $configuration.return_enabled && !$configuration.is_catalog}
      <a class="{$componentName}__link" id="returns_main_link" href="{$urls.pages.order_follow}">
        {include file="_partials/icons/undo-2.tpl" class="{$componentName}__icon"}
        {l s='Merchandise returns' d='Shop.Theme.Customeraccount'}
      </a>
    {/if}

    {block name='display_customer_account'}
      {hook h='displayCustomerAccount'}
    {/block}

    <a class="{$componentName}__link {$componentName}__link--signout" href="{$urls.actions.logout}">
      {include file="_partials/icons/log-out.tpl" class="{$componentName}__icon"}
      {l s='Sign out' d='Shop.Theme.Actions'}
    </a>
  </div>
{/block}

{block name='account_link'}{/block}
