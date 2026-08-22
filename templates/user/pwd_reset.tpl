{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Passwort zurücksetzen{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-7">
            <div class="card">
                <div class="card-header">
                    <span>Passwort zurücksetzen</span>
                </div>
                <div class="card-body">
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
                        <form action="/reset-password/{$token|escape:'url'}" method="post">
                            <div class="mb-3">
                                <label for="pwd" class="form-label">Neues Passwort:</label>
                                <input type="password" id="pwd" class="form-control" name="pwd" required>
                            </div>
                            <div class="mb-3">
                                <label for="pwd2" class="form-label">Neues Passwort wiederholen:</label>
                                <input type="password" id="pwd2" class="form-control" name="pwd2" required>
                            </div>
                            <input type="submit" class="btn btn-primary btn-block" value="Passwort speichern" style="margin-top: 5px; margin-bottom: 5px;">
                            <a href="/login" class="btn btn-danger btn-block" style="margin-top: 5px; margin-bottom: 5px;">Abbrechen</a>
                        </form>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/block}
