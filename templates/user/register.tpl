{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Registrierung{/block}

{block name=content}
    <script src='https://www.google.com/recaptcha/api.js'></script>
    {nocache}
        {if $success == TRUE}
            <div class="row">
                <div class="col-md-12">
                    <div class="alert alert-success" role="alert">
                        <b>Registrierung erfolgreich</b>, du wirst zum Login weitergeleitet.
                    </div>
                </div>
            </div>
        {elseif $error == TRUE}
            <div class="row">
                <div class="col-md-12">
                    <div class="alert alert-danger" role="alert">
                        <b>Etwas ist schief gelaufen</b>, bitte versuche es <a href="register.php">nocheinmal</a>.
                    </div>
                </div>
            </div>
        {else}
            {if $error_captcha == TRUE}
                <div class="row">
                    <div class="col-md-6">
                        <div class="alert alert-danger" role="alert">
                            <b>Bitte Captcha lösen</b>
                        </div>
                    </div>
                </div>
            {/if}
            {if $error_user == TRUE}
                <div class="row">
                    <div class="col-md-6">
                        <div class="alert alert-warning" role="alert">
                            <b>Der Username ist leider bereits vergeben</b>
                        </div>
                    </div>
                </div>
            {/if}
            {if $error_pwd == TRUE}
                <div class="row">
                    <div class="col-md-6">
                        <div class="alert alert-danger" role="alert">
                            <b>Die Passwörter stimmen nicht überein</b>
                        </div>
                    </div>
                </div>
            {/if}
            <div class="row">
                <div class="col-md-6">
                    <form class="form-horizontal" method="post" action="register.php?page=register">
                        {if $error_user == TRUE}
                            <div class="form-group has-warning has-feedback">
                                <label for="user" class="col-sm-2 control-label">User:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" type="text" name="user" placeholder="User">
                                    <span class="glyphicon glyphicon-warning-sign form-control-feedback" aria-hidden="true"></span>
                                    <span id="inputWarning2Status" class="sr-only">(warning)</span>
                                </div>
                            </div>
                        {else}
                            <div class="form-group">
                                <label for="user" class="col-sm-2 control-label">User:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" type="text" name="user" placeholder="User">
                                </div>
                            </div>
                        {/if}
                        <div class="form-group">
                            <label for="email" class="col-sm-2 control-label">E-Mail:</label>
                            <div class="col-sm-8">
                                <input class="form-control" type="text" name="email" placeholder="E-Mail">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="firstname" class="col-sm-2 control-label">Vorname:</label>
                            <div class="col-sm-8">
                                <input class="form-control" type="text" name="firstname" placeholder="Vorname">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="lastname" class="col-sm-2 control-label">Nachname:</label>
                            <div class="col-sm-8">
                                <input class="form-control" type="text" name="lastname" placeholder="Nachname">
                            </div>
                        </div>
                        {if $error_pwd == TRUE}
                            <div class="form-group has-error has-feedback">
                                <label for="pwd" class="col-sm-2 control-label">Passwort:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" type="password" name="pwd" placeholder="Passwort">
                                    <span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>
                                    <span id="inputError2Status" class="sr-only">(error)</span>
                                </div>
                            </div>
                        {else}
                            <div class="form-group">
                                <label for="pwd" class="col-sm-2 control-label">Passwort:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" type="password" name="pwd" placeholder="Passwort">
                                </div>
                            </div>
                        {/if}
                        {if $error_pwd == TRUE}
                            <div class="form-group has-error has-feedback">
                                <label for="pwd2" class="col-sm-2 control-label">Passwort bestätigen:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" type="password" name="pwd2" placeholder="Passwort wiederholen">
                                    <span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>
                                    <span id="inputError2Status" class="sr-only">(error)</span>
                                </div>
                            </div>
                        {else}
                            <div class="form-group">
                                <label for="pwd2" class="col-sm-2 control-label">Passwort bestätigen:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" type="password" name="pwd2" placeholder="Passwort wiederholen">
                                </div>
                            </div>
                        {/if}
                        {if $error_captcha == TRUE}
                            <div class="form-group has-error has-feedback" style="text-align: center;">
                                <label for="captcha" class="col-sm-2 control-label"></label>
                                <div class="col-sm-8">
                                    <div style="display: inline-block;" class="g-recaptcha" data-sitekey="6Le0SxwTAAAAAKxJsiY4VqGjZmmtTCLcgpswr4xv"></div>
                                </div>
                            </div>
                        {else}
                            <div class="form-group" style="text-align: center;">
                                <label for="captcha" class="col-sm-2 control-label"></label>
                                <div class="col-sm-8">
                                    <div style="display: inline-block;" class="g-recaptcha" data-sitekey="6Le0SxwTAAAAAKxJsiY4VqGjZmmtTCLcgpswr4xv"></div>
                                </div>
                            </div>
                        {/if}
                        <div class="form-group">
                            <label for="submit" class="col-sm-2 control-label"></label>
                            <div class="col-sm-8">
                                <input class="btn btn-primary btn-block" type="submit" value="Absenden">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        {/if}
    {/nocache}
{/block}
