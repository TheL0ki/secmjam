{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Passwort zurücksetzen{/block}

{block name=content}
    <div class="row">
        <div class="col-md-7">
            {if $invalid}
                <div class="alert alert-danger" role="alert">
                    Der Link ist ungültig oder abgelaufen.
                </div>
                <a href="/forgot-password" class="btn btn-primary">Neuen Link anfordern</a>
            {else}
                {if $error}
                    <div class="alert alert-danger" role="alert">
                        {$error}
                    </div>
                {/if}
                <form class="form-horizontal" action="/reset-password/{$token|escape:'url'}" method="post">
                    <div class="form-group">
                        <label for="pwd" class="col-sm-4 control-label">Neues Passwort:</label>
                        <div class="col-sm-8">
                            <input type="password" id="pwd" class="form-control" name="pwd" placeholder="Neues Passwort" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="pwd2" class="col-sm-4 control-label">Neues Passwort wiederholen:</label>
                        <div class="col-sm-8">
                            <input type="password" id="pwd2" class="form-control" name="pwd2" placeholder="Neues Passwort" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="submit" class="btn btn-primary btn-block" value="Passwort speichern" style="margin-top: 5px; margin-bottom: 5px;">
                        </div>
                        <div class="col-md-6">
                            <a href="/login" class="btn btn-danger btn-block" style="margin-top: 5px; margin-bottom: 5px;">Abbrechen</a>
                        </div>
                    </div>
                </form>
            {/if}
        </div>
    </div>
{/block}
