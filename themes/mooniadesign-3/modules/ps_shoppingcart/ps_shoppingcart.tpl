{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}

<div id="_desktop_ps_shoppingcart" class="col-auto d-flex align-items-center">
  <div class="ps-shoppingcart">
    <div class="header-block d-flex align-items-center blockcart cart-preview {if $cart.products_count> 0}header-block--active{else}inactive{/if}" data-refresh-url="{$refresh_url}">
      {if $cart.products_count> 0}
        <a class="header-block__action-btn pe-md-0" rel="nofollow" href="{$cart_url}" aria-label="{l s='View cart (%d products)' d='Shop.Theme.Checkout' sprintf=[$cart.products_count]}">
      {else}
        <span class="header-block__action-btn pe-md-0">
      {/if}

      {include file="_partials/icons/shopping-cart.tpl" class="header-block__icon"}
      <span class="header-block__badge">{$cart.products_count}</span>

      {if $cart.products_count> 0}
        </a>
      {else}
        </span>
      {/if}

      {if $cart.products_count > 0}
        <div class="cart-preview__dropdown" role="dialog" aria-label="{l s='Shopping cart' d='Shop.Theme.Checkout'}">
          <p class="cart-preview__title">{l s='Shopping Cart' d='Shop.Theme.Checkout'}</p>

          <ul class="cart-preview__items">
            {foreach from=$cart.products item=product}
              <li class="cart-preview__item">
                <a class="cart-preview__item-link" href="{$product.url}">
                  {if $product.cover}
                    <img
                      class="cart-preview__item-image"
                      src="{$product.cover.small.url}"
                      alt="{$product.name|truncate:60:'...'}"
                      loading="lazy"
                      width="{$product.cover.small.width}"
                      height="{$product.cover.small.height}"
                    >
                  {/if}

                  <span class="cart-preview__item-body">
                    <span class="cart-preview__item-name">{$product.name|truncate:60:'...'}</span>
                    {if $product.attributes}
                      <span class="cart-preview__item-attributes">{$product.attributes}</span>
                    {/if}
                    <span class="cart-preview__item-meta">
                      {$product.quantity} × {$product.price}
                    </span>
                  </span>
                </a>
              </li>
            {/foreach}
          </ul>

          <div class="cart-preview__subtotal">
            <span>{l s='Subtotal' d='Shop.Theme.Checkout'}</span>
            <span class="cart-preview__subtotal-value">{$cart.subtotals.products.amount}</span>
          </div>

          <div class="cart-preview__actions">
            <a class="btn btn-outline-primary" href="{$cart_url}">{l s='View Cart' d='Shop.Theme.Checkout'}</a>
            <a class="btn btn-primary" href="{$urls.pages.order}">{l s='Checkout' d='Shop.Theme.Checkout'}</a>
          </div>
        </div>
      {/if}
    </div>
  </div>
</div>
