{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}
{$componentName = 'product-miniature'}

{block name='product_miniature_item'}
  <article
    class="{$componentName} js-{$componentName}"
    data-id-product="{$product.id_product}"
    data-id-product-attribute="{$product.id_product_attribute}"
  >
    <div class="{$componentName}__inner">
      {block name='product_miniature_top'}
        <div class="{$componentName}__top">
          {include file='catalog/_partials/product-flags.tpl'}

          {include file='catalog/_partials/miniatures/product-image.tpl'}

          {include file='catalog/_partials/miniatures/product-quickview.tpl'}
        </div>
      {/block}

      {block name='product_miniature_bottom'}
        <div class="{$componentName}__bottom">
          <div class="{$componentName}__infos">
            {block name='product_name'}
              <a class="{$componentName}__title" href="{$product.url}" aria-label="{l s='View product %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Catalog'}">{$product.name}</a>
            {/block}

            {block name='product_variants'}
              {if $product.main_variants}
                <div class="{$componentName}__variants">
                  {include file='catalog/_partials/variant-links.tpl' variants=$product.main_variants}
                </div>
              {/if}
            {/block}

            {if $product.show_price}
              <div class="{$componentName}__prices{if $product.has_discount} {$componentName}__prices--discount{/if}">
                {block name='product_price'}
                  {hook h='displayProductPriceBlock' product=$product type="before_price"}

                  <div class="{$componentName}__price" aria-label="{l s='Price' d='Shop.Theme.Catalog'}">
                    {capture name='custom_price'}{hook h='displayProductPriceBlock' product=$product type='custom_price' hook_origin='products_list'}{/capture}
                    {if '' !== $smarty.capture.custom_price}
                      {$smarty.capture.custom_price nofilter}
                    {else}
                      {$product.price}
                    {/if}
                  </div>

                  {hook h='displayProductPriceBlock' product=$product type='unit_price'}

                  {hook h='displayProductPriceBlock' product=$product type='weight'}
                {/block}

                {block name='product_discount_price'}
                  {if $product.show_price}
                    <div class="{$componentName}__discount-price">
                      {if $product.has_discount}
                        {hook h='displayProductPriceBlock' product=$product type="old_price"}

                        <span class="{$componentName}__regular-price" aria-label="{l s='Regular price' d='Shop.Theme.Catalog'}">{$product.regular_price}</span>
                      {/if}
                    </div>
                  {/if}
                {/block}

                {block name='product_price_tax_exc'}
                  {if !empty($product.price_tax_exc)}
                    <div class="{$componentName}__price-tax-exc">
                      ({$product.price_tax_exc|string_format:"%.2f"} {$currency.sign} {l s='Be PVM' d='Shop.Theme.Catalog'})
                    </div>
                  {/if}
                {/block}

                {block name='product_availability'}
                  {* availability reflects the default combination; hide "out of stock" when any variant is still available *}
                  {if $product.show_availability && $product.availability_message && !($product.availability == 'unavailable' && $product.quantity_all_versions > 0)}
                    <div class="{$componentName}__availability {$componentName}__availability--{$product.availability}">
                      {include file="_partials/icons/truck.tpl" size=16}
                      <span>{$product.availability_message}</span>
                    </div>
                  {/if}
                {/block}
              </div>
            {/if}

            {block name='product_chips'}
              {if !empty($product.features)}
                <div class="{$componentName}__chips">
                  {foreach from=$product.features item=feature name=features}
                    {if $smarty.foreach.features.iteration > 4}{break}{/if}
                    <span class="{$componentName}__chip" title="{$feature.name}: {$feature.value}"><strong>{$feature.name}:</strong> {$feature.value}</span>
                  {/foreach}
                </div>
              {/if}
            {/block}

            {block name='product_reviews'}
              {hook h='displayProductListReviews' product=$product}
            {/block}
          </div>

          <div class="{$componentName}__actions">
            {* Products here always have combinations — link to the product page instead of qty+add-to-cart *}
            <a href="{$product.url}" class="product-miniature__details btn btn-outline-primary" aria-label="{l s='View product %product_name%' sprintf=['%product_name%' => $product.name] d='Shop.Theme.Catalog'}">
              {l s='See details' d='Shop.Theme.Actions'}
            </a>
          </div>
        </div>
      {/block}
    </div>
  </article>
{/block}
