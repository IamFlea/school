<?php
/**
 * File:    usersEdit.php
 * Author:  Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 */

header("Content-Type: text/html; charset=UTF-8");
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
?>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />

    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="styles.css" type="text/css">

    <title>Manažerský kalendář</title>

    <script language="JavaScript" type="text/javascript" src="./jquery.js"></script>
		<script type="text/javascript">
			function submitForm(element) {
				while(element.className != 'form')
					element = element.parentNode;

				var form = document.getElementById('multiForm');

				var inputs = element.getElementsByTagName('input');
				while(inputs.length > 0)
					form.appendChild(inputs[0]);

				var selects = element.getElementsByTagName('select');
				while(selects.length > 0)
					form.appendChild(selects[0]);

				var textareas = element.getElementsByTagName('textarea');
				while(textareas.length > 0)
					form.appendChild(textareas[0]);

				form.submit();
			}

			function locking(element) {
          (element.src.substring(element.src.length - 10, element.src.length) == 'lockON.png') ? element.src = 'lockOFF.png' : element.src = 'lockON.png';
          (element.alt == 'Odemknout záznam') ? element.alt = 'Uzamknout záznam' : element.alt = 'Odemknout záznam';
          (element.title == 'Odemknout záznam') ? element.title = 'Uzamknout záznam' : element.title = 'Odemknout záznam';

					while(element.className != 'form')
					element = element.parentNode;

          var inputs = element.getElementsByTagName('input');

          for(i=0; i < inputs.length; i++){
					   if (inputs[i].name != 'id') {
                if (inputs[i].name == 'submitBtn') {
                    (inputs[i].disabled == true) ? inputs[i].disabled = false : inputs[i].disabled = true;
                } else {
                    (inputs[i].readOnly == true) ? inputs[i].readOnly = false : inputs[i].readOnly = true;
                    (inputs[i].style.backgroundColor == "") ? inputs[i].style.backgroundColor = "#D9D9D9" : inputs[i].style.backgroundColor = "";
                }
             }
          }

          var inputs = element.getElementsByTagName('select');

          for(i=0; i < inputs.length; i++){
              (inputs[i].disabled == true) ? inputs[i].disabled = false : inputs[i].disabled = true;
              (inputs[i].style.backgroundColor == "") ? inputs[i].style.backgroundColor = "#D9D9D9" : inputs[i].style.backgroundColor = "";
          }

			}

      function myDelete(id) {
          if (confirm("Opravdu chcete smazat uživatele s osobním č. "+id+"?")) {
              window.location.replace('?action=deleteUser&id='+id);
          }
      }

      function orderCol(col) {
              window.location.replace('?action=order&column='+col);
      }

      function selectSuperiorAndSecretary(element, id)
      {
            if ($(element).children().length == 3) {
                if ($(element).children()[0].selected == true) { // Admin
                  document.getElementById('nadrAdmin'+id).style.display="table-cell";
                  document.getElementById('nadrSuperior'+id).style.display="none";
                  document.getElementById('nadrManager'+id).style.display="none";
                  document.getElementById('nadrSecretary'+id).style.display="none";

                  document.getElementById('sekrAdmin'+id).style.display="table-cell";
                  document.getElementById('sekrSuperiorManager'+id).style.display="none";
                  document.getElementById('sekrSecretary'+id).style.display="none";
                } else if ($(element).children()[1].selected == true) { // Manager
                  document.getElementById('nadrAdmin'+id).style.display="none";
                  document.getElementById('nadrSuperior'+id).style.display="none";
                  document.getElementById('nadrManager'+id).style.display="table-cell";
                  document.getElementById('nadrSecretary'+id).style.display="none";

                  document.getElementById('sekrAdmin'+id).style.display="none";
                  document.getElementById('sekrSuperiorManager'+id).style.display="table-cell";
                  document.getElementById('sekrSecretary'+id).style.display="none";
                } else if ($(element).children()[2].selected == true) { // Secretary
                  document.getElementById('nadrAdmin'+id).style.display="none";
                  document.getElementById('nadrSuperior'+id).style.display="none";
                  document.getElementById('nadrManager'+id).style.display="none";
                  document.getElementById('nadrSecretary'+id).style.display="table-cell";

                  document.getElementById('sekrAdmin'+id).style.display="none";
                  document.getElementById('sekrSuperiorManager'+id).style.display="none";
                  document.getElementById('sekrSecretary'+id).style.display="table-cell";
                }
            } else { // Superior
                  document.getElementById('nadrAdmin'+id).style.display="none";
                  document.getElementById('nadrSuperior'+id).style.display="table-cell";
                  document.getElementById('nadrManager'+id).style.display="none";
                  document.getElementById('nadrSecretary'+id).style.display="none";

                  document.getElementById('sekrAdmin'+id).style.display="none";
                  document.getElementById('sekrSuperiorManager'+id).style.display="table-cell";
                  document.getElementById('sekrSecretary'+id).style.display="none";
            }
      }
		</script>

