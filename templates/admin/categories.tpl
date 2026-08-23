{extends 'layout.tpl'}

{block name=title}Category Administration - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <span>Category Administration</span>
                    <a href="/admin/categories/create" class="btn btn-primary">Create Category</a>
                </div>
                </div>
                <div class="card-body">
                    <table class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th class="text-center">Points</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $categories as $category}
                                <tr>
                                    <td>{$category->name}</td>
                                    <td class="text-center">{$category->points}</td>
                                    <td class="text-center">
                                        <a href="/admin/categories/edit/{$category->id}" class="btn btn-primary">Edit</a>
                                        <a href="/admin/categories/delete/{$category->id}" class="btn btn-danger">Delete</a>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
{/block}