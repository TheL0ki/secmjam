{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Passwort vergessen{/block}

{block name=content}
    <div class="row">
        <div class="col-md-7">
            {if $sent}
                <div class="alert alert-success" role="alert">
                    Falls ein Konto mit dieser E-Mail-Adresse existiert, wurde ein Link zum Zurücksetzen des Passworts versendet.
                </div>
                <a href="/login" class="btn btn-primary">Zum Login</a>
            {else}
                <form class="form-horizontal" method="post" action="/forgot-password">
                    <div class="form-group">
                        <label for="email" class="col-sm-3 control-label">E-Mail Adresse:</label>
                        <div class="col-sm-7">
                            <input class="form-control" type="email" name="email" id="email" placeholder="E-Mail" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="submit" class="col-sm-3 control-label"></label>
                        <div class="col-sm-7">
                            <input class="form-control btn btn-primary" type="submit" value="Senden">
                        </div>
                    </div>
                </form>
            {/if}
        </div>
    </div>
{/block}
