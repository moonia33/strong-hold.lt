{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}
{block name='my_account_links'}
  <a href="{$urls.pages.my_account}" class="account-link" data-role="back-to-your-account">
    {include file="_partials/icons/chevron-left.tpl"}
    <span>{l s='Back to your account' d='Shop.Theme.Customeraccount'}</span>
  </a>
  <a href="{$urls.pages.index}" class="account-link" data-role="home">
    {include file="_partials/icons/house.tpl"}
    <span>{l s='Home' d='Shop.Theme.Global'}</span>
  </a>
{/block}
