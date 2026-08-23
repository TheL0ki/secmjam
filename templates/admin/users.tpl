{extends 'layout.tpl'}

{block name=title}User Administration - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <span>User Administration</span>
                        <a href="/admin/users/create" class="btn btn-primary">Create User</a>
                    </div>
                </div>
                <div class="card-body">
                    <table class="table table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $users as $user}
                                <tr>
                                    <td>{$user->firstname} {$user->lastname}</td>
                                    <td>{$user->email}</td>
                                    <td><span class="badge bg-primary p-2">{$user->role|capitalize}</span></td>
                                    <td>
                                        <a href="/admin/users/edit/{$user->uuid}" class="btn btn-primary">Edit</a>
                                        <a href="/admin/users/delete/{$user->uuid}" class="btn btn-danger">Delete</a>
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