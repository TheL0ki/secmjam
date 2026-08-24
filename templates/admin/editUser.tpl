{extends 'layout.tpl'}

{block name=title}Edit User - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    Edit User
                </div>
                <div class="card-body">
                    <form action="/admin/users/edit/{$user->uuid}" method="post">
                        <div class="mb-3">
                            <label class="form-label" for="username">Username</label>
                            <input class="form-control" type="text" id="username" name="username" value="{$user->user}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="firstname">Firstname</label>
                            <input class="form-control" type="text" id="firstname" name="firstname" value="{$user->firstname}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="lastname">Lastname</label>
                            <input class="form-control" type="text" id="lastname" name="lastname" value="{$user->lastname}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="email">E-Mail Address</label>
                            <input class="form-control" type="text" id="email" name="email" value="{$user->email}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="role">Role</label>
                            <select class="form-control" id="role" name="role">
                                <option value="user" {if $user->role == 'user'}selected{/if}>User</option>
                                <option value="manager" {if $user->role == 'manager'}selected{/if}>Manager</option>
                                <option value="admin" {if $user->role == 'admin'}selected{/if}>Admin</option>
                            </select>
                        </div>
                        <div class="mb-3 d-flex justify-content-between">
                            <button class="btn btn-primary" type="submit">Speichern</button>
                            <a role="button" class="btn btn-secondary" href="/admin/users">Abbrechen</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}