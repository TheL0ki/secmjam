{extends 'layout.tpl'}

{block name=title}Passwort vergessen - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-12 col-sm-10 col-md-6">
            <div class="card">
                <div class="card-header">
                    Passwort vergessen
                </div>
                <div class="card-body">
                    {if $sent}
                        <div class="alert alert-success" role="alert">
                            Falls ein Konto mit dieser E-Mail-Adresse existiert, wurde ein Link zum Zurücksetzen des Passworts versendet.
                        </div>
                        <a href="/login" class="btn btn-primary">Zum Login</a>
                    {else}
                    <form method="post" action="/forgot-password">
                        <div class="mb-3">
                            <label for="email" class="form-label">E-Mail Adresse:</label>
                            <input class="form-control" type="email" name="email" id="email" required>
                        </div>
                        <div class="mb-3">
                            <input class="btn btn-primary" type="submit" value="Senden">
                        </div>
                    </form>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/block}
