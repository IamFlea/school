<?php
/**
 * File:    checkUserInputs.php
 * Author:  Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 */

function checkUserInputs($version, &$isOK, &$message, &$post, &$jm, &$pr, &$e, &$tel, &$log, &$passw, &$role, &$nad, &$sekr){
//$version == 0 .......... registration
//$version == 1 .......... usersEdit
//returns nothing, everything goes thru arguments

	// Check for a first name.
	if (empty($post['jmeno'])) {
		$message .= '<p>Zadejte prosím jméno.</p>';
    $isOK = FALSE;
	} else {
		$jm = $post['jmeno'];
	}

	// Check for a last name.
	if (empty($post['prijmeni'])) {
		$message .= '<p>Zadejte prosím příjmení.</p>';
    $isOK = FALSE;
	} else {
		$pr = $post['prijmeni'];
	}

	// Check for an email address.
	if (empty($post['email'])) {
		$e = NULL;
	} else if(!preg_match("#^[_a-zA-Z0-9-]+(\.[/=!%_a-zA-Z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*(\.[A-Za-z]{2,})$#",$post['email'])) {
		$message .= '<p>Zadejte prosím email ve správném formátu.</p>';
    $isOK = FALSE;
    $post['email'] = "";
  } else {
		$e = $post['email'];
	}

	// Check for an phone number.
	if (empty($post['telefon'])) {
    $tel = NULL;
	} else if(!preg_match("#^\+[0-9]{12}$#",$post['telefon'])) {
		$message .= '<p>Zadejte prosím telefonní číslo ve správném formátu (např. +420111222333).</p>';
    $isOK = FALSE;
    $post['telefon'] = "";
  } else {
		$tel = $post['telefon'];
	}

	// Check for a login.
  if ($version == 1) {
    $findLogin = @mysql_query("SELECT * FROM zamestnanec Z WHERE Z.id_zamestnanec = ".$post['id']);
    if (!($findLogin)) {
      $isOK = FALSE;
      $message .= '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
    } else {
      $findLoginRow = mysql_fetch_array($findLogin, MYSQL_ASSOC);
    }
  }
	if (empty($post['login'])) {
		$message .= '<p>Zadejte prosím uživatelské jméno.</p>';
    $isOK = FALSE;
	} else if ($version == 0 && @mysql_num_rows(@mysql_query("SELECT * FROM zamestnanec Z WHERE Z.login='".htmlspecialchars(addslashes(trim($post['login'])))."'")) != 0) { // registration.php
		$message .= '<p>Uživatelské jméno \''.$post['login'].'\' již v databázi existuje. Zvolte, prosím, jiné.</p>';
    $post['login'] = "";
    $isOK = FALSE;
  } else if (($version == 1) && ($post['login'] != $findLoginRow['login']) && (@mysql_num_rows(@mysql_query("SELECT * FROM zamestnanec Z WHERE Z.login='".$post['login']."'")) != 0)) { // usersEdit.php
		$message .= '<p>Uživatelské jméno \''.$post['login'].'\' již v databázi existuje. Zvolte, prosím, jiné.</p>';
    $post['login'] = "";
    $isOK = FALSE;
  } else {
		$log = $post['login'];
	}

	// Check for a password and its parameters.
  if ($version == 0) { // registration.php
  	if (empty($post['password1'])) {
  		$message .= '<p>Zadejte prosím heslo.</p>';
      $isOK = FALSE;
  	} else if ($post['password1'] != $post['password2']) {
  		$message .= '<p>Vaše heslo nesouhlasí se zopakovaným heslem.</p>';
      $isOK = FALSE;
      $post['password1'] = "";
      $post['password2'] = "";
  	} else if (strlen($post['password1']) < 5) {
  		$message .= '<p>Vaše heslo se musí skládat minimálně z 5 znaků.</p>';
      $isOK = FALSE;
      $post['password1'] = "";
      $post['password2'] = "";
    } else if ($post['password1'] == "12345") {
      $message .= '<p>Vymyslete si prosím silnější heslo!!!</p>';
      $isOK = FALSE;
      $post['password1'] = "";
      $post['password2'] = "";
    } else {
      $passw = md5($post['password1']);
  	}
  } else if ($version == 1) { // usersEdit.php
    if (!(empty($post['password']))) {
      if (strlen($post['password']) < 5) {
    		$message .= '<p>Vaše heslo se musí skládat minimálně z 5 znaků.</p>';
        $isOK = FALSE;
        $post['password'] = "";
      } else if ($post['password'] == "12345") {
        $message .= '<p>Vymyslete si prosím silnější heslo!!!</p>';
        $isOK = FALSE;
        $post['password'] = "";
      } else {
        $passw = md5($post['password']);
    	}
    }
  }

	// Check for a role, superior and secretary.
  if ($version == 0) { // registration.php
  	if (!isset($post['role'])) {
  		$message .= '<p>Vyberte prosím roli v systému.</p>';
      $isOK = FALSE;
      $post['nadrizeny'] = "0";
      $post['sekretarka'] = "0";
  	} else {
  		$role = $post['role'];
      //Secretary:
      if ($post['role'] == "0" || $post['role'] == "3") {
        $post['sekretarka'] = "0";
      }

      $findBoss = @mysql_query("SELECT Z.id_zamestnanec FROM zamestnanec Z WHERE Z.role = 1");
      if (!($findBoss)) {
    		$message .= '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
      }
      $countBoss = @mysql_num_rows($findBoss);

      //Superior:
      if ($post['role'] == "2") {
        if ($countBoss == 1) {
          $boss = mysql_fetch_array($findBoss, MYSQL_ASSOC);
          $post['nadrizeny'] = $boss["id_zamestnanec"];
        } else if ($countBoss > 1) {
          $message .= '<p>Chyba v databázi - více než jeden ředitel!</p>';
          $post['nadrizeny'] = "0";
          $isOK = FALSE;
        } else {
          $message .= '<p>Chyba v databázi - žádný ředitel!</p>';
          $post['nadrizeny'] = "0";
          $isOK = FALSE;
        }
      } else if (!isset($post['nadrizeny'])) {
        $post['nadrizeny'] = "0";
      }

      //Only 1 boss rule:
      if ($post['role'] == "1" && $countBoss > 0) {
        $message= '<p>V systému již ředitel existuje a nelze přidat dalšího!</p>';
        $isOK = FALSE;
      }
  	}
    $nad = $post['nadrizeny'];
    $sekr = $post['sekretarka'];
  } else if ($version == 1) { // usersEdit.php
    if ($post['role'] == 0) {
      $postNadrizeny = $post['nadrizenyAdmin'];
      $postSekretarka = $post['sekretarkaAdmin'];
    } else if ($post['role'] == 1) {
      $postNadrizeny = $post['nadrizenySuperior'];
      $postSekretarka = $post['sekretarkaSuperiorManager'];
    } else if ($post['role'] == 2) {
      $postNadrizeny = $post['nadrizenyManager'];
      $postSekretarka = $post['sekretarkaSuperiorManager'];
    } else {
      $postNadrizeny = $post['nadrizenySecretary'];
      $postSekretarka = $post['sekretarkaSecretary'];
    }

  	if (!isset($post['role'])) {
  		$message .= '<p>Vyberte prosím roli v systému.</p>';
      $isOK = FALSE;
  	} else {
  		$role = $post['role'];

      //Admin
      if (($role == 0) && ((isset($postNadrizeny) && $postNadrizeny != 0) || (isset($postSekretarka) && $postSekretarka != 0))) {
  		  $message .= '<p>Administrátor nesmí mít sekretářku ani nadřízeného.</p>';
        $isOK = FALSE;
      }

      //Superior:
      if (($role == 1) && isset($postNadrizeny) && ($postNadrizeny != 0)) {
  		  $message .= '<p>Ředitel už nesmí mít žádného nadřízeného.</p>';
        $isOK = FALSE;
      }

      $findBoss = @mysql_query("SELECT Z.id_zamestnanec FROM zamestnanec Z WHERE Z.role = 1");
      if (!($findBoss)) {
    		$message .= '<p>Omlouváme se, ale během registrace došlo k chybě.</p><p>' . mysql_error() . '</p>';
      }
      $countBoss = @mysql_num_rows($findBoss);

      //Manager (and superior)
      $boss = mysql_fetch_array($findBoss, MYSQL_ASSOC);
      if ($role == 2) {
        if ($countBoss > 1) {
          $message .= '<p>Chyba v databázi - více než jeden ředitel!</p>';
          $isOK = FALSE;
        } else if ($countBoss < 1) {
          $message .= '<p>Chyba v databázi - žádný ředitel!</p>';
          $isOK = FALSE;
        }
      }

      //Only 1 boss rule:
      if ($post['role'] == "1" && $countBoss > 0 && $boss["id_zamestnanec"] != $post['id']) {
        $message .= '<p>V systému již ředitel existuje a nelze přidat dalšího!</p>';
        $isOK = FALSE;
      }

      if (($role == 2) && ((!isset($postNadrizeny)) || ($postNadrizeny != $boss["id_zamestnanec"]))) {
        $message .= '<p>Manažer musí mít nadřízeného a to právě ředitele.</p>';
        $isOK = FALSE;
      }

      //Secretary:
      if (($role == 3) && (isset($postSekretarka) && $postSekretarka != 0)) {
        $message .= '<p>Sekretářka nesmí mít sekretářku.</p>';
        $isOK = FALSE;
      }
  	}
    $nad = $postNadrizeny;
    $sekr = $postSekretarka;
  }

}
?>