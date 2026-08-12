{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Kategorie auswählen{/block}
    
{block name=content}
    <form action="/orders/new" method="post">
        <div class="row">
            <div class="col-md-4 col-xs-12">
                <label for="category_id">Kategorie</label>
                <select class="form-control" id="category_id" name="category_id" required>
                    <option value="">Bitte wählen</option>
                    {foreach item=category from=$categories}
                        <option value="{$category->id}">{$category->name}</option>
                    {/foreach}
                </select>
            </div>
        </div>
        <div class="row" style="margin-top: 15px;">
            <div class="col-md-4 col-xs-12">
                <label for="autolock">Bestellung möglich bis</label>
                <input class="form-control" id="autolock" name="autolock" type="datetime-local" step="900">
            </div>
        </div>
        <div class="row" style="margin-top: 15px;">
            <div class="col-xs-12">
                <label>
                    <input type="checkbox" name="infomail" value="1" checked>
                    Infomail aussenden?
                </label>
            </div>
        </div>
        <div class="row" style="margin-top: 20px;">
            <div class="col-xs-12">
                <button type="submit" class="btn btn-primary">Bestellung anlegen</button>
            </div>
        </div>
    </form>
{/block}
