{extends 'layout.tpl'}

{block name=title}Menu Administration - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <span>Menu Administration</span>
                        <a href="/admin/categories/edit/{$category_id}/menu/create" class="btn btn-primary">Add Item</a>
                    </div>
                </div>
                <div class="card-body">
                    <form id="save-menu" action="/admin/categories/edit/{$category_id}/menu" method="post"></form>
                    {foreach $menu as $item}
                        <form id="delete-menu-{$item->id}" action="/admin/categories/edit/{$category_id}/menu/delete/{$item->id}" method="post"></form>
                    {/foreach}
                    <table class="table table-bordered align-middle">
                        <thead>
                            <tr>
                                <th>Sub Item</th>
                                <th>Item</th>
                                <th>Size</th>
                                <th>Price</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $menu as $item}
                                <tr>
                                    <td><input type="text" class="form-control" form="save-menu" name="items[{$item->id}][sub_category]" id="items[{$item->id}][sub_category]" value="{$item->sub_category}"></td>
                                    <td><input type="text" class="form-control" form="save-menu" name="items[{$item->id}][item]" id="items[{$item->id}][item]" value="{$item->item}"></td>
                                    <td><input type="text" class="form-control" form="save-menu" name="items[{$item->id}][size]" id="items[{$item->id}][size]" value="{$item->size}"></td>
                                    <td><input type="number" step="0.01" class="form-control" form="save-menu" name="items[{$item->id}][price]" id="items[{$item->id}][price]" value="{$item->price}"></td>
                                    <td class="text-center">
                                        <button type="submit" form="delete-menu-{$item->id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this item?')">Löschen</button>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                    <div class="mb-3 d-flex justify-content-between">
                        <button type="submit" form="save-menu" class="btn btn-primary">Save</button>
                        <a role="button" class="btn btn-secondary" href="/admin/categories">Abbrechen</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}
