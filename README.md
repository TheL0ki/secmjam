# SEC-Mjam

SEC-Mjam is a group lunch-ordering app for a team or office. One person starts a shared order for a restaurant (category), others add their items, and the owner can lock, close, and credit helpers. Points, highscores, and stats keep track of who organizes and who joins.

The UI is in German.

## How to use it

1. **Register or log in.** Create an account, then sign in. You can reset a forgotten password from the login page.

2. **Start or join an order.** Open **Bestellungen**. To start a round, choose **Neue Bestellung anlegen**, pick a category (for example pizza or kebab), optionally set a cutoff time, and optionally send an info mail to everyone who wants notifications. To join, open an existing running order and add items from the menu (including extras where the category allows them).

3. **Lock and close.** The owner can lock an order so no one else can add items (or unlock it again). When the food is ordered, close the order and mark helpers — people who picked up or helped. Closing awards points: full category points for the owner, half for helpers.

4. **Check your history and scores.** **Übersicht** lists your recent items and orders you owned. **Home** shows your current points and a daily lunch poll (one vote per person per day). **Highscore** ranks everyone; **Statistik** shows popular items and categories (yours and overall).

5. **Settings.** Under **Einstellungen** you can change your email, turn order-notification mail on or off, deactivate your account, or change your password.

Admins can manage users, categories, menus, and extras under **Admin**.

## Setup (brief)

Requirements: PHP 8.5+, Composer, MySQL/MariaDB, and a web server with the document root set to `public/`.

```bash
composer install
cp .env.example .env
```

Fill in `.env` (database, SMTP, `APP_ADDRESS`, `APP_TIMEZONE`, and `ALTCHA_HMAC_SECRET`). Create the schema with `database/migrations/001_create_tables.sql`. Existing databases that predate the lunch poll also need `database/migrations/002_create_lunch_votes.sql`. The first admin user is created through registration or the admin UI after you have access.

## License

GNU GPLv3. See [LICENSE.md](LICENSE.md).
