<li {if $current_site == '/'}class="active"{/if}><a href="/">Home</a></li>
<li {if $current_site|in_array:['/orders', '/orders/new', '/orders/menu', '/orders/show']}class="active"{/if}><a href="/orders">Bestellungen{if $countUnlockedOrders > 0} <span class="badge">{$countUnlockedOrders}</span>{/if}</a></li>
<li {if $current_site == 'overview.php'}class="active"{/if}><a href="/overview">Übersicht</a></li>
<li {if $current_site == 'user_settings.php' OR $current_site == 'changepwd.php'}class="active"{/if}><a href="/user/settings">Einstellungen</a></li>
<li {if $current_site == 'highscore.php'}class="active"{/if}><a href="/highscore">Highscore</a></li>
<li {if $current_site == 'stats.php'}class="active"{/if}><a href="/stats">Statistik</a></li>
<li class="nav navbar-right"><a href="/logout">Logout</a></li> 