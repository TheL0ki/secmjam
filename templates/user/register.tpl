{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Registrierung{/block}

{block name=content}
    <script type="module" src="https://cdn.jsdelivr.net/npm/altcha@3.2.2/dist/main/altcha.min.js"></script>
    <script type="module" src="https://cdn.jsdelivr.net/npm/altcha@3.2.2/dist/i18n/de.js"></script>
    <div class="row">
        <div class="col-md-6">
            <form class="form-horizontal" method="post" action="/register">
                <div class="form-group">
                    <label for="user" class="col-sm-2 control-label">User:</label>
                    <div class="col-sm-8">
                        <input class="form-control" type="text" name="username" placeholder="User">
                    </div>
                </div>
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
                <div class="form-group">
                    <label for="pwd" class="col-sm-2 control-label">Passwort:</label>
                    <div class="col-sm-8">
                        <input class="form-control" type="password" name="password" placeholder="Passwort">
                    </div>
                </div>
                <div class="form-group">
                    <label for="pwd2" class="col-sm-2 control-label">Passwort bestätigen:</label>
                    <div class="col-sm-8">
                        <input class="form-control" type="password" name="pwd2" placeholder="Passwort wiederholen">
                    </div>
                </div>

                <div class="form-group" style="text-align: center;">
                    <label for="captcha" class="col-sm-2 control-label"></label>
                    <div class="col-sm-8">
                        <altcha-widget challenge="/altcha"></altcha-widget>
                    </div>
                </div>

                <div class="form-group">
                    <label for="submit" class="col-sm-2 control-label"></label>
                    <div class="col-sm-8">
                        <input class="btn btn-primary btn-block" type="submit" value="Absenden">
                    </div>
                </div>
            </form>
        </div>
    </div>
{/block}
