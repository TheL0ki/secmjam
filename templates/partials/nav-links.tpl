<li class="nav-item">
    <a class="nav-link {if $current_site == '/' || $current_site == '/login'}active{/if}" href="/">Home</a>
</li>
<li class="nav-item">
    <a class="nav-link {if $current_site|str_starts_with:'/orders'}active{/if}" href="/orders">Bestellungen{if $countUnlockedOrders > 0} <span class="badge">{$countUnlockedOrders}</span>{/if}</a>
</li>
<li class="nav-item">
    <a class="nav-link {if $current_site|str_starts_with:'/overview'}active{/if}" href="/overview">Übersicht</a>
</li>
<li class="nav-item">
    <a class="nav-link {if $current_site|str_starts_with:'/user'}active{/if}" href="/user/settings">Einstellungen</a>
</li>
<li class="nav-item">
    <a class="nav-link {if $current_site|str_starts_with:'/highscore'}active{/if}" href="/highscore">Highscore</a>
</li>
<li class="nav-item">
    <a class="nav-link {if $current_site|str_starts_with:'/stats'}active{/if}" href="/stats">Statistik</a>
</li>
<li class="nav-item d-md-none">
    <a class="nav-link" href="/logout">Logout <i class="bi bi-box-arrow-right"></i></a>
</li>
<li class="nav-item ms-auto d-none d-md-block">
    <a class="nav-link" href="/logout">Logout <i class="bi bi-box-arrow-right"></i></a>
</li>