<? header("Content-Type: text/html; charset=UTF-8");?>
<?php
/**
 * File:    mysqlConncet.php
 * Author:  Petr Dvoracek  <xdvora0n@stud.fit.vutbr.cz>
 *          Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 *
 * License: Muzes kreslit, muzes psat ale listy netrhat
 */
include("mysqlConnect.php");

$query = array();
$query[] = "CREATE TABLE IF NOT EXISTS `akce` (
                `id_akce` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
                `vlozil` mediumint(8) unsigned DEFAULT NULL,
                `vlozeno_dne` datetime NOT NULL,
                `zacatek` datetime NOT NULL,
                `konec` datetime NOT NULL,
                `nazev` varchar(64) COLLATE utf8_czech_ci NOT NULL,
                `podrobnosti` text COLLATE utf8_czech_ci,
                PRIMARY KEY (`id_akce`),
                KEY `vlozil` (`vlozil`)
            ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=34 ;";

$query[] = "INSERT INTO `akce` (`id_akce`, `vlozil`, `vlozeno_dne`, `zacatek`, `konec`, `nazev`, `podrobnosti`) VALUES
                (1, 2, '2012-11-23 19:16:11', '2012-12-18 10:00:00', '2012-12-18 13:00:00', 'IPZ - zkouška', 'Všichni povinně, zápočty už máte!'),
                (2, 2, '2012-11-23 19:18:59', '2012-12-21 11:00:00', '2012-12-21 14:00:00', 'ISA - zkouška', 'Všichni povinně, kdo nemá zápočet, tak nemusí a kupuje dárky pod stromeček.'),
                (4, 3, '2012-11-23 19:28:20', '2012-12-31 19:00:00', '2013-01-01 05:00:00', 'Silvestr', 'Test přes rok.\r\nLets get drunk!'),
                (6, 3, '2012-11-23 19:31:36', '2012-12-09 19:00:00', '2012-12-09 19:30:00', 'IMS - DEADLINE', 'Prohibice -- Modelování a simulace'),
                (7, 3, '2012-11-23 19:34:54', '2012-12-10 19:30:00', '2012-12-10 20:00:00', 'IIS - DEADLINE', 'Hurá, hotový!'),
                (8, 3, '2012-11-23 19:36:02', '2012-12-12 19:40:00', '2012-12-12 20:00:00', 'ITU - DEADLINE', 'Ještě jsme jej nezačali :('),
                (9, 3, '2012-11-23 19:37:27', '2012-12-14 19:40:00', '2012-12-14 20:00:00', 'IMP - DEADLINE', NULL),
                (10, 3, '2012-11-23 19:39:35', '2012-12-08 19:00:00', '2012-12-14 23:59:00', 'PANIKA NA FITU', 'Projektujeme'),
                (11, 3, '2012-11-23 19:42:51', '2012-12-13 00:02:00', '2012-12-13 02:47:00', 'HOBBIT', 'Woho'),
                (12, 3, '2012-11-23 19:46:33', '2012-12-26 07:00:00', '2012-12-26 20:00:00', 'Ukázka akce', 'Dlouhá akce'),
                (13, 3, '2012-11-23 19:47:10', '2012-12-26 08:00:00', '2012-12-26 09:00:00', 'Předehra', 'Dlouhá akce'),
                (14, 3, '2012-11-23 19:47:23', '2012-12-26 09:00:00', '2012-12-26 10:00:00', 'Mezihra', 'Dlouhá akce'),
                (15, 3, '2012-11-23 19:47:44', '2012-12-26 10:00:00', '2012-12-26 11:00:00', 'Dohra', 'Dlouhá akce'),
                (16, 3, '2012-11-23 19:47:59', '2012-12-26 08:00:00', '2012-12-26 11:00:00', 'Divadlo', 'Dlouhá akce'),
                (17, 3, '2012-11-23 19:50:17', '2012-12-26 15:30:00', '2012-12-26 16:30:00', 'Příchod', NULL),
                (18, 3, '2012-11-23 19:50:33', '2012-12-26 17:30:00', '2012-12-26 18:30:00', 'Záchod', NULL),
                (19, 3, '2012-11-23 19:50:53', '2012-12-26 19:30:00', '2012-12-26 20:30:00', 'Odchod', NULL),
                (20, 3, '2012-11-23 19:51:52', '2012-12-26 16:00:00', '2012-12-26 20:00:00', 'Kino', NULL),
                (21, 3, '2012-11-23 19:52:47', '2012-12-28 19:00:00', '2012-12-28 20:00:00', 'Jedna akce', NULL),
                (22, 3, '2012-11-23 19:53:10', '2012-12-28 20:00:00', '2012-12-28 21:00:00', 'Druha akce', NULL),
                (23, 3, '2012-11-23 19:53:32', '2012-12-28 21:00:00', '2012-12-28 22:00:00', 'Treti akce', NULL),
                (24, 2, '2012-11-23 19:55:37', '2012-12-27 20:00:00', '2012-12-27 21:00:00', 'Jsem pryc', NULL),
                (25, 2, '2012-11-23 19:55:55', '2012-12-27 21:00:00', '2012-12-27 22:00:00', 'Jsem pryc furt', NULL),
                (26, 6, '2012-11-23 19:57:43', '2012-12-24 20:02:00', '2012-12-24 21:02:00', 'Meating', 'Tvoje mila sekretarka'),
                (27, 2, '2012-11-23 19:59:43', '2012-12-28 20:00:00', '2012-12-30 21:00:00', 'Dovolena', NULL),
                (28, 2, '2012-11-23 20:02:16', '2012-12-25 20:07:00', '2012-12-25 21:07:00', 'Aj s barvou', NULL),
                (29, 2, '2012-11-23 20:05:21', '2012-12-30 20:09:00', '2012-12-30 21:09:00', 'Akce ředitele', 'Tu jsem ti tam dal jen já! A jen já ti ji můžu smazat'),
                (30, 2, '2012-11-23 20:06:08', '2013-01-17 20:10:00', '2013-01-17 21:10:00', 'Viz prosinec 2012', NULL),
                (31, 2, '2012-11-23 20:06:17', '2013-02-14 20:11:00', '2013-02-14 21:11:00', 'Viz prosinec 2012', NULL);";

