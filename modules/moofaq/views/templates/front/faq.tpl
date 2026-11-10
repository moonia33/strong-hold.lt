{if $moofaq_items|count}
  <div class="category-faq" itemscope itemtype="https://schema.org/FAQPage">
    <p class="category-faq__title">{l s='Dažnai užduodami klausimai' mod='moofaq'}</p>
    <div class="category-faq__items">
      {foreach from=$moofaq_items item=item name=faq}
        <details class="category-faq__item" itemscope itemprop="mainEntity" itemtype="https://schema.org/Question">
          <summary class="category-faq__question" itemprop="name">
            {$item.question|escape:'html':'UTF-8'}
            <span class="category-faq__chevron" aria-hidden="true"></span>
          </summary>
          <div class="category-faq__answer" itemscope itemprop="acceptedAnswer" itemtype="https://schema.org/Answer">
            <div itemprop="text">{$item.answer nofilter}</div>
          </div>
        </details>
      {/foreach}
    </div>
  </div>
{/if}
