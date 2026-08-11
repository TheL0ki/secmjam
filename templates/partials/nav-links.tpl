<li {if $current_site == '/'}class="active"{/if}><a href="/">Home</a></li>
<li {if $current_site|str_starts_with:'/orders'}class="active"{/if}><a href="/orders">Bestellungen{if $countUnlockedOrders > 0} <span class="badge">{$countUnlockedOrders}</span>{/if}</a></li>
<li {if $current_site|str_starts_with:'/overview'}class="active"{/if}><a href="/overview">Übersicht</a></li>
<li {if $current_site|str_starts_with:'/user/settings'}class="active"{/if}><a href="/user/settings">Einstellungen</a></li>
<li {if $current_site|str_starts_with:'/highscore'}class="active"{/if}><a href="/highscore">Highscore</a></li>
<li {if $current_site|str_starts_with:'/stats'}class="active"{/if}><a href="/stats">Statistik</a></li>
<li class="nav navbar-right"><a href="/logout">Logout</a></li>