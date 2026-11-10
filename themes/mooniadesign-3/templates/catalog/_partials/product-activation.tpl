{**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *}
{if $page.admin_notifications}
  <div class="alert alert-warning" role="alert">
    <div class="container">
      {foreach $page.admin_notifications as $notif}
        <div>
          {include file="_partials/icons/circle-alert.tpl"}

          <p class="alert-text">{$notif.message}</p>
        </div>
      {/foreach}
    </div>
  </div>
{/if}
