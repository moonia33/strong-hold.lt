<div class="panel moofaq-panel">
  <h3><i class="icon icon-question-sign"></i> {l s='Kategorijos FAQ' mod='moofaq'}</h3>
  <p class="help-block">{l s='Pasirinkite kategoriją ir pridėkite klausimus bei atsakymus. Jie bus rodomi kategorijos puslapyje ir įtraukti į FAQPage schema (SEO).' mod='moofaq'}</p>

  <form method="get" action="" class="form-inline moofaq-cat-form" style="margin-bottom:1rem">
    <input type="hidden" name="controller" value="AdminModules">
    <input type="hidden" name="configure" value="moofaq">
    <input type="hidden" name="token" value="">
    <div class="form-group">
      <label>{l s='Kategorija:' mod='moofaq'}</label>
      <select name="moofaq_cat" class="form-control" onchange="this.form.submit()">
        <option value="0">—</option>
        {foreach from=$moofaq_categories item=cat}
          <option value="{$cat.id_category}" {if $cat.id_category == $moofaq_cat}selected{/if}>{$cat.name|escape:'html':'UTF-8'}</option>
        {/foreach}
      </select>
    </div>
  </form>

  {if $moofaq_cat}
    <form method="post" action="{$moofaq_action}">
      <input type="hidden" name="moofaq_cat" value="{$moofaq_cat}">
      <input type="hidden" name="moofaq_save" value="1">

      <table class="table" id="moofaq-table">
        <thead>
          <tr>
            <th style="width:60px">{l s='Poz.' mod='moofaq'}</th>
            <th>{l s='Klausimas' mod='moofaq'}</th>
            <th>{l s='Atsakymas' mod='moofaq'}</th>
            <th style="width:70px">{l s='Trinti' mod='moofaq'}</th>
          </tr>
        </thead>
        <tbody>
          {foreach from=$moofaq_items item=item}
            <tr>
              <td><input type="number" name="moofaq_pos[{$item.id_moofaq}]" value="{$item.position}" class="form-control" style="width:70px"></td>
              <td><input type="text" name="moofaq_q[{$item.id_moofaq}]" value="{$item.question|escape:'html':'UTF-8'}" class="form-control"></td>
              <td><textarea name="moofaq_a[{$item.id_moofaq}]" class="form-control" rows="2">{$item.answer|escape:'html':'UTF-8'}</textarea></td>
              <td class="text-center"><input type="checkbox" name="moofaq_del[{$item.id_moofaq}]" value="1"></td>
            </tr>
          {/foreach}
        </tbody>
      </table>

      <button type="button" class="btn btn-default" id="moofaq-add-row"><i class="icon-plus"></i> {l s='Pridėti klausimą' mod='moofaq'}</button>

      <div class="panel-footer" style="margin-top:1rem">
        <button type="submit" class="btn btn-primary"><i class="process-icon-save"></i> {l s='Išsaugoti' mod='moofaq'}</button>
      </div>
    </form>
  {/if}
</div>

<script>
document.getElementById('moofaq-add-row').addEventListener('click', function () {
  var tbody = document.querySelector('#moofaq-table tbody');
  var idx = tbody.querySelectorAll('tr.moofaq-new').length;
  var tr = document.createElement('tr');
  tr.className = 'moofaq-new';
  tr.innerHTML = '<td><input type="number" name="moofaq_new_pos[]" value="' + (idx + {$moofaq_max_pos} + 1) + '" class="form-control" style="width:70px"></td>' +
    '<td><input type="text" name="moofaq_new_q[]" class="form-control" placeholder="{l s='Klausimas' mod='moofaq'}"></td>' +
    '<td><textarea name="moofaq_new_a[]" class="form-control" rows="2" placeholder="{l s='Atsakymas' mod='moofaq'}"></textarea></td>' +
    '<td></td>';
  tbody.appendChild(tr);
});
</script>
