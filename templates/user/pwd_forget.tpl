{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Passwort vergessen{/block}

{block name=content}
    <div class="row">
        <div class="col-md-7">
            <form class="form-horizontal" method="post" action="pwd_forget.php?page=send">
                <div class="form-group">
                    <label for="email" class="col-sm-3 control-label">E-Mail Adresse:</label>
                    <div class="col-sm-7">
                        <input class="form-control" type="text" name="email" id="email" placeholder="E-Mail">
                    </div>
                </div>
                <div class="form-group">
                    <label for="submit" class="col-sm-3 control-label"></label>
                    <div class="col-sm-7">
                        <td><input class="form-control btn btn-primary" type="submit" value="Senden">
                    </div>
                </div>
            </form>
        </div>
    </div>
{/block}