</head>
<body>

<div id="header">
  <div id="logo">
  </div> <!-- logo -->
  <div id="menu">
    <div class="myUl">
      <span class="myLi"><a href="registration.php">Přidat&nbsp;uživatele</a></span>
      <span class="myLi"><a class="actual" href="usersEdit.php">Spravovat&nbsp;uživatele</a></span>
      <span class="myLi"><a href="index.php?page=changePass">Změnit&nbsp;heslo</a></span>
      <span class="myLi"><a href="index.php?action=logout">Odhlásit</a></span>
    </div>
  </div> <!-- menu -->
</div> <!-- header -->

<div align="center">

<?php
		require_once ('./mysqlConnect.php'); // Connect to the db.
?>

<?php

    include("./checkUserInputs.php");

    $orderBy = "id_zamestnanec";

    // Delete user
    if ($user->isAdmin()) {
        // GET processing (delete row)
        if (isset($_GET['action']) && $_GET['action'] == "deleteUser" && isset($_GET['id'])) {
            $result = @mysql_query("SELECT * FROM zamestnanec WHERE id_zamestnanec=".$_GET['id']);
            if (!($result)) {
                $attr = "delErrGeneral";
            } else {
                $count = @mysql_num_rows($result);
                $row = mysql_fetch_array($result, MYSQL_ASSOC);
                if ($count == 0) {
                    $attr = "delErrNonExist";
                } else if ($count != 1) {
                    $attr = "delErrDuplic";
                } else if ($row["role"] == 1) {
                    $attr = "delErrBoss";
                } else {
                    $result = @mysql_query("DELETE FROM zamestnanec WHERE id_zamestnanec=".$_GET['id']);
                    if(!($result)) {
                        $attr = "delErrGeneral";
                    } else {
                        $attr = "delOK";
                    }
                }
            }
            echo "<script type=\"text/javascript\">window.location.replace('?action=".$attr."&id=".$_GET['id']."');</script>";
        } else if (isset($_GET['action']) && $_GET['action'] == "delErrGeneral" && isset($_GET['id'])) {
            echo "<p><span style=\"color : #FF0000;\">Došlo k chybě při odstraňování uživatele (osobní č. ".$_GET['id'].") z databáze.</span></p>";
        } else if (isset($_GET['action']) && $_GET['action'] == "delErrNonExist" && isset($_GET['id'])) {
            echo "<p><span style=\"color : #FF0000;\">Uživatel určený k odstranění (osobní č. ".$_GET['id'].") neexistuje.</span></p>";
        } else if (isset($_GET['action']) && $_GET['action'] == "delErrDuplic" && isset($_GET['id'])) {
            echo "<p><span style=\"color : #FF0000;\">Došlo k chybě při odstraňování uživatele (osobní č. ".$_GET['id'].") z databáze.<br />Pravděpodobně se zadaný uživatel vyskytuje v databázi vícekrát.</span></p>";
        } else if (isset($_GET['action']) && $_GET['action'] == "delErrBoss" && isset($_GET['id'])) {
            echo "<p><span style=\"color : #FF0000;\">Uživatel určený k odstranění (osobní č. ".$_GET['id'].") je ředitel.<br />Toho nelze odstranit, pouze editovat.</span></p>";
        } else if (isset($_GET['action']) && $_GET['action'] == "delOK" && isset($_GET['id'])) {
            echo "<p><span style=\"color : #008000;\">Uživatel (osobní č. ".$_GET['id'].") byl úspěšně odstraněn z databáze.</span></p>";
        } else if (isset($_GET['action']) && $_GET['action'] == "order" && isset($_GET['column'])) {
            // GET processing (order by)
            switch ($_GET['column']) {
                case "osC":
                    $orderBy = "id_zamestnanec";
                    break;
                case "jmeno":
                    $orderBy = "jmeno";
                    break;
                case "prijmeni":
                    $orderBy = "prijmeni";
                    break;
                case "email":
                    $orderBy = "email";
                    break;
                case "telefon":
                    $orderBy = "telefon";
                    break;
                case "uzivJm":
                    $orderBy = "login";
                    break;
                case "role":
                    $orderBy = "role";
                    break;
                case "nadr":
                    $orderBy = "id_nadrizeny";
                    break;
                default:
                    break;
            }
        }
        // POST processing (update row)
        $isOK = TRUE; //for error detection
        if (isset($_POST['id'])) {
            $message = NULL; //for error messages
            $version = 1; //for checkUserInputs function

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

            if ($isOK) {
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

                // if secretary was changed
		            $oldSekr = @mysql_query ("SELECT * FROM zamestnanec Z WHERE Z.role = 3 AND Z.id_nadrizeny = ".$_POST['id']);
                if (!($oldSekr)) {
                    echo "<p><span style=\"color : #FF0000;\">Omlouváme se, ale během změny údajů zaměstnance (osobní č. ".$_POST['id'].") došlo k chybě.</span></p><p><span style=\"color : #FF0000;\">" . mysql_error() . "</span></p>";
                } else {
                    $oldSekrRow = @mysql_fetch_array($oldSekr, MYSQL_ASSOC);
                    $resultNew = true;
                    $resultOld = true;
                    if ($oldSekrRow["id_zamestnanec"] != $sekr) {
                        if ($sekr != 0) {$resultNew = @mysql_query("UPDATE zamestnanec SET id_nadrizeny=".$_POST['id']." WHERE id_zamestnanec=".$sekr);}
                        if (@mysql_num_rows($oldSekr) == 1) {$resultOld = @mysql_query("UPDATE zamestnanec SET id_nadrizeny=NULL WHERE id_zamestnanec=".$oldSekrRow["id_zamestnanec"]);}
                        if (!$resultNew || !$resultOld) {
                            echo "<p><span style=\"color : #FF0000;\">Omlouváme se, ale během změny údajů zaměstnance (osobní č. ".$_POST['id'].") došlo k chybě.</span></p><p><span style=\"color : #FF0000;\">" . mysql_error() . "</span></p>";
                        }
                    }

                    if ($resultNew && $resultOld) {
                        if ($passw == NULL) { // If password was not inserted (== edited)
                            $result = @mysql_query("UPDATE zamestnanec SET id_nadrizeny=".$nad.", role='".$role."', login='".$log."', jmeno='".$jm."', prijmeni='".$pr."', email=".$e.", telefon=".$tel." WHERE id_zamestnanec=".$_POST["id"]);
                        } else {
                            $result = @mysql_query("UPDATE zamestnanec SET id_nadrizeny=".$nad.", role='".$role."', login='".$log."', heslo='".$passw."', jmeno='".$jm."', prijmeni='".$pr."', email=".$e.", telefon=".$tel." WHERE id_zamestnanec=".$_POST["id"]);
                        }
                       	if ($result) { // If it ran OK.
                           echo "<p><b><span style=\"color : #008000;\">Úprava dat zaměstnance (osobní č. ".$_POST['id'].") proběhla úspěšně!</span></b></p>";
                        } else {
                            echo "<p><span style=\"color : #FF0000;\">Omlouváme se, ale během změny údajů zaměstnance (osobní č. ".$_POST['id'].") došlo k chybě.</span></p><p><span style=\"color : #FF0000;\">" . mysql_error() . "</span></p>";
                        }
                    }
                }
            } else {
                echo "<div style=\"color : #FF0000;\">".$message."</div>\n";
            }
        }
    } else {
        echo "<p><span style=\"color : #FF0000;\">Neoprávněný pokus o úpravu záznamů!</span></p>\n".
             "</div>\n".
             "<br />\n".
             "</body>\n".
             "</html>\n";
        exit();
    }
