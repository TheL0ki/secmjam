<!-- Concept, design and code by Alexander Dominikus (alexander.dominikus@gmail.com) -->
<!-- Menue for Desktop Start-->
<div class="row">
    <div class="col-md-12">
        <ul class="nav nav-tabs hidden-xs hidden-sm" style="margin-bottom: 20px;">
            {include 'partials/nav-links.tpl'}
        </ul>
        <!-- Menue for Desktop End-->
        <!-- Menue for Phone Start-->
        <nav class="navbar navbar-default hidden-md hidden-lg">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed pull-left" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false" style="margin-left: 15px;">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        {include 'partials/nav-links.tpl'}
                    </ul>            
                </div>
            </div>
        </nav>
    </div>
</div>
<!-- Menue for Phone End-->
