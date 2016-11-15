<? header("Content-Type: text/html; charset=UTF-8");?>
<?php
/**
 * File:    registration.php
 * Author:  Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 */

session_start();

// Time used for auto-logout. Number is in seconds!
define("INACTIVE_TIME", 3*60);

// Mysql connection
include_once("mysqlConnect.php");
// User class
include_once("user.php");
// Calndar class
include_once("calendar.php");
// Event class
include_once("event.php");

#include("");

// Check activity of actual user
if(isset($_SESSION['timeout']))
{
    // Logout after n minutes 
    if(($_SESSION['timeout'] + INACTIVE_TIME) < time())
        session_destroy();
    // Refresh activity of user.
    $_SESSION['timeout'] = time();
}

// Create instances 
$user = new User();
if($user->isAdmin())
{
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />

    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="styles.css" type="text/css">

    <title>Manažerský kalendář</title>

</head>
<body>

<div id="header">
  <div id="logo">
  </div> <!-- logo -->
  <div id="menu">
    <div class="myUl">
      <span class="myLi"><a class="actual" href="registration.php">Přidat&nbsp;uživatele</a></span>
      <span class="myLi"><a href="usersEdit.php">Spravovat&nbsp;uživatele</a></span>
      <span class="myLi"><a href="index.php?page=changePass">Změnit&nbsp;heslo</a></span>
      <span class="myLi"><a href="index.php?action=logout">Odhlásit</a></span>
    </div>
  </div> <!-- menu -->
</div> <!-- header -->
<?php
		require_once ('./mysqlConnect.php'); // Connect to the db.

include("./checkUserInputs.php");

if (isset($_POST['submit'])) { // Handle the form.

	$message = NULL; //for error messages
  $isOK = TRUE; //for error detection
  $version = 0; //for checkUserInputs function

  //variables to store inputs
  $jm = NULL;
  $pr = NULL;
  $e = NULL;
  $tel = NULL;
  $log = NULL;
  $passw = NULL;
  $role = NULL;
  $nad = NULL;
  $sekr = NULL;

  checkUserInputs($version, $isOK, $message, $_POST, $jm, $pr, $e, $tel, $log, $passw, $role, $nad, $sekr);

	if ($isOK) { // If everything's OK.

		// Make the query:
    // Security
    $log = htmlspecialchars(addslashes(trim($log)));
    $jm = htmlspecialchars(addslashes(trim($jm)));
    $pr = htmlspecialchars(addslashes(trim($pr)));
    $e = htmlspecialchars(addslashes(trim($e)));
    // Optional inputs
    $nad = ($nad == "0") ? "NULL" : "'$nad'";
    $e = ($e == "") ? "NULL" : "'$e'";
    $tel = ($tel == "") ? "NULL" : "'$tel'";
    $query = "INSERT INTO zamestnanec (id_zamestnanec, id_nadrizeny, role, login, heslo, jmeno, prijmeni, email, telefon) VALUES (NULL, $nad, '$role', '$log', '$passw', '$jm', '$pr', $e, $tel )";
		$result = @mysql_query ($query); // Run the query.
		if ($result) { // If it ran OK.

      if ($sekr != "0") {
        $result = @mysql_query("SELECT * FROM zamestnanec Z WHERE Z.login='".$log."'");
        if (!($result)) {
        	$message = '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
        }
        $row = mysql_fetch_array($result, MYSQL_ASSOC);
        $result = @mysql_query("UPDATE zamestnanec SET id_nadrizeny='".$row["id_zamestnanec"]."' WHERE id_zamestnanec='".$sekr."'");

        if($result) { // If it ran OK.
    			echo "<div align=\"center\"><p><b><span style=\"color : #008000;\">Registrace proběhla úspěšně!</span></b></p>".
               "<a href=\"".$_SERVER['PHP_SELF']."\">Další registrace</a>".
               "\n"."</div>"."\n"."<br />"."\n"."</body>"."\n"."</html>";
    			exit(); // Quit the script.
        } else { // If it did not run OK.
          $message .= '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
        }
      } else {
  			echo "<div align=\"center\"><p><b><span style=\"color : #008000;\">Registrace proběhla úspěšně!</span></b></p>"."\n".
             "<a href=\"".$_SERVER['PHP_SELF']."\">Další registrace</a>".
             "</div>"."\n"."<br />"."\n"."</body>"."\n"."</html>";
  			exit(); // Quit the script.
      }
		} else { // If it did not run OK.
			$message = '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
		}
	}

} // End of the main Submit conditional.

// Print the message if there is one.
if (isset($message)) {
	echo "<div align=\"center\" style=\"color : #FF0000;\">".$message."<br /></div>";
}
?>

<div id="formWrapper">
<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
<div>
<fieldset><legend>Vyplňte prosím následující údaje:</legend>
<table>

<tr><td><b>Jméno: *</b></td><td><input type="text" name="jmeno" size="20" maxlength="32" value="<?php if (isset($_POST['jmeno'])) echo $_POST['jmeno']; ?>" /></td></tr>

<tr><td><b>Příjmení: *</b></td><td><input type="text" name="prijmeni" size="20" maxlength="32" value="<?php if (isset($_POST['prijmeni'])) echo $_POST['prijmeni']; ?>" /></td></tr>

<tr><td><b>Email:</b></td><td><input type="text" name="email" size="20" maxlength="80" value="<?php if (isset($_POST['email'])) echo $_POST['email']; ?>" /></td></tr>

<tr><td><b>Telefon:</b></td><td><input type="text" name="telefon" size="20" maxlength="13" value="<?php if (isset($_POST['telefon'])) echo $_POST['telefon']; ?>" /></td></tr>

<tr><td><b>Uživatelské jméno: *</b></td><td><input type="text" name="login" size="20" maxlength="32" value="<?php if (isset($_POST['login'])) echo $_POST['login']; ?>" /></td></tr>

<tr><td><b>Heslo: *</b></td><td><input type="password" name="password1" size="20" maxlength="32" value="<?php if (isset($_POST['password1'])) echo $_POST['password1']; ?>" /></td></tr>

<tr><td><b>Zopakujte heslo: *</b></td><td><input type="password" name="password2" size="20" maxlength="32" value="<?php if (isset($_POST['password2'])) echo $_POST['password2']; ?>" /></td></tr>

<tr><td><b>Role v systému: *</b></td><td>
<input type="radio" name="role" value="0"<?php if (isset($_POST['role']) && ($_POST['role']) == "0") echo " CHECKED"; ?> onClick="document.getElementById('selectNadrizeny').style.display='none';document.getElementById('selectSekretarka').style.display='none';" />Administrátor<br />
<input type="radio" name="role" value="1"<?php if (isset($_POST['role']) && ($_POST['role']) == "1") echo " CHECKED"; ?> onClick="document.getElementById('selectNadrizeny').style.display='none';document.getElementById('selectSekretarka').style.display='table-row';" />Ředitel<br />
<input type="radio" name="role" value="2"<?php if (isset($_POST['role']) && ($_POST['role']) == "2") echo " CHECKED"; ?> onClick="document.getElementById('selectNadrizeny').style.display='none';document.getElementById('selectSekretarka').style.display='table-row';" />Manažer<br />
<input type="radio" name="role" value="3"<?php if (isset($_POST['role']) && ($_POST['role']) == "3") echo " CHECKED"; ?> onClick="document.getElementById('selectNadrizeny').style.display='table-row';document.getElementById('selectSekretarka').style.display='none';" />Sekretářka</td></tr>

<tr id="selectNadrizeny" <?php if (!(isset($_POST['role']) && $_POST['role'] == "3")) echo " style='display: none'"; ?>><td><b>Nadřízený: </b></td><td><select name="nadrizeny">
<option value="0"<?php if (isset($_POST['nadrizeny']) && $_POST['nadrizeny'] == "0") echo " selected='selected'"; ?>>nikdo</option>
<?php
$nadrizenyMoznosti = @mysql_query("SELECT Z.jmeno, Z.prijmeni, Z.id_zamestnanec FROM zamestnanec Z WHERE (Z.role = 1 OR Z.role = 2) AND NOT EXISTS (SELECT * FROM zamestnanec Z2 WHERE Z2.role = '3' AND Z.id_zamestnanec = Z2.id_nadrizeny)");
if (!($nadrizenyMoznosti)) {
	$otherMessages .= '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
}
$count = @mysql_num_rows($nadrizenyMoznosti);
if($count > 0)
{
    while($row = mysql_fetch_array($nadrizenyMoznosti, MYSQL_ASSOC))
    {

        echo '<option value=\''.$row["id_zamestnanec"].'\'';
        if (isset($_POST['nadrizeny']) && $_POST['nadrizeny'] == $row["id_zamestnanec"]) echo " selected='selected'";
        echo '>'.$row["jmeno"].' '.$row["prijmeni"].' ('.$row["id_zamestnanec"].')</option>'."\n";
    }
}
?>
</select></td></tr>

<tr id="selectSekretarka" <?php if (!((isset($_POST['role']) && (($_POST['role'] == "1") || ($_POST['role'] == "2"))))) echo " style='display: none'"; ?>><td><b>Sekretářka: </b></td><td><select name="sekretarka">
<option value="0"<?php if (isset($_POST['sekretarka']) && $_POST['sekretarka'] == "0") echo " selected='selected'"; ?>>žádná</option>
<?php
$sekretarkaMoznosti = @mysql_query("SELECT Z.jmeno, Z.prijmeni, Z.id_zamestnanec FROM zamestnanec Z WHERE Z.role = '3' AND Z.id_nadrizeny IS NULL");
if (!($sekretarkaMoznosti)) {
	$otherMessages .= '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
}
$count = @mysql_num_rows($sekretarkaMoznosti);
if($count > 0)
{
    while($row = mysql_fetch_array($sekretarkaMoznosti, MYSQL_ASSOC))
    {

        echo '<option value=\''.$row["id_zamestnanec"].'\'';
        if (isset($_POST['sekretarka']) && $_POST['sekretarka'] == $row["id_zamestnanec"]) echo " selected='selected'";
        echo '>'.$row["jmeno"].' '.$row["prijmeni"].' ('.$row["id_zamestnanec"].')</option>'."\n";
    }
}
?>
</select></td></tr>

<tr><td id="note" align="center" colspan=2>Položky označené '*' jsou povinné.<br />Heslo se musí skládat minimálně z 5 znaků.<br />Telefonní číslo zadejte ve formátu +420111222333.</td></tr>

</table>
</fieldset>
</div>

<?php
// Print the message if there is one.
if (isset($otherMessages)) {
	echo "<div style=\"color : #FF0000;\">".$otherMessages."</div>";
}
?>

<div align="center"><input type="submit" name="submit" value="Registrovat" /></div>


</form><!-- End of Form -->
</div><!-- formWrapper -->
<br />
</body>
</html>

<?php
}
		mysql_close(); // Close the database connection.
?>