?>

<?php
    // Fill in table
		$result = @mysql_query ("SELECT * FROM zamestnanec ORDER BY ".$orderBy);
		if (!($result)) { // If it did not ran OK.
			echo "<p><span style=\"color : #FF0000;\">Omlouváme se, ale během načítání dat z databáze došlo k chybě.</span></p><p><span style=\"color : #FF0000;\">" . mysql_error() . "</span></p>";
		}

    // Nadrizeni
    $nadrAdmin = "            <option value=\"0\" selected=\"selected\">nikdo</option>\n";

    $nadrSuperior = "            <option value=\"0\" selected=\"selected\">nikdo</option>\n";

    $nadrizenyReditel = @mysql_query("SELECT * FROM zamestnanec Z WHERE Z.role=1");
    if (!($nadrizenyReditel)) {
        echo "<p><span style=\"color : #FF0000;\">Omlouváme se, ale během načítání dat z databáze došlo k chybě.</span></p><p><span style=\"color : #FF0000;\">" . mysql_error() . "</span></p>";
    } else if (@mysql_num_rows($nadrizenyReditel) == 1) {
        $rowReditel = mysql_fetch_array($nadrizenyReditel, MYSQL_ASSOC);
        $nadrManager = "            <option value=\"".$rowReditel["id_zamestnanec"]."\" selected=\"selected\">".$rowReditel["jmeno"]." ".$rowReditel["prijmeni"]." (".$rowReditel["id_zamestnanec"].")</option>\n";
    } else {
        echo "<p><div style=\"color : #FF0000;\">Omlouváme se, ale během načítání dat z databáze došlo k chybě.<br />V databázi se nenachází žádný nebo více ředitelů.</p><p>" . mysql_error() . "</p></div>";
        $nadrManager = "            <option value=\"0\" selected=\"selected\">nikdo</option>\n";
    }

    $nadrSecretaryNikdo1 = "            <option value=\"0\" ";
    $nadrSecretaryNikdo2 = ">nikdo</option>\n";

    $nadrSecretaryReditel1 = "            <option value=\"".$rowReditel["id_zamestnanec"]."\" ";
    $nadrSecretaryReditel2 = ">".$rowReditel["jmeno"]." ".$rowReditel["prijmeni"]." (".$rowReditel["id_zamestnanec"].")</option>\n";

    $nadrizenyManazeri = @mysql_query("SELECT Z.jmeno, Z.prijmeni, Z.id_zamestnanec FROM zamestnanec Z WHERE (Z.role = 1 OR Z.role = 2) AND NOT EXISTS (SELECT * FROM zamestnanec Z2 WHERE Z.id_zamestnanec = Z2.id_nadrizeny)");
    $nadrSecretaryManazeri = "";
		if (!($nadrizenyManazeri)) { // If it did not ran OK.
			echo "<p><span style=\"color : #FF0000;\">Omlouváme se, ale během načítání dat z databáze došlo k chybě.</span></p><p><span style=\"color : #FF0000;\">" . mysql_error() . "</span></p>";
		} else {
        $count = @mysql_num_rows($nadrizenyManazeri);
        if($count > 0)
        {
            while($row = mysql_fetch_array($nadrizenyManazeri, MYSQL_ASSOC))
            {
                $nadrSecretaryManazeri .= "            <option value=\"".$row["id_zamestnanec"]."\">".$row["jmeno"]." ".$row["prijmeni"]." (".$row["id_zamestnanec"].")</option>"."\n";
            }
        }
    }

    // Sekretarky
    $sekretarkaMoznosti = @mysql_query("SELECT Z.jmeno, Z.prijmeni, Z.id_zamestnanec FROM zamestnanec Z WHERE Z.role = 3 AND Z.id_nadrizeny IS NULL");
    $sekrVolne = "";
		if (!($sekretarkaMoznosti)) { // If it did not ran OK.
			echo "<p><span style=\"color : #FF0000;\">Omlouváme se, ale během načítání dat z databáze došlo k chybě.</span></p><p><span style=\"color : #FF0000;\">" . mysql_error() . "</span></p>";
		} else {
        $count = @mysql_num_rows($sekretarkaMoznosti);
        if($count > 0)
        {
            while($row = mysql_fetch_array($sekretarkaMoznosti, MYSQL_ASSOC))
            {
                $sekrVolne .= "            <option value=\"".$row["id_zamestnanec"]."\">".$row["jmeno"]." ".$row["prijmeni"]." (".$row["id_zamestnanec"].")</option>"."\n";
            }
        }
    }
    $sekrNikdo = "            <option value=\"0\" selected=\"selected\">nikdo</option>\n";

