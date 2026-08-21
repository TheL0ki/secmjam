{extends 'layout.tpl'}

{block name=title}Einstellungen - SEC-Mjam{/block}

{block name=content}
    {nocache}
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
                    Einstellungen gespeichert
                </div>
            </div>
        {else}
            <div class="col-md-7">
                <form class="form-horizontal" method="post" action="/user/settings" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="email" class="col-sm-4 control-label">E-mail Adresse:</label>
                        <div class="col-sm-8">
                            <input type="email" name="email" class="form-control" id="email" value="{$user->email}" placeholder="Email">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="mail_check" class="col-sm-4 control-label">E-mail Benachrichtigung?</label>
                        <div class="col-sm-8">
                            <input type="checkbox" name="notify" id="notify" {if $user->notify == 1} checked{/if}>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="active" class="col-sm-4 control-label">Account Aktiv?</label>
                        <div class="col-sm-8">
                            <input type="checkbox" name="active" id="active" {if $user->active != '1'} value="1" {else} checked{/if}>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="submit" value="Speichern" class="btn btn-success btn-block" style="margin-top: 5px; margin-bottom: 5px;"">
                        </div>
                        <div class="col-md-6">
                            <a href="/user/changepwd" class="btn btn-primary btn-block" style="margin-top: 5px; margin-bottom: 5px;">Passwort ändern</a>
                        </div>
                    </div>
                </form>
            </div>
        {/if}
    </div>
    {/nocache}
{/block}
