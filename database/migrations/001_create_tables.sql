-- Migration: create core tables for SEC-Mjam
-- Reflects the current database layout (schema only, no seed data)

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `categories` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `slug` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `multiple_extras` TINYINT(1) NOT NULL DEFAULT 0,
    `points` INT NOT NULL DEFAULT 0,
    `active` TINYINT(1) NOT NULL DEFAULT 1,	
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_categories_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users` (
    `uuid` UUID NOT NULL DEFAULT UUID(),
    `user` VARCHAR(64) NOT NULL,
    `firstname` VARCHAR(100) NOT NULL,
    `lastname` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `notify` TINYINT(1) NOT NULL DEFAULT 1,
    `vote` TINYINT(1) NOT NULL DEFAULT 0,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `points` INT NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`uuid`),
    UNIQUE KEY `uq_users_user` (`user`),
    KEY `idx_users_email` (`email`),
    KEY `idx_users_active_lastname` (`active`, `lastname`),
    KEY `idx_users_active_points` (`active`, `points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `menu` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `category_id` INT UNSIGNED NOT NULL,
    `sub_category` VARCHAR(100) NOT NULL DEFAULT '',
    `item` VARCHAR(255) NOT NULL,
    `size` VARCHAR(50) NOT NULL DEFAULT '-',
    `price` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (`id`),
    KEY `idx_menu_category_sub` (`category_id`, `sub_category`),
    CONSTRAINT `fk_menu_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `extras` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `category_id` INT UNSIGNED NOT NULL,
    `slug` VARCHAR(50) NOT NULL,
    `name` VARCHAR(128) NOT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `fk_extras_category` (`category_id`),
    CONSTRAINT `fk_extras_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `orders` (
    `uuid` UUID NOT NULL,
    `owner_uuid` UUID NOT NULL,
    `category_id` INT UNSIGNED NOT NULL,
    `open` TINYINT(1) NOT NULL DEFAULT 1,
    `locked` TINYINT(1) NOT NULL DEFAULT 0,
    `autolock` DATETIME NULL DEFAULT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`uuid`),
    KEY `fk_orders_user` (`owner_uuid`),
    KEY `fk_orders_category` (`category_id`),
    KEY `idx_orders_autolock` (`autolock`),
    CONSTRAINT `fk_orders_user` FOREIGN KEY (`owner_uuid`) REFERENCES `users` (`uuid`) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT `fk_orders_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `order_items` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_uuid` UUID NOT NULL,
    `item_id` INT UNSIGNED NOT NULL,
    `item_owner_uuid` UUID NOT NULL,
    `amount` INT(16) NOT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `fk_menu_item` (`item_id`),
    KEY `fk_order_item` (`order_uuid`),
    KEY `fk_user_item` (`item_owner_uuid`),
    CONSTRAINT `fk_menu_item` FOREIGN KEY (`item_id`) REFERENCES `menu` (`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_order_item` FOREIGN KEY (`order_uuid`) REFERENCES `orders` (`uuid`) ON UPDATE CASCADE,
    CONSTRAINT `fk_user_item` FOREIGN KEY (`item_owner_uuid`) REFERENCES `users` (`uuid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `order_item_extras` (
    `order_item_id` INT UNSIGNED NOT NULL,
    `extra_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`order_item_id`, `extra_id`),
    KEY `extra_id` (`extra_id`),
    CONSTRAINT `fk_order_item_extras_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`),
    CONSTRAINT `fk_order_item_extras_extra` FOREIGN KEY (`extra_id`) REFERENCES `extras` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `helper` (
    `user_uuid` UUID NOT NULL,
    `order_uuid` UUID NOT NULL,
    PRIMARY KEY (`user_uuid`, `order_uuid`),
    KEY `order_uuid` (`order_uuid`),
    CONSTRAINT `fk_helper_user` FOREIGN KEY (`user_uuid`) REFERENCES `users` (`uuid`) ON UPDATE CASCADE,
    CONSTRAINT `fk_helper_order` FOREIGN KEY (`order_uuid`) REFERENCES `orders` (`uuid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `password_resets` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_uuid` UUID NOT NULL,
    `token_hash` CHAR(64) NOT NULL,
    `expires_at` DATETIME NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_password_resets_token_hash` (`token_hash`),
    KEY `idx_password_resets_user` (`user_uuid`),
    KEY `idx_password_resets_expires` (`expires_at`),
    CONSTRAINT `fk_password_resets_user` FOREIGN KEY (`user_uuid`) REFERENCES `users` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
