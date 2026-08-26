{extends 'layout.tpl'}

{block name=title}Create User - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    Create User
                </div>
                <div class="card-body">
                    <form action="/admin/users/create" method="post">
                        <div class="mb-3">
                            <label class="form-label" for="username">Username</label>
                            <input class="form-control" type="text" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="firstname">Firstname</label>
                            <input class="form-control" type="text" id="firstname" name="firstname" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="lastname">Lastname</label>
                            <input class="form-control" type="text" id="lastname" name="lastname" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="email">E-Mail Address</label>
                            <input class="form-control" type="email" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="role">Role</label>
                            <select class="form-control" id="role" name="role">
                                <option value="user" selected>User</option>
                                <option value="manager">Manager</option>
                                <option value="admin">Admin</option>
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
