<?php
/**
 * File:    users.php
 * Author:  Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 *
 * This file contains class for actuall user management
 */

// Employee roles, enumerator..
if(! defined("ADMIN"))
    define("ADMIN", 0);
if(! defined("BOSS"))
    define("BOSS", 1);
if(! defined("MANAGER"))
    define("MANAGER", 2);
if(! defined("SECRETARY"))
    define("SECRETARY", 3);
if(! defined("RANDOM_USER"))
    define("RANDOM_USER", 4);

class User
{ 
    public $id;         // ID of user
    public $name;
    public $role;
    public $bossId;     // boss of the user
    public $idCalendar; // What calendar is user using 

    public $lastUsername; // Bad login

    /** 
     * Fills up variables of this class from SESSION or by id.
     */
    public function __construct($idEmployee = null)
    {
        $this->lastUsername = "";
        if($idEmployee== null)
        {
            if(isset($_SESSION['id']))
            {
                // User is logged in. Take data from session. 
                $this->id       = $_SESSION['id'];
                $this->name     = $_SESSION['name'];
                $this->role     = $_SESSION['role'];
                $this->bossId   = $_SESSION['bossId'];
                $this->idCalendar = $_SESSION['idCalendar'];
            }
            else
            {
                $this->role = RANDOM_USER;
            }
        }
        else
        {
            $result=@mysql_query("SELECT * FROM zamestnanec WHERE id_zamestnanec=".$idEmployee);
            if($result)
            {
                if($row = mysql_fetch_array($result, MYSQL_ASSOC))
                {
                    $this->id         = $idEmployee;
                    $this->name       = $row['prijmeni']." ".$row['jmeno'];
                    $this->role       = $row['role'];
                    $this->bossId     = $row['id_nadrizeny'];
                    $this->idCalendar = $this->id;
                }
            }
        }
    }

    public function printme()
    {
        echo $this->id;
        echo "<br>";
        echo $this->name;
        echo "<br>";
        echo $this->role;
        echo "<br>";
        echo $this->bossId;
        echo "<br>";
        echo $this->idCalendar;
        echo "<br>";
    }

    /**
     * Login a user. Fill up variables. USING POST
     * $err     Error string array.
     * @return  Boolean. True if logged in.
     */
    public function login(&$err)
    {
        // Testing if the form was filled correctly
        if(! isset($_POST['login_name']))
        {
            $err[] = "Chybí Vám přihlašovací jméno. Prosím vyplňte jej.";
            return false;
        }
        
        $this->lastUsername = $_POST['login_name'];
        if(! isset($_POST['pass']) )
        {
            $err[] = "Chybí Vám přihlašovací jméno. Prosím vyplňte jej.";
            return false;
        }
        $user = $_POST['login_name'];
        $pass = $_POST['pass']; 
        //$pass = md5($pass);
        $result = mysql_query("SELECT * FROM zamestnanec WHERE login = '$user' AND heslo = '$pass'");
        $count = mysql_num_rows($result);
        // User was found;
        if($count > 0)
        {
            if($row = mysql_fetch_array($result, MYSQL_ASSOC))
            {
                $this->id       = $row["id_zamestnanec"];
                $this->role     = $row["role"];
                $this->bossId   = $row["id_nadrizeny"];

                if($row["prijmeni"] != NULL && $row["jmeno"] != NULL)
                    $this->name = $row["prijmeni"] ." ". $row["jmeno"];
                else
                    $this->name = $row["login"];

                if($this->role == SECRETARY)
                    $this->idCalendar = $this->bossId;
                else if($this->role == ADMIN)
                    $this->idCalendar = NULL;
                else
                    $this->idCalendar = $this->id;
            }
            $this->lastUsername = "";
            $_SESSION['id'] = $this->id;
            $_SESSION['name'] = $this->name;
            $_SESSION['role'] = $this->role;
            $_SESSION['bossId'] = $this->bossId;
            $_SESSION['idCalendar'] = $this->idCalendar;
            $_SESSION['timeout'] = time();
            return true;
        }
        else
        {
            $this->lastUsername = $user;
            $err[] = "Nesprávné přihlášení.";
            return false;
        }
    }


    /**
     * Put variables into init state.
     */
    public function logout()
    {
        $this->id = NULL;
        $this->name = NULL;
        $this->bossId = NULL;
        $this->role = RANDOM_USER;
        $this->lastUsername = "";
        session_destroy();
    }

    /**
     * Zmena hesla..
     */
    public function changePass(&$err)
    {
        if(empty($_POST['pass1']) || empty($_POST['pass2']) || empty($_POST['oldpass']))
        {
            $err[] = "Chyba při vyplňování formuláře.";
            return false;
        }
        $pass1 = $_POST['pass1'];
        $pass2 = $_POST['pass2'];
        $oldpass = md5($_POST['oldpass']);
        $result = @mysql_query("SELECT jmeno FROM zamestnanec WHERE id_zamestnanec=".$this->id." AND heslo ='". $oldpass."'");
        if (mysql_num_rows($result) <= 0)
            $err[] = "Zadali jste neplatné heslo.";
        if($pass1 != $pass2)
            $err[] = "Nové heslo musí odpovídat!";
        if(strlen($pass1) < 5)
            $err[] = "Vaše heslo je krátké. Minimální délka je 5 znaků.";
        if($pass1 == "12345")
            $err[] = "12345 není heslo.";
        // Weak password?
        //if(pwdWeak($pass1))
        //    $err[] = "Je mi lito. Heslo musi obsahovat velke pismeno, cislo, nealfanumericky znak, znameni dablovo, jmeno vyhynuleho savce a hieroglyf";
        if(empty($err))
        {
            $pass = md5($pass1);
            $result = @mysql_query("UPDATE zamestnanec SET heslo='$pass' WHERE id_zamestnanec=".$this->id);
            if ($result)
                return true;
            else
                return false;
        }
        return false;
        
    }


    /**
     * Test if user is logged in
     */
    public function loggedin()
    {
        if($this->role == RANDOM_USER)
            return false;
        else
            return true;
    }

    /**
     * Test if user is admin
     */
    public function isAdmin()
    {
        if($this->role == ADMIN)
            return true;
        else
            return false;
    }

    /**
     * Test if user is boss
     */
    public function isBoss()
    {
        if($this->role == BOSS)
            return true;
        else
            return false;
    }

    /**
     * Test if user is manager 
     */
    public function isManager()
    {
        if($this->role == MANAGER)
            return true;
        else
            return false;
    }

    /**
     * Test if user is secretary 
     */
    public function isSecretary()
    {
        if($this->role == SECRETARY)
            return true;
        else
            return false;
    }
}

?>
