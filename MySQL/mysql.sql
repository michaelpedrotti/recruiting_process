
CREATE SCHEMA `odds_scanner` 
    DEFAULT CHARACTER SET utf8 ;

CREATE TABLE `odds_scanner`.`users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `displayname` varchar(100) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` char(8) NOT NULL,
  `enabled` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE `odds_scanner`.`emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_emails` (`email`)
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8;

CREATE TABLE `odds_scanner`.`projects` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL,
    `desc` varchar(255) DEFAULT NULL,
    `hours` int(10) NOT NULL,
    `dt_start` date NOT NULL,
    `dt_end` date NOT NULL,
    PRIMARY KEY (`id`)
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8;

CREATE TABLE `odds_scanner`.`user_projects` (
    `user_id` int(10) unsigned NOT NULL,
    `project_id` int(10) unsigned NOT NULL,
    `enabled` char(1) NOT NULL DEFAULT 'Y',
    PRIMARY KEY (`user_id`,`project_id`),
    KEY `fk_userprojects_users` (`user_id`),
    KEY `fk_userprojects_projects` (`project_id`),
    CONSTRAINT `fk_userprojects_projects` 
        FOREIGN KEY (`project_id`) 
        REFERENCES `projects` (`id`) 
            ON DELETE CASCADE 
            ON UPDATE NO ACTION,
    CONSTRAINT `fk_userprojects_users` 
        FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`id`) 
            ON DELETE CASCADE 
            ON UPDATE NO ACTION
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8;

