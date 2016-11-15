<?php
/**
 * File:    mysqlConncet.php
 * Author:  Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 *
 * License: Muzes kreslit, muzes psat ale listy netrhat
 */

$server = "localhost:/var/run/mysql/mysql.sock";
$user   = "xkylou00";
$pass   = "ejruboj2";
$db     = "xkylou00";

$connection = mysql_connect($server, $user, $pass);
if (!$connection) die('Nelze se pripojit '.mysql_error());
if (!mysql_select_db($db, $connection)) die('Databaze neni dostupna '.mysql_error());

@mysql_query("SET NAMES UTF8");

echo mysql_error();
?>
