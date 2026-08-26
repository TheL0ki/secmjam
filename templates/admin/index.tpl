{extends 'layout.tpl'}

{block name=title}Admin - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    Admin
                </div>
                <div class="card-body">
                    <div class="d-flex gap-2">
                        <a href="/admin/users" class="btn btn-primary flex-fill">Benutzer</a>
                        <a href="/admin/categories" class="btn btn-primary flex-fill">Kategorien</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}