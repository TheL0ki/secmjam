<!-- Concept, design and code by Alexander Dominikus (alexander.dominikus@gmail.com) -->

<div class="row">
    <div class="col p-0">
        <!-- Menue for Desktop Start-->
        <div class="container d-none d-md-block">
            <ul class="nav nav-tabs">
                {include 'partials/nav-links.tpl'}
            </ul>
        </div>
        <!-- Menue for Desktop End-->
        <!-- Menue for Phone Start-->
        <nav class="navbar navbar-expand-lg navbar-light bg-light d-md-none">
            <div class="container-fluid">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav">
                        {include 'partials/nav-links.tpl'}
                    </ul>
                </div>
            </div>
        </nav>
        <!-- Menue for Phone End-->
    </div>
</div>

