-- Migration: create core tables for SEC-Mjam
-- Derived from SQL usage across PHP (mainly config/functions.php)

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `categories` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `slug` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_categories_slug` (`slug`),
    UNIQUE KEY `uq_categories_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `categories` (`id`, `slug`, `name`) VALUES
    (1, 'noodles', 'Noodles'),
    (2, 'pizza', 'Pizza'),
    (3, 'kebap', 'Kebap'),
    (4, 'schnitzel', 'Schnitzel'),
    (5, 'grill', 'Grill'),
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

CREATE TABLE IF NOT EXISTS `users` (
    `uuid` UUID NOT NULL,
    `user` VARCHAR(64) NOT NULL,
    `firstname` VARCHAR(100) NOT NULL,
    `lastname` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `balance` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    `notify` TINYINT(1) NOT NULL DEFAULT 1,
    `vote` TINYINT(1) NOT NULL DEFAULT 0,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `points` INT NOT NULL DEFAULT 0
    PRIMARY KEY (`uuid`),
    UNIQUE KEY `uq_users_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`uuid`, `user`, `firstname`, `lastname`, `email`, `password`, `created_at`, `updated_at`, `balance`, `notify`, `vote`, `active`, `points`) VALUES
    (UUID(), 'admin', 'Admin', 'Admin', 'admin@example.com', '$2y$12$rxls5mPNJ7p9wSQ0thpS3etYJH1GxuCQtFXxFfiROHsAqGPgJlIma', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0.00, 1, 0, 1, 0);

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

CREATE TABLE IF NOT EXISTS `deliveries` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `delivery_number` VARCHAR(32) NOT NULL COMMENT 'Unix timestamp used as order id',
    `delivery_text` VARCHAR(32) NOT NULL COMMENT 'Reference to menu.id',
    `userid` INT UNSIGNED NOT NULL,
    `sauce` VARCHAR(255) NOT NULL DEFAULT '',
    `owner` INT UNSIGNED NOT NULL,
    `category_id` INT UNSIGNED NOT NULL,
    `autolock` DATETIME NULL DEFAULT NULL,
    `timestamp` DATETIME NOT NULL,
    `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0=open, 1=closed',
    `locked` TINYINT(1) NOT NULL DEFAULT 0,
    `helper` TEXT NULL DEFAULT NULL COMMENT 'Pipe-separated quoted user ids',
    PRIMARY KEY (`id`),
    KEY `idx_deliveries_dn` (`delivery_number`),
    KEY `idx_deliveries_userid` (`userid`),
    KEY `idx_deliveries_owner` (`owner`),
    KEY `idx_deliveries_status_locked` (`status`, `locked`),
    KEY `idx_deliveries_category` (`category_id`),
    KEY `idx_deliveries_autolock` (`autolock`),
    CONSTRAINT `fk_deliveries_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