?>

<form id="multiForm" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST" style="display: none;"></form>
  <table>
    <thead>
      <tr>
        <th>
        </th>
        <th>
        </th>
        <th>
          <span onclick="orderCol('osC');" style="cursor:pointer;<?php if ($orderBy == "id_zamestnanec") {echo " text-decoration: underline;";} ?>">Os.&nbsp;č.</span>
        </th>
        <th>
          <span onclick="orderCol('jmeno');" style="cursor:pointer;<?php if ($orderBy == "jmeno") {echo " text-decoration: underline;";} ?>">Jméno&nbsp;*</span>
        </th>
        <th>
          <span onclick="orderCol('prijmeni');" style="cursor:pointer;<?php if ($orderBy == "prijmeni") {echo " text-decoration: underline;";} ?>">Příjmení&nbsp;*</span>
        </th>
        <th>
          <span onclick="orderCol('email');" style="cursor:pointer;<?php if ($orderBy == "email") {echo " text-decoration: underline;";} ?>">Email</span>
        </th>
        <th>
          <span onclick="orderCol('telefon');" style="cursor:pointer;<?php if ($orderBy == "telefon") {echo " text-decoration: underline;";} ?>">Telefon</span>
        </th>
        <th>
          <span onclick="orderCol('uzivJm');" style="cursor:pointer;<?php if ($orderBy == "login") {echo " text-decoration: underline;";} ?>">Login&nbsp;*</span>
        </th>
        <th>
          Heslo&nbsp;* (skryto)
        </th>
        <th>
          <span onclick="orderCol('role');" style="cursor:pointer;<?php if ($orderBy == "role") {echo " text-decoration: underline;";} ?>">Role&nbsp;*</span>
        </th>
        <th>
          <span onclick="orderCol('nadr');" style="cursor:pointer;<?php if ($orderBy == "id_nadrizeny") {echo " text-decoration: underline;";} ?>">Nadřízený</span>
        </th>
        <th>
          Sekretářka
        </th>
      </tr>
    </thead>
    <tbody>