$query[] = "CREATE TABLE IF NOT EXISTS `kategorie` (
                `id_kategorie` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
                `id_zamestnanec` mediumint(8) unsigned NOT NULL,
                `nazev_kat` varchar(64) COLLATE utf8_czech_ci NOT NULL,
                `barva` varchar(6) COLLATE utf8_czech_ci NOT NULL,
                `pismo` varchar(6) COLLATE utf8_czech_ci NOT NULL,
                PRIMARY KEY (`id_kategorie`),
                  KEY `id_zamestnanec` (`id_zamestnanec`)
            ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=9 ;";


$query[] = "INSERT INTO `kategorie` (`id_kategorie`, `id_zamestnanec`, `nazev_kat`, `barva`, `pismo`) VALUES
                (1, 2, 'Test', 'D98911', '000000'),
                (2, 3, 'VOLNO', '12EFFF', '000000'),
                (3, 3, 'test', 'FF0000', 'FFFFFF'),
                (4, 3, 'Deadline', '000000', 'FFFFFF'),
                (5, 3, 'DO NOT PANIC', 'FFFF00', '000000'),
                (6, 3, 'Fialova', 'E95CFF', '000000'),
                (7, 3, 'BILA', 'FFFFFF', '000000'),
                (8, 3, 'Modra', '0000FF', 'FFFFFF');";

