{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Passwort ändern{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <span>Passwort ändern</span>
                </div>
                <div class="card-body">
                    <form action="/user/changepwd" method="post">
                        <div class="mb-3">
                            <label class="form-label" for="oldpwd">Aktuelles Passwort</label>
                            <input class="form-control" id="oldpwd" name="oldpwd" type="password">
                        </div>
                        <div class="mb-3">
                            <label for="pwd" class="form-label">Neues Passwort:</label>
                            <input type="password" id="pwd" class="form-control" name="pwd">
                        </div>
                        <div class="mb-3">
                            <label for="pwd2" class="form-label">Neues Passwort wiederholen</label>
                            <input type="password" id="pwd2" class="form-control" name="pwd2">
                        </div>
                        <input type="submit" class="btn btn-primary btn-block" value="Passwort ändern" style="margin-top: 5px; margin-bottom: 5px;">
                        <a href="/user/settings" class="btn btn-danger btn-block" style="margin-top: 5px; margin-bottom: 5px;">Abbrechen</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}