<?php
    $errmsg = NULL;
    $space = "\n        </td>\n        <td>\n          ";
    $count = @mysql_num_rows($result);
    if($count > 0)
    {
        while($row = mysql_fetch_array($result, MYSQL_ASSOC))
        {
            if (!$isOK && $row["id_zamestnanec"] == $_POST["id"]) {
                $lock = "<img style=\"cursor:pointer;\" src=\"lockOFF.png\" alt=\"Uzamknout záznam\" title=\"Uzamknout záznam\" onclick=\"locking(this);\" />";
                $readOnly = "";
                $disabled = "";
                $bgColorLong = " style=\"background-color: #D9D9D9;\" ";
                $bgColorShort = " background-color: #D9D9D9;";

                $row["jmeno"] = $_POST["jmeno"];
                $row["prijmeni"] = $_POST["prijmeni"];
                $row["email"] = $_POST["email"];
                $row["telefon"] = $_POST["telefon"];
                $row["login"] = $_POST["login"];
                $row["heslo"] = $_POST["password"];
                $row["role"] = $_POST["role"];

                switch ($row["role"]) {
                    case 0:
                        $row["id_nadrizeny"] = $_POST["nadrizenyAdmin"];
                        break;
                    case 1:
                        $row["id_nadrizeny"] = $_POST["nadrizenySuperior"];
                        break;
                    case 2:
                        $row["id_nadrizeny"] = $_POST["nadrizenyManager"];
                        break;
                    case 3:
                        $row["id_nadrizeny"] = $_POST["nadrizenySecretary"];
                        break;
                    default:
                        break;
                }
            } else {
                $lock = "<img style=\"cursor:pointer;\" src=\"lockON.png\" alt=\"Odemknout záznam\" title=\"Odemknout záznam\" onclick=\"locking(this);\" />";
                $readOnly = "readonly";
                $disabled = "disabled";
                $bgColorLong = "";
                $bgColorShort = "";
            }

            $delete = "<img style=\"cursor:pointer;\" src=\"delete.png\" alt=\"Odstranit záznam\" title=\"Odstranit záznam\" onclick=\"myDelete('".$row["id_zamestnanec"]."');\" />";
            $text =  "      <tr class=\"form\">\n        <td>\n          ".$lock."\n        </td>\n        <td>\n          ".$delete."\n        </td>\n        <td>\n          ".
                     "<input type=\"text\" name=\"id\" size=\"1\" maxlength=\"1\" value=\"".$row["id_zamestnanec"]."\" readonly />".$space.
                     "<input type=\"text\" name=\"jmeno\" size=\"15\" maxlength=\"32\" value=\"".$row["jmeno"]."\" ".$bgColorLong.$readOnly." />".$space.
                     "<input type=\"text\" name=\"prijmeni\" size=\"15\" maxlength=\"32\" value=\"".$row["prijmeni"]."\" ".$bgColorLong.$readOnly." />".$space.
                     "<input type=\"text\" name=\"email\" size=\"20\" maxlength=\"80\" value=\"".$row["email"]."\" ".$bgColorLong.$readOnly." />".$space.
                     "<input type=\"text\" name=\"telefon\" size=\"13\" maxlength=\"13\" value=\"".$row["telefon"]."\" ".$bgColorLong.$readOnly." />".$space.
                     "<input type=\"text\" name=\"login\" size=\"10\" maxlength=\"32\" value=\"".$row["login"]."\" ".$bgColorLong.$readOnly." />".$space.
                     "<input type=\"password\" name=\"password\" size=\"15\" maxlength=\"32\" value=\"\" ".$bgColorLong.$readOnly." />".$space.

                     // Role
                     "<select name=\"role\" style=\"width: 105px;".$bgColorShort."\" onchange=\"selectSuperiorAndSecretary(this,".$row["id_zamestnanec"].")\" ".$disabled.">\n";
                     if ($row["role"] != 1) {$text .= "            <option value=\"0\""; if ($row["role"] == 0) {$text .= " selected=\"selected\"";} $text .= ">Administrátor</option>\n";}
                     if ($row["role"] == 1) {$text .= "            <option value=\"1\""; if ($row["role"] == 1) {$text .= " selected=\"selected\"";} $text .= ">Ředitel</option>\n";}
                     if ($row["role"] != 1) {$text .= "            <option value=\"2\""; if ($row["role"] == 2) {$text .= " selected=\"selected\"";} $text .= ">Manažer</option>\n";}
                     if ($row["role"] != 1) {$text .= "            <option value=\"3\""; if ($row["role"] == 3) {$text .= " selected=\"selected\"";} $text .= ">Sekretářka</option>\n";}
                     $text .= "          </select>".

                     // Nadrizeny
                     //     Admin
                             "\n        </td>\n        <td id=\"nadrAdmin".$row["id_zamestnanec"]."\" ". (($row["role"] != 0) ? "style=\"display : none;\"" : "") .">\n          ".
                             "<select name=\"nadrizenyAdmin\" style=\"width: 150px;".$bgColorShort."\" ".$disabled.">\n".
                             $nadrAdmin.
                             "          </select>".
                     //     Superior
                             "\n        </td>\n        <td id=\"nadrSuperior".$row["id_zamestnanec"]."\" ". (($row["role"] != 1) ? "style=\"display : none;\"" : "") .">\n          ".
                             "<select name=\"nadrizenySuperior\" style=\"width: 150px;".$bgColorShort."\" ".$disabled.">\n".
                             $nadrSuperior.
                             "          </select>".
                     //     Manager
                             "\n        </td>\n        <td id=\"nadrManager".$row["id_zamestnanec"]."\" ". (($row["role"] != 2) ? "style=\"display : none;\"" : "") .">\n          ".
                             "<select name=\"nadrizenyManager\" style=\"width: 150px;".$bgColorShort."\" ".$disabled.">\n".
                             $nadrManager.
                             "          </select>".
                     //     Secretary
                             "\n        </td>\n        <td id=\"nadrSecretary".$row["id_zamestnanec"]."\" ". (($row["role"] != 3) ? "style=\"display : none;\"" : "") .">\n          ".
                             "<select name=\"nadrizenySecretary\" style=\"width: 150px;".$bgColorShort."\" ".$disabled.">\n";
                             $text .= $nadrSecretaryNikdo1;
                             if ($row["role"] == 3 && $row["id_nadrizeny"] == 0) {
                                  $text .= "selected=\"selected\"";
                             }
                             $text .= $nadrSecretaryNikdo2;
                             if ($row["role"] == 3 && $row["id_nadrizeny"] != 0 && $row["id_nadrizeny"] != $rowReditel["id_zamestnanec"]) {
                                  $soucasnyNadrizeny = @mysql_query("SELECT * FROM zamestnanec Z WHERE Z.id_zamestnanec = ".$row["id_nadrizeny"]);
                                  if (!($soucasnyNadrizeny)) {
                                      $errmsg .= "<p>Omlouváme se, ale během načítání dat z databáze došlo k chybě.</p><p>" . mysql_error() . "</p>";
                                  } else {
                                      $soucNadrRow = mysql_fetch_array($soucasnyNadrizeny, MYSQL_ASSOC);
                                      $text .= "            <option value=\"".$soucNadrRow["id_zamestnanec"]."\" selected=\"selected\">".$soucNadrRow["jmeno"]." ".$soucNadrRow["prijmeni"]." (".$soucNadrRow["id_zamestnanec"].")</option>"."\n";
                                  }
                             }
                             $freeBoss = @mysql_query("SELECT * FROM zamestnanec Z WHERE Z.role = 1 AND NOT EXISTS (SELECT * FROM zamestnanec Z2 WHERE Z2.role = 3 AND Z.id_zamestnanec = Z2.id_nadrizeny)");
                             if (!($freeBoss)) {
                                  $errmsg .= "<p>Omlouváme se, ale během načítání dat z databáze došlo k chybě.</p><p>" . mysql_error() . "</p>";
                             } else if (@mysql_num_rows($freeBoss) == 1) {
                                 $text .= $nadrSecretaryReditel1.
                                 $nadrSecretaryReditel2;
                             } else if ($row["role"] == 3 && $row["id_nadrizeny"] == $rowReditel["id_zamestnanec"]) {
                                 $text .= $nadrSecretaryReditel1.
                                 "selected=\"selected\"".
                                 $nadrSecretaryReditel2;
                             }
                             $text .= $nadrSecretaryManazeri.
                             "          </select>";

                     // Sekretarky
                     $sekretarka = @mysql_query ("SELECT * FROM zamestnanec Z WHERE Z.role = 3 AND Z.id_nadrizeny = ".$row["id_zamestnanec"]);
                     if (!($sekretarka)) {
                         $errmsg .= "<p>Omlouváme se, ale během načítání databáze došlo k chybě.</p><p>" . mysql_error() . "</p>";
                         $text .= "<span style=\"color : #FF0000;\">CHYBA !</span>";
                         $sekretarka = NULL;
                     }
                     if (!$isOK && $row["id_zamestnanec"] == $_POST["id"]) {
                         if ($row["role"] == 0) {
                            $sekretarka = @mysql_query ("SELECT * FROM zamestnanec Z WHERE Z.id_zamestnanec = ".$_POST["sekretarkaAdmin"]);
                         } else if ($row["role"] == 1 || $row["role"] == 2) {
                            $sekretarka = @mysql_query ("SELECT * FROM zamestnanec Z WHERE Z.id_zamestnanec = ".$_POST["sekretarkaSuperiorManager"]);
                         } else if ($row["role"] == 3) {
                            $sekretarka = @mysql_query ("SELECT * FROM zamestnanec Z WHERE Z.id_zamestnanec = ".$_POST["sekretarkaSecretary"]);
                         }
                         if (!($sekretarka)) {
                             $errmsg .= "<p>Omlouváme se, ale během načítání databáze došlo k chybě.</p><p>" . mysql_error() . "</p>";
                             $text .= "<span style=\"color : #FF0000;\">CHYBA !</span>";
                             $sekretarka = NULL;
                         }
                     }
                     if ($sekretarka != NULL) {
                         if(@mysql_num_rows($sekretarka) == 1) {
                              $sekretarka = mysql_fetch_array($sekretarka, MYSQL_ASSOC);
                         } else {
                              $sekretarka = NULL;
                         }
                     //     Admin
                             $text .= "\n        </td>\n        <td id=\"sekrAdmin".$row["id_zamestnanec"]."\" ". (($row["role"] != 0) ? "style=\"display : none;\"" : "") .">\n          ".
                             "<select name=\"sekretarkaAdmin\" style=\"width: 150px;".$bgColorShort."\" ".$disabled.">\n".
                             $sekrNikdo.
                             "          </select>".
                     //     Superior & Manager
                             "\n        </td>\n        <td id=\"sekrSuperiorManager".$row["id_zamestnanec"]."\" ". (($row["role"] != 1 && $row["role"] != 2) ? "style=\"display : none;\"" : "") .">\n          ".
                             "<select name=\"sekretarkaSuperiorManager\" style=\"width: 150px;".$bgColorShort."\" ".$disabled.">\n".
                             "            <option value=\"0\" ". (($sekretarka == NULL) ? "selected=\"selected\"" : "") .">nikdo</option>\n";
                             if ($sekretarka != NULL) {
                                $text .= "            <option value=\"".$sekretarka["id_zamestnanec"]."\" selected=\"selected\">".$sekretarka["jmeno"]." ".$sekretarka["prijmeni"]." (".$sekretarka["id_zamestnanec"].")</option>"."\n";
                             }
                             $text .= $sekrVolne."          </select>";
                     //     Secretary
                             $text .= "\n        </td>\n        <td id=\"sekrSecretary".$row["id_zamestnanec"]."\" ". (($row["role"] != 3) ? "style=\"display : none;\"" : "") .">\n          ".
                             "<select name=\"sekretarkaSecretary\" style=\"width: 150px;".$bgColorShort."\" ".$disabled.">\n".
                             $sekrNikdo.
                             "          </select>".$space;
                     }

            $text .= "<input type=\"submit\" name=\"submitBtn\" value=\"Uložit změny\" onclick=\"submitForm(this);\" ".$disabled." />".
                     "\n        </td>\n      </tr>\n";

            echo $text;
        }
    }


?>
    </tbody>
  </table>
  <p>Položky označené '*' jsou povinné.</p>
  <p>Heslo se musí skládat minimálně z 5 znaků.</p>
  <p>Telefonní číslo zadejte ve formátu +420111222333.</p>
<?php

if (isset($errmsg)) {
	echo "<div style=\"color : #FF0000;\">".$errmsg."</div>";
}

?>

</div>
<br />
</body>
</html>

<?php
		mysql_close(); // Close the database connection.
?>
