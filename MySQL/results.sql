-- 1: Structure
-- 1.1
SELECT PASSWORD('102030');
SELECT MD5('102030');
SELECT SHA1('102030');

-- I choosed PASSWORD

-- 1.2

-- MD5 char(32)
-- SHA1 char(40)
-- PASSWORD char(41)

ALTER TABLE `odds_scanner`.`users` 
    CHANGE COLUMN `password` `password` CHAR(41) 
    NOT NULL ;


-- 1.3 - Use NOW(), can use with CONCAT(username, NOW())

SELECT PASSWORD(NOW());

-- 1.4

-- create a index
ALTER TABLE `odds_scanner`.`emails` 
    ADD INDEX `fk_emails_users` (`user_id` ASC);

-- create a foreing key ( ON DELETE must be CASCADE, else 1.4 is wrong )
ALTER TABLE `odds_scanner`.`emails` 
    ADD CONSTRAINT `fk_emails_users`
      FOREIGN KEY (`user_id`)
      REFERENCES `odds_scanner`.`users` (`id`)
          ON DELETE CASCADE
          ON UPDATE NO ACTION;

-- 1.5: Bonus

DELIMITER $$

CREATE TRIGGER `odds_scanner`.`users_AFTER_INSERT` AFTER INSERT ON `users` FOR EACH ROW
BEGIN
	INSERT IGNORE INTO `odds_scanner`.`emails` VALUES (NEW.id,  CONCAT(NEW.username, '@columbia.com'));
END$$
DELIMITER ;


-- 2: Users

-- 2.1, 2.2: Insert new users
INSERT INTO `odds_scanner`.`users` (`id`,  `displayname`, `username`, `enabled`) VALUES (1, 'Moe Howard',  'moe.howard', PASSWORD(NOW()));
INSERT INTO `odds_scanner`.`users` (`id`, `displayname`, `username`, `enabled`) VALUES (2, 'Larry Fine', 'larry.fine', PASSWORD(NOW()));
INSERT INTO `odds_scanner`.`users` (`id`, `displayname`, `username`, `enabled`) VALUES (3, 'Curly Howard', 'curly.howard', PASSWORD(NOW()));
INSERT INTO `odds_scanner`.`users` (`id`,  `displayname`, `username`, `enabled`) VALUES (4, 'Shemp Howard', 'shemp.howard', PASSWORD(NOW()));
INSERT INTO `odds_scanner`.`users` (`id`,  `displayname`, `username`, `enabled`) VALUES (5, 'Joe Besser', 'joe.besser', PASSWORD(NOW()));
INSERT INTO `odds_scanner`.`users` (`id`,  `displayname`, `username`, `enabled`) VALUES (6, 'Joe DeRita', 'joe.deRita', PASSWORD(NOW()));


-- 2.3: Insert new users
-- if 1.5 was implemented this block should be not needed
INSERT INTO `odds_scanner`.`emails` (`user_id`, `email`) VALUES (1, 'moe.howard@columbia.com');
INSERT INTO `odds_scanner`.`emails` (`user_id`, `email`) VALUES (2, 'larry.fine@columbia.com');
INSERT INTO `odds_scanner`.`emails` (`user_id`, `email`) VALUES (3, 'curly.howard@columbia.com');
INSERT INTO `odds_scanner`.`emails` (`user_id`, `email`) VALUES (4, 'shemp.howard@columbia.com');
INSERT INTO `odds_scanner`.`emails` (`user_id`, `email`) VALUES (5, 'joe.besser@columbia.com');
INSERT INTO `odds_scanner`.`emails` (`user_id`, `email`) VALUES (6, 'joe.deRita@columbia.com');

-- 3: Projects
INSERT INTO `odds_scanner`.`projects` VALUES (1, 'TV SHOW', 'Television', '5000', '1922-01-01', '1970-12-31');
INSERT INTO `odds_scanner`.`projects` VALUES (2, 'Idiots Deluxe', 'Movie', '3456', '1945-01-01', '1948-12-31');
INSERT INTO `odds_scanner`.`projects` VALUES (3, 'Pardon My Clutch', 'Movie', '3053', '1945-01-01', '1948-12-31');
INSERT INTO `odds_scanner`.`projects` VALUES (4, 'Hoofs and Goofs', 'Movie', '1234', '1956-01-01', '1957-12-31');
INSERT INTO `odds_scanner`.`projects` VALUES (5, 'Have Rocket, Will Travel', 'Movie', '800', '1959-01-01', '1959-12-31');

-- 4: Original formation from 1933
-- 4.1
INSERT INTO `odds_scanner`.`user_projects` VALUES (1, 1);
INSERT INTO `odds_scanner`.`user_projects` VALUES (2, 1);
INSERT INTO `odds_scanner`.`user_projects` VALUES (3, 1);
-- 4.2
INSERT INTO `odds_scanner`.`user_projects` VALUES (1, 2);
INSERT INTO `odds_scanner`.`user_projects` VALUES (2, 2);
INSERT INTO `odds_scanner`.`user_projects` VALUES (3, 2);
-- 4.3
UPDATE `odds_scanner`.`users` SET `enabled`='N' WHERE `id`= 3;

-- 5: Group formation from 1947
-- 5.1
INSERT INTO `odds_scanner`.`user_projects` VALUES (4, 1);
-- 5.2
INSERT INTO `odds_scanner`.`user_projects` VALUES (1, 3);
INSERT INTO `odds_scanner`.`user_projects` VALUES (2, 3);
INSERT INTO `odds_scanner`.`user_projects` VALUES (4, 3);
-- 5.3
DELETE FROM `odds_scanner`.`user_projects` WHERE `user_id` = 4 and `project_id` = 3;

-- 6: Group formation from 1957
-- 6.1
INSERT INTO `odds_scanner`.`user_projects` VALUES (5, 1);
-- 6.2
INSERT INTO `odds_scanner`.`user_projects` VALUES (1, 4);
INSERT INTO `odds_scanner`.`user_projects` VALUES (2, 4);
INSERT INTO `odds_scanner`.`user_projects` VALUES (5, 4);
-- 6.3
UPDATE `odds_scanner`.`user_projects` SET `enabled`='N' WHERE `user_id` = 5 and `project_id` = 4;

-- 7: Group formation from 1959
-- 7.1
INSERT INTO `odds_scanner`.`user_projects` VALUES (6, 1);
-- 7.2
INSERT INTO `odds_scanner`.`user_projects` VALUES (1, 5);
INSERT INTO `odds_scanner`.`user_projects` VALUES (2, 5);
INSERT INTO `odds_scanner`.`user_projects` VALUES (6, 5);
-- 7.3
DELETE FROM `odds_scanner`.`users` WHERE `id` = 4;
DELETE FROM `odds_scanner`.`users` WHERE `id` = 5;
DELETE FROM `odds_scanner`.`users` WHERE `id` = 6;
-- or
-- DELETE FROM `odds_scanner`.`users` WHERE `id` IN(4, 5, 6);




