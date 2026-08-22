{extends 'layout.tpl'}

{block name=title}Einstellungen - SEC-Mjam{/block}

{block name=content}

    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <span>Einstellungen</span>
                </div>
                <div class="card-body">
                    <form method="post" action="/user/settings" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label class="form-label" for="email">E-mail Adresse</label>
                            <input class="form-control" type="email" name="email" id="email" value="{$user->email}" placeholder="Email">
                        </div>
                        <div class="form-check form-switch mb-3">
                            <label class="form-check-label" for="notify">E-mail Benachrichtigung</label>
                            <input class="form-check-input" type="checkbox" name="notify" id="notify" {if $user->notify == 1} checked{/if}>
                        </div>
                        <div class="form-check form-switch mb-3">
                            <label class="form-check-label" for="active">Account Aktiv</label>
                            <input class="form-check-input" type="checkbox" name="active" id="active" {if $user->active != '1'} value="1" {else} checked{/if}>
                        </div>
                        <input type="submit" value="Speichern" class="btn btn-success">
                        <a href="/user/changepwd" class="btn btn-primary">Passwort ändern</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}