$query[] = "CREATE TABLE IF NOT EXISTS `se_zucastni` (
                `id_akce` mediumint(8) unsigned NOT NULL,
                `id_zamestnanec` mediumint(8) unsigned NOT NULL,
                `checked` tinyint(4) NOT NULL,
                `id_kategorie` mediumint(8) unsigned DEFAULT NULL,
                PRIMARY KEY (`id_akce`,`id_zamestnanec`),
                KEY `id_kategorie` (`id_kategorie`),
                KEY `id_zamestnanec` (`id_zamestnanec`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;";

$query[] = "INSERT INTO `se_zucastni` (`id_akce`, `id_zamestnanec`, `checked`, `id_kategorie`) VALUES
                (1, 2, 1, 1),
                (1, 3, 0, 3),
                (1, 4, 0, NULL),
                (1, 5, 0, NULL),
                (2, 2, 1, 1),
                (2, 3, 0, 3),
                (2, 4, 0, NULL),
                (2, 5, 0, NULL),
                (4, 3, 1, NULL),
                (6, 3, 1, 4),
                (7, 3, 1, 4),
                (8, 3, 1, 4),
                (9, 3, 1, 4),
                (10, 3, 1, 5),
                (11, 3, 1, 2),
                (12, 3, 1, 2),
                (13, 3, 1, 5),
                (14, 3, 1, 3),
                (15, 3, 1, 4),
                (16, 3, 1, NULL),
                (17, 3, 1, NULL),
                (18, 3, 1, NULL),
                (19, 3, 1, NULL),
                (20, 3, 1, NULL),
                (21, 3, 1, 7),
                (22, 3, 1, 8),
                (23, 3, 1, 3),
                (24, 2, 1, NULL),
                (25, 2, 1, NULL),
                (26, 3, 0, NULL),
                (27, 2, 1, NULL),
                (28, 2, 1, 1),
                (29, 3, 0, NULL),
                (30, 2, 1, NULL),
                (30, 3, 0, NULL),
                (30, 4, 0, NULL),
                (30, 5, 0, NULL),
                (31, 2, 1, NULL),
                (31, 3, 0, NULL),
                (31, 4, 0, NULL),
                (31, 5, 0, NULL);";

$query[] = "CREATE TABLE IF NOT EXISTS `zamestnanec` (
                `id_zamestnanec` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
                `id_nadrizeny` mediumint(8) unsigned DEFAULT NULL,
                `role` tinyint(4) NOT NULL,
                `login` varchar(64) COLLATE utf8_czech_ci NOT NULL,
                `heslo` varchar(64) COLLATE utf8_czech_ci NOT NULL,
                `jmeno` varchar(64) COLLATE utf8_czech_ci NOT NULL,
                `prijmeni` varchar(64) COLLATE utf8_czech_ci NOT NULL,
                `email` varchar(128) COLLATE utf8_czech_ci DEFAULT NULL,
                `telefon` varchar(32) COLLATE utf8_czech_ci DEFAULT NULL,
                PRIMARY KEY (`id_zamestnanec`),
                UNIQUE KEY `login` (`login`),
                UNIQUE KEY `id_zamestnanec` (`id_zamestnanec`),
                KEY `id_nadrizeny` (`id_nadrizeny`)
            ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci AUTO_INCREMENT=11 ;";

$query[] = "INSERT INTO `zamestnanec` (`id_zamestnanec`, `id_nadrizeny`, `role`, `login`, `heslo`, `jmeno`, `prijmeni`, `email`, `telefon`) VALUES
                (1, NULL, 0, 'admin', 'f8af77644fead40db5566d404c129664', '', '', NULL, NULL),
                (2, NULL, 1, 'reditel', 'f8af77644fead40db5566d404c129664', 'Kendic', 'Kendicovic', 'kendic@seznam.cz', '+420775363601'),
                (3, 2, 2, 'manazer', 'f8af77644fead40db5566d404c129664', 'Joey', 'Deer', NULL, '+421123456789'),
                (4, 2, 2, 'manazer1', 'f8af77644fead40db5566d404c129664', 'Johnny', 'Walker', NULL, '+421123456789'),
                (5, 2, 2, 'manazer2', 'f8af77644fead40db5566d404c129664', 'Vox', 'Header', 'voxik@dexik.cz', NULL),
                (6, 3, 3, 'sekretarka', 'f8af77644fead40db5566d404c129664', 'Scarlet', 'Johannson', NULL, NULL),
                (7, 4, 3, 'sekretarka1', 'f8af77644fead40db5566d404c129664', 'Zooey', 'Deschanel', NULL, NULL),
                (8, 2, 3, 'sekretarka2', 'f8af77644fead40db5566d404c129664', 'Angelina', 'Jolie', NULL, NULL),
                (9, NULL, 3, 'sekretarka3', 'f8af77644fead40db5566d404c129664', 'Megan', 'Fox', NULL, NULL);";

$query[] = "ALTER TABLE `akce`
                ADD CONSTRAINT `akce_ibfk_2` FOREIGN KEY (`vlozil`) REFERENCES `zamestnanec` (`id_zamestnanec`) ON DELETE CASCADE;";

$query[] = "ALTER TABLE `kategorie`
                ADD CONSTRAINT `kategorie_ibfk_1` FOREIGN KEY (`id_zamestnanec`) REFERENCES `zamestnanec` (`id_zamestnanec`) ON DELETE CASCADE;";

$query[] = "ALTER TABLE `se_zucastni`
                ADD CONSTRAINT `se_zucastni_ibfk_1` FOREIGN KEY (`id_kategorie`) REFERENCES `kategorie` (`id_kategorie`) ON DELETE SET NULL,
                ADD CONSTRAINT `se_zucastni_ibfk_2` FOREIGN KEY (`id_akce`) REFERENCES `akce` (`id_akce`) ON DELETE CASCADE,
                ADD CONSTRAINT `se_zucastni_ibfk_3` FOREIGN KEY (`id_zamestnanec`) REFERENCES `zamestnanec` (`id_zamestnanec`) ON DELETE CASCADE;";

$query[] = "ALTER TABLE `zamestnanec`
    ADD CONSTRAINT `zamestnanec_ibfk_1` FOREIGN KEY (`id_nadrizeny`) REFERENCES `zamestnanec` (`id_zamestnanec`) ON DELETE SET NULL;";

$f = true;
foreach($query as &$q)
{
    $r = @mysql_query($q);
    if(! $r)
    {
        echo mysql_error()."<br>";
        $f = false;
    }
}
if($f == false)
    echo "Nepodařilo se nainstalovat DB pomoci tohoto scriptu!<br>";
else
    echo "Úspěšně nainstalováno.<br>";
?>
