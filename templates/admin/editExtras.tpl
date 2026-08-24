{extends 'layout.tpl'}

{block name=title}Extra Administration - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <span>Extra Administration</span>
                        <a href="/admin/categories/edit/{$category_id}/extras/create" class="btn btn-primary">Add Extra</a>
                    </div>
                </div>
                <div class="card-body">
                    <form id="save-extras" action="/admin/categories/edit/{$category_id}/extras" method="post"></form>
                    {foreach $extras as $extra}
                        <form id="delete-extra-{$extra->id}" action="/admin/categories/edit/{$category_id}/extras/delete/{$extra->id}" method="post"></form>
                    {/foreach}
                    <table class="table table-bordered align-middle">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Slug</th>
                                <th>Active</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $extras as $extra}
                                <tr>
                                    <td><input type="text" class="form-control" form="save-extras" name="extras[{$extra->id}][name]" id="extras[{$extra->id}][name]" value="{$extra->name}"></td>
                                    <td><input type="text" class="form-control" form="save-extras" name="extras[{$extra->id}][slug]" id="extras[{$extra->id}][slug]" value="{$extra->slug}"></td>
                                    <td>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" form="save-extras" name="extras[{$extra->id}][active]" id="extras[{$extra->id}][active]" value="1"{if $extra->active == 1} checked{/if}>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <button type="submit" form="delete-extra-{$extra->id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this extra?')">Löschen</button>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                    <div class="mb-3 d-flex justify-content-between">
                        <button type="submit" form="save-extras" class="btn btn-primary">Save</button>
                        <a role="button" class="btn btn-secondary" href="/admin/categories/edit/{$category_id}">Abbrechen</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}
