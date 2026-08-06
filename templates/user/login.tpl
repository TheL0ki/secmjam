{extends file="layout.tpl"}

{block name="title"}
    Login - SEC-Mjam
{/block}

{block name="content"}
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <form action="/login" method="post" class="form-horizontal">
                    <div class="form-group">
                        <label for="user" class="col-sm-2 control-label">User:</label>
                        <div class="col-sm-8">
                            <input type="text" name="user" id="user" class="form-control" placeholder="User">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="pwd" class="col-sm-2 control-label">Passwort:</label>
                        <div class="col-sm-8">
                            <input type="password" name="password" id="password" class="form-control" placeholder="Passwort">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="submit" class="col-sm-2"></label>
                        <div class="col-sm-8">
                            <input type="submit" class="btn btn-primary btn-block" value="Login">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="reg" class="col-sm-2"></label>
                        <div class="col-sm-8">
                            <div class="row">
                                <div class="col-xs-6">
                                    <a href="register.php" class="btn btn-default btn-block">Registrieren</a>
                                </div>
                                <div class="col-xs-6">
                                    <a href="pwd_forget.php" class="btn btn-default btn-block">Passwort vergessen</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
{/block}