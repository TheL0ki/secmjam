{extends 'layout.tpl'}

{block name=title}Edit Category - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    Edit Category
                </div>
                <div class="card-body">
                    <form action="/admin/categories/edit/{$category->id}" method="post">
                        <div class="mb-3">
                            <label class="form-label" for="name">Name</label>
                            <input class="form-control" type="text" id="name" name="name" value="{$category->name}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="points">Points</label>
                            <input class="form-control" type="number" step="1" pattern="[0-9]*" inputmode="numeric" id="points" name="points" value="{(int) $category->points}">
                        </div>
                        <div class="form-check form-switch mb-3">
                            <label class="form-check-label" for="multiple_extras">Allow multiple extras</label>
                            <input class="form-check-input" type="checkbox" name="multiple_extras" id="multiple_extras" {if $category->multiple_extras != '1'} value="1" {else} checked{/if}>
                        </div>
                        <div class="mb-3 d-flex justify-content-between">
                            <button class="btn btn-primary" type="submit">Speichern</button>
                            <a role="button" class="btn btn-primary" href="/admin/categories/edit/{$category->id}/menu">Menü bearbeiten</a>
                            <a role="button" class="btn btn-primary" href="/admin/categories/edit/{$category->id}/extras">Extras bearbeiten</a>
                            <a role="button" class="btn btn-secondary" href="/admin/categories">Abbrechen</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}