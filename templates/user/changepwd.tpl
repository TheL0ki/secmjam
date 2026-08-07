{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Passwort ändern{/block}

{block name=content}
    {nocache}
    <form class="form-horizontal" action="changepwd.php?page=change" method="post">
        <div class="row">
            {if $success == TRUE}
                <div class="col-md-12">
                    <div class="alert alert-success" role="alert">
                        Einstellungen gespeichert
                    </div>
                </div>
            {elseif $error == TRUE}
                <div class="col-md-12">
                    <div class="alert alert-danger" role="alert">
                        <b>Es ist ein Fehler aufgetreten</b>, bitte versuche es <a href="changepwd.php">nocheinmal</a>
                    </div>
                </div>
            {else}
                <div class="col-md-7">
                    <div class="form-group">
                        <label for="oldpwd" class="col-sm-4 control-label">Aktuelles Passwort:</label>
                        <div class="col-sm-8">
                            <input id="oldpwd" name="oldpwd" class="form-control" type="password" placeholder="Altes Passwort">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="pwd" class="col-sm-4 control-label">Neues Passwort:</label>
                        <div class="col-sm-8">
                            <input type="password" id="pwd" class="form-control" name="pwd" placeholder="Neus Passwort">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="pwd2" class="col-sm-4 control-label">Neues Passwort wiederholen</label>
                        <div class="col-sm-8">
                            <input type="password" id="pwd2" class="form-control" name="pwd2" placeholder="Neues Passwort">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="submit" class="btn btn-primary btn-block" value="Passwort ändern" style="margin-top: 5px; margin-bottom: 5px;">
                        </div>
                        <div class="col-md-6">
                            <a href="user_settings.php" class="btn btn-danger btn-block" style="margin-top: 5px; margin-bottom: 5px;">Abbrechen</a>
                        </div>
                    </div>
                </div>
            {/if}
        </div>
    </form>
    {/nocache}
{/block}
