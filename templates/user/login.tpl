{extends file="layout.tpl"}

{block name="title"}
    Login - SEC-Mjam
{/block}

{block name="content"}
    <div class="row mt-3">
        <div class="col-12 col-sm-10 col-md-6">
            <div class="card">
                <div class="card-header">
                    Login
                </div>
                <div class="card-body">
                    <form action="/login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">User</label>
                            <input type="text" name="username" id="username" class="form-control" autocomplete="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Passwort</label>
                            <input type="password" name="password" id="password" class="form-control" autocomplete="current-password" required>
                        </div>
                        <div class="d-grid mb-3">
                            <input type="submit" class="btn btn-primary" value="Login">
                        </div>
                    </form>
                    <div class="d-flex justify-content-between">
                        <a href="/register">Registrieren</a>
                        <a href="/forgot-password">Passwort vergessen</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}
