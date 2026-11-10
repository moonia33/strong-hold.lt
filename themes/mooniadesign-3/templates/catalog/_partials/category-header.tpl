{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}
<div id="js-product-list-header">
  {if $listing.pagination.items_shown_from == 1}
    <div class="category__header">
      {if !empty($category.cover.bySize.category_cover.url)}
        <div class="category__cover">
          <picture>
            {if isset($category.cover.bySize.category_cover.sources.avif)}
              <source srcset="{$category.cover.bySize.category_cover.sources.avif}" type="image/avif">
            {/if}

            {if isset($category.cover.bySize.category_cover.sources.webp)}
              <source srcset="{$category.cover.bySize.category_cover.sources.webp}" type="image/webp">
            {/if}

            <img
              class="category__cover-image img-fluid"
              src="{$category.cover.bySize.category_cover.url}"
              width="{$category.cover.bySize.category_cover.width}"
              height="{$category.cover.bySize.category_cover.height}"
              alt="{if !empty($category.cover.legend)}{$category.cover.legend}{else}{$category.name}{/if}"
              fetchpriority="high"
            >
          </picture>
        </div>
      {/if}

      <div class="category__header-body">
        {include file='components/page-title-section.tpl' title=$category.name}

        {if $category.description}
        <div class="category__description-wrapper">
          <input type="checkbox" class="category__description-toggle" id="category-description-toggle" aria-hidden="true">
          <div class="category__description rich-text" id="category-description">{$category.description nofilter}</div>
          <label class="category__description-more" for="category-description-toggle" role="button">
            <span class="category__description-more-label">{l s='Read more' d='Shop.Theme.Catalog'}</span>
            <span class="category__description-less">{l s='Read less' d='Shop.Theme.Catalog'}</span>
            {include file="_partials/icons/chevron-down.tpl" size=16}
          </label>
        </div>
        {/if}
      </div>

      {if isset($subcategories) && $subcategories|@count > 0}
        {include file='catalog/_partials/subcategories.tpl' subcategories=$subcategories}
      {/if}
    </div>
  {/if}
</div>
