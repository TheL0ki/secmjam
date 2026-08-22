{extends 'layout.tpl'}

{block name=title}Registrierung - SEC-Mjam{/block}

{block name=content}
    <script type="module" src="https://cdn.jsdelivr.net/npm/altcha@3.2.2/dist/main/altcha.min.js"></script>
    <script type="module" src="https://cdn.jsdelivr.net/npm/altcha@3.2.2/dist/i18n/de.js"></script>
    <div class="row mt-3">
        <div class="col-12 col-sm-10 col-md-6">
            <div class="card">
                <div class="card-header">
                    Registrierung
                </div>
                <div class="card-body">
                    <form method="post" action="/register">
                        <div class="mb-3">
                            <label for="user" class="form-label">User:</label>
                            <input class="form-control" type="text" name="username" autocomplete="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">E-Mail:</label>
                            <input class="form-control" type="text" name="email" autocomplete="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="firstname" class="form-label">Vorname:</label>
                            <input class="form-control" type="text" name="firstname" autocomplete="given-name" required>
                        </div>
                        <div class="mb-3">
                            <label for="lastname" class="form-label">Nachname:</label>
                            <input class="form-control" type="text" name="lastname" autocomplete="family-name" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Passwort:</label>
                            <input class="form-control" type="password" name="password" required>
                        </div>
                        <div>
                            <label for="pwd2" class="form-label">Passwort bestätigen:</label>
                            <input class="form-control" type="password" name="pwd2" required>
                        </div>
                        <div class="mb-3">
                            <label for="captcha" class="form-label"></label>
                            <altcha-widget challenge="/altcha"></altcha-widget>
                        </div>
                        <div class="mb-3">
                            <input class="btn btn-primary" type="submit" value="Absenden">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}