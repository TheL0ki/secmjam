{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Kategorie auswählen{/block}
    
{block name=content}
    <div class="row">
        <div class="col-md-4 col-xs-12">
            <select class="form-control" onchange="if (this.value) location.href='/orders/menu/' + this.value">
                <option></option>
                {foreach item=category from=$categories}
                    <option value="{$category->id}">{$category->name}</option>
                {/foreach}
            </select>
        </div>
    </div>
{/block}