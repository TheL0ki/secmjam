{extends 'layout.tpl'}

{block name=title}Add Extra - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    Add Extra
                </div>
                <div class="card-body">
                    <form action="/admin/categories/edit/{$category->id}/extras/create" method="post">
                        <div class="mb-3">
                            <label class="form-label" for="name">Name</label>
                            <input class="form-control" type="text" id="name" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="slug">Slug</label>
                            <input class="form-control" type="text" id="slug" name="slug" placeholder="optional, generated from name">
                        </div>
                        <div class="form-check form-switch mb-3">
                            <label class="form-check-label" for="active">Active</label>
                            <input class="form-check-input" type="checkbox" name="active" id="active" value="1" checked>
                        </div>
                        <div class="mb-3 d-flex justify-content-between">
                            <button class="btn btn-primary" type="submit">Speichern</button>
                            <a role="button" class="btn btn-secondary" href="/admin/categories/edit/{$category->id}/extras">Abbrechen</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}
