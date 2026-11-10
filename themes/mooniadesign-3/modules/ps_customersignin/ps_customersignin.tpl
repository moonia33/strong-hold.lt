{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}

<div id="_desktop_ps_customersignin">
  <div class="ps-customersignin">
    {if $customer.is_logged}
      <div class="dropdown header-block">
        <button
          class="dropdown-toggle header-block__action-btn border-0 bg-transparent"
          id="userMenuButton"
          data-bs-toggle="dropdown"
          aria-haspopup="true"
          aria-expanded="false"
          aria-label="{l s='View my account (%customerName%)' sprintf=['%customerName%' => $customerName] d='Shop.Theme.Customeraccount'}"
        >
          {include file="_partials/icons/circle-user-round.tpl" class="header-block__icon"}
          <span class="header-block__title d-none d-md-block d-lg-none">
            {$customer.firstname|capitalize|truncate:2:".":true}{$customer.lastname|capitalize|truncate:2:".":true}
          </span>
          <span class="header-block__title d-lg-inline d-none">
            {$customerName|capitalize|truncate:22:"...":true}
          </span>
        </button>

        <div class="dropdown-menu dropdown-menu-start" aria-labelledby="userMenuButton">
          <a
            href="{$urls.pages.my_account}"
            class="dropdown-item"
            rel="nofollow"
            {if $urls.current_url == $urls.pages.my_account}aria-current="page"{/if}
          >
            {include file="_partials/icons/user-round-cog.tpl" class="me-2"}
            {l s='Your account' d='Shop.Theme.Customeraccount'}
          </a>

          <div class="dropdown-divider"></div>

          <a
            href="{$urls.pages.identity}"
            class="dropdown-item"
            rel="nofollow"
            {if $urls.current_url == $urls.pages.identity}aria-current="page"{/if}
          >
            {include file="_partials/icons/circle-user-round.tpl" class="me-2"}
            {l s='Information' d='Shop.Theme.Customeraccount'}
          </a>

          {if $customer.addresses|count}
            <a
              href="{$urls.pages.addresses}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.addresses}aria-current="page"{/if}
            >
              {include file="_partials/icons/map-pin.tpl" class="me-2"}
              {l s='Addresses' d='Shop.Theme.Customeraccount'}
            </a>
          {else}
            <a
              href="{$urls.pages.address}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.address}aria-current="page"{/if}
            >
              {include file="_partials/icons/map-pin.tpl" class="me-2"}
              {l s='Add first address' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if !$configuration.is_catalog}
            <a
              href="{$urls.pages.history}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.history}aria-current="page"{/if}
            >
              {include file="_partials/icons/calendar.tpl" class="me-2"}
              {l s='Orders' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if !$configuration.is_catalog}
            <a
              href="{$urls.pages.order_slip}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.order_slip}aria-current="page"{/if}
            >
              {include file="_partials/icons/receipt.tpl" class="me-2"}
              {l s='Credit slips' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if $configuration.voucher_enabled && !$configuration.is_catalog}
            <a
              href="{$urls.pages.discount}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.discount}aria-current="page"{/if}
            >
              {include file="_partials/icons/tag.tpl" class="me-2"}
              {l s='Vouchers' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          {if $configuration.return_enabled && !$configuration.is_catalog}
            <a
              href="{$urls.pages.order_follow}"
              class="dropdown-item"
              rel="nofollow"
              {if $urls.current_url == $urls.pages.order_follow}aria-current="page"{/if}
            >
              {include file="_partials/icons/undo-2.tpl" class="me-2"}
              {l s='Merchandise returns' d='Shop.Theme.Customeraccount'}
            </a>
          {/if}

          <div class="dropdown-divider"></div>

          <a 
            href="{$logout_url}"
            class="dropdown-item"
            rel="nofollow"
          >
            {include file="_partials/icons/log-out.tpl" class="me-2"}
            {l s='Sign out' d='Shop.Theme.Actions'}
          </a>
        </div>
      </div>
    {else}
      <div class="header-block">
        <a
          href="{$urls.pages.authentication}?back={$urls.current_url|urlencode}"
          class="header-block__action-btn"
          rel="nofollow"
          aria-label="{l s='Sign in' d='Shop.Theme.Actions'}"
        >
          {include file="_partials/icons/circle-user-round.tpl" class="header-block__icon"}
          <span class="d-none d-md-inline header-block__title">
            {l s='Sign in' d='Shop.Theme.Actions'}
          </span>
        </a>
      </div>
    {/if}
  </div>
</div>
