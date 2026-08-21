{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Neue Bestellung anlegen{/block}
    
{block name=content}
    <div class="row mt-3">
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <span>Neue Bestellung anlegen</span>
                </div>
                <div class="card-body">                    
                    <form action="/orders/new" method="post">
                        <div class="mb-3">
                        <label for="category_id" class="form-label">Kategorie</label>
                        <select class="form-select" id="category_id" name="category_id" required>
                            <option value="">Bitte wählen</option>
                                {foreach item=category from=$categories}
                                    <option value="{$category->id}">{$category->name}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="autolock" class="form-label">Bestellung möglich bis</label>
                            <input class="form-control" id="autolock" name="autolock" type="datetime-local" step="900">
                        </div>
                        <div class="mb-3 form-check form-switch">
                            <input class="form-check-input" id="infomail" name="infomail" value="1" type="checkbox" role="switch" checked>
                            <label class="form-check-label" for="infomail">Infomail aussenden?</label>
                        </div>
                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary">Bestellung anlegen</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}
