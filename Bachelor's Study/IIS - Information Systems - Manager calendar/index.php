<?php
/**
 * File:    index.php 
 * Author:  Petr Dvoracek  <xdvora0n@stud.fit.vutbr.cz>
 *          Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 */

header("Content-Type: text/html; charset=UTF-8");

// Time used for auto-logout. Number is in seconds!
define("INACTIVE_TIME", 3*60);

// Including files
include_once("mysqlConnect.php");   // Database connection
include_once("user.php");           // User class
include_once("calendar.php");       // Calendar class
include_once("event.php");          // Event class
include_once("categories.php");     // Category class
include_once("functions.php");      // Usefull function

///////////////////////////////////////////////////////////////////////////////
// Check activity of actual user

// Start session
session_start();
if(isset($_SESSION['timeout']))
{
    // Logout after n minutes 
    if(($_SESSION['timeout'] + INACTIVE_TIME) < time())
        session_destroy();
    // Refresh activity of user.
    $_SESSION['timeout'] = time();
}

$user = new User();  // Actual logged in user

// Array of strings that are discribing error, if occurs
$err = array();
$info = array();



///////////////////////////////////////////////////////////////////////////////
// Action handler
if(isset($_GET['action']))
{
    switch($_GET['action'])
    {   
        // Login manipulation
        case "login":
            if($user->login($err))
                $info[] = "Přihlášení proběhlo úspěšně.";
            break;
        case "changePass":
            if($user->changePass($err))
                $info[] = "Změna hesla proběhla úspěšně.";
            break;
        case "logout":
            $user->logout($err);
            break;

        // Event manipulations
        case "addEvent":
            $e = New Event($user);
            $e->constructFromPost();
            $e->create($err);
            break;
        case "addEvents":
            $e = New Event($user);
            $e->constructFromPost();
            if(isset($_SESSION['managers']))
                $e->participants = $_SESSION['managers'];
            else
                break;
            $e->create($err);
            break;
        case "delEvent":
            $e = New Event($user);
            $e->id = $_GET['id'];
            if($e->delete($err) == true)
                $info[] = "Akce smazána.";
            break;
        default:
            break;
    }
}

///////////////////////////////////////////////////////////////////////////////
// Count of new events
if(! $user->isSecretary() && $user->loggedIn() && ! $user->isAdmin())
{
    $calc = new Calendar($user);
    $newEvents = $calc->newEvents();
}
else
    $newEvents = 0;

// Get page name, if not use calc 
$pageSet = true;
if(isset($_GET['page']))
    $page = $_GET['page'];
else
{
    if($user->idCalendar)
        $page = "calc";
    else
        $page = "none";
    $_GET['page'] = $page;
}

///////////////////////////////////////////////////////////////////////////////

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
    <title>Manažerský kalendář</title>
    <link rel="stylesheet" href="jquery/jquery-ui.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="styles.css" type="text/css" media="screen" />

    <!-- frameworks -->
    <script language="JavaScript" type="text/javascript" src="./md5.js"></script>
    <script type="text/javascript" src="jquery/jquery-1.8.2.js"></script> 
    <script type="text/javascript" src="jquery/jquery.bgiframe-2.1.2.js"></script>
    <script type="text/javascript" src="jquery/jquery-ui.js"></script> 
    <script type="text/javascript" src="jquery/jquery.ui.datepicker-cs.js"></script>
    <script type="text/javascript" src="jscolor/jscolor.js"></script>

    <!-- Java script begin -->
    <script type="text/javascript">

    function objToString (obj) {
        var str = '';
        for (var p in obj) {
            if (obj.hasOwnProperty(p)) {
                str += p + '::' + obj[p] + '\n';
            }
        }
        return str;
    }
    
    function setTableSize() {
        // called onload and onresize
        // modify sizes of tables month and day according to window size
        var maxW = 1000, minW = 700, widthSpace = 100, WtoHscale = 0.50, arrowScale = 0.02, headerScale = 0.02;
        var myWidth = 0, myHeight = 0;
        if( typeof( window.innerWidth ) == 'number' ) {
            //Non-IE
            myWidth = window.innerWidth;
            myHeight = window.innerHeight;
        } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
            //IE 6+ in 'standards compliant mode'
            myWidth = document.documentElement.clientWidth;
            myHeight = document.documentElement.clientHeight;
        } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
            //IE 4 compatible
            myWidth = document.body.clientWidth;
            myHeight = document.body.clientHeight;
        }

        // min and max size
        if (myWidth > maxW) { myWidth = maxW; }
        if (myWidth < minW) { myWidth = minW; }

        myWidth = myWidth - widthSpace;
        myHeight = myWidth * WtoHscale;

        // Table MONTH
        $('table.month').width(myWidth);
        $('table.month td.arrow').width(Math.round(myWidth*arrowScale));
        $('table.month td.day').width(Math.round(myWidth*((1-arrowScale)/7)));

        $('table.month tr.header').height(Math.round(myHeight*headerScale));
        $('table.month div.day').height(Math.round(myHeight*((1-headerScale)/6)));

        // Table DAY
        $('tr.dayRow').each(function() {
           var match = /([0-9]+)#([0-9]+)/i.exec(this.id);
           $(this).height(Math.round(match[2] * 1.5 * myHeight / match[1]));
        });

    }

    $(document).ready(function(){
    $("#datePicker").datepicker({ altField: "#Range", altFormat: 'yyyy-mm-dd', rangeSelect: true });
    }); 
    $(function() {
        $.datepicker.setDefaults( $.datepicker.regional[ "cs" ] );

        $( "#from" ).datepicker({
            firstDay: 1,
            defaultDate: "+1w",
            changeMonth: true,
            changeYear: true,
            minDate: <?php echo date("mm/dd/yy"); ?>,
            onSelect: function( selectedDate ) {
                $( "#to" ).datepicker( "option", "minDate", selectedDate );
            }
        });
        $( "#to" ).datepicker({
            firstDay: 1,
            defaultDate: "+1w",
            changeMonth: true,
            changeYear: true,
            minDate: <?php echo date("mm/dd/yy"); ?>,
            onSelect: function( selectedDate ) {
                $( "#from" ).datepicker( "option", "maxDate", selectedDate );
            }
        });
    });
    </script>
</head>
<body<?php if($page == "calcAll" || $page == "calc") {echo " onload=\"setTableSize();\" onresize=\"setTableSize();\"";}?>>
<div align="center">
<?php
// Login screen sees only user dat is logged out.
if(! $user->loggedIn())
{
    // Header
    echo '<div id="header">';
    echo '<div id="logo">';
    echo '</div> <!-- logo -->';
    echo '<div id="menu" style="font-size: 250%; font-weight: bold; line-height:70px;">';
    echo 'Manažerský kalendář';
    echo '</div> <!-- menu -->';
    echo '</div> <!-- header -->';
    // Body -- form
    echo '<form action="?action=login" method="POST">';
    echo '<table>';
    echo '<tr>';
    echo '<td>Login</td>';
    echo '<td>Heslo</td>';
    echo '<td>&nbsp;</td>';
    echo '</tr>';
    echo '<tr>';
    echo '<td><input type="text" name="login_name" value="'. $user->lastUsername .'" /></td>';
    echo '<td><input type="password" name="pass" /></td>';
    echo '<td><input type="submit" name="login" value="Přihlásit" onclick="pass.value = hex_md5(pass.value)" /></td>';
    echo '</tr>';
    echo '</table>';
    echo '</form>';
}

///////////////////////////////////////////////////////////////////////////////
// Generate menu
$menu  = "<div id=\"header\">".
         "<div id=\"logo\">".
         "</div> <!-- logo -->".
         "<div id=\"menu\">".
         "<div class=\"myUl\">";

if($user->idCalendar != NULL)
{
    $menu .= '<span class="myLi">';
    $menu .= '<a '. (($page == "calc") ? 'class="actual" ': "") .'href="?page=calc">';
    $menu .= 'Kalendář';
    $menu .= '</a>';
    $menu .= '</span>';
}
 
if($user->isManager() || $user->isBoss())
{
    $menu .= '<span class="myLi">';
    $menu .= '<a '. (($page == "categories") ? 'class="actual" ': "") .'href="?page=categories">';
    $menu .= 'Spravovat&nbsp;kategorie';
    $menu .= '</a>';
    $menu .= '</span>';
}
 
if($user->isBoss()) 
{
    $menu .= '<span class="myLi">';
    $menu .= '<a '. (($page == "calcAll") ? 'class="actual" ': "") .'href="?page=calcAll">';
    $menu .= 'Kalendáře&nbsp;manažerů';
    $menu .= '</a>';
    $menu .= '</span>';

    $menu .= '<span class="myLi">';
    $menu .= '<a '. (($page == "coworkingEvent") ? 'class="actual" ': "") .'href="?page=coworkingEvent">';
    $menu .= 'Vytvořit&nbsp;společnou&nbsp;akci';
    $menu .= '</a>';
    $menu .= '</span>';
}
 
if($user->isAdmin()) 
{
    $menu .= '<span class="myLi">';
    $menu .= '<a href="registration.php">';
    $menu .= 'Přidat&nbsp;uživatele';
    $menu .= '</a>';
    $menu .= '</span>';

    $menu .= '<span class="myLi">';
    $menu .= '<a href="usersEdit.php">';
    $menu .= 'Spravovat&nbsp;uživatele';
    $menu .= '</a>';
    $menu .= '</span>';
}
 
if ($newEvents > 0)
{
    $menu .= '<span class="myLi">';
    $menu .= '<a '. (($page == "newEvents") ? 'class="actual" ': "") .'href="?page=newEvents">';
    $menu .= 'Nové&nbsp;akce';
    $menu .= '</a>';
    $menu .= '</span>';
}
$menu .= '<span class="myLi">';
$menu .= '<a '. (($page == "changePass") ? 'class="actual" ': "") .'href="?page=changePass">';
$menu .= 'Změnit&nbsp;heslo';
$menu .= '</a>';
$menu .= '</span>';

$menu .= '<span class="myLi">';
$menu .= '<a '. (($page == "logout") ? 'class="actual" ': "") .'href="?action=logout">';
$menu .= 'Odhlásit';
$menu .= '</a>';


$menu .= '</span>';
$menu .= '</div>';
$menu .= '</div> <!-- menu -->';
$menu .= '</div> <!-- header -->';

if($user->loggedIn())
    echo $menu;
// Menu end;
//////////////////////////////////////////////////////////////////////////////

// Info handler
foreach($info as $item)
    echo "<p>".$item."</p><br />";

if($newEvents == 1)
    echo "<a href=\"?page=newEvents\">Máte jednu nepotvrzenou akci!</a><br />";
else if($newEvents >= 2 && $newEvents <= 4)
    echo "<a href=\"?page=newEvents\">Máte $newEvents nepotvrzené akce!</a><br />";
else if ($newEvents > 0)
    echo "<a href=\"?page=newEvents\">Máte $newEvents nepotvrzených akcí!</a><br />";

// Error handler
foreach($err as $item)
    echo '<font color="#ff0000">'.$item.'</font><br />';



//////////////////////////////////////////////////////////////////////////////
// Body
if($user->loggedIn())
{   
    // Create new Calendar
    switch($page)
    {
        case "calc":
            $calc = new Calendar($user);
            $calc->drawMonth();
            break;
        case "changePass":
            echo '<form action="?page=changePass&action=changePass" method="POST">';
            echo '<table>';
            echo '<tr><td><b>Heslo:</b></td><td><input type="password" name="pass1" /></td></tr>';
            echo '<tr><td><b>Heslo pro ověření:</b></td><td><input type="password" name="pass2" /></td></tr>';
            echo '<tr><td><b>Staré heslo:</b></td><td><input type="password" name="oldpass" /></td></tr>';
            echo '</table>';
            echo '<input type="submit" name="gogogo" value="Změnit heslo" />';
            echo '</form>';
            break;
        case "categories":
            $cat = new Category($user);
            $cat->createForm();
            break;
        case "coworkingEvent":
            $calc = new Calendar($user);
            $calc->coworkingEvent();
            break;
        case "newEvents":
            $calc = new Calendar($user);
            $calc->drawNewEvents();
            break;
        case "none":
            break;
        case "calcAll":
            if(! $user->isBoss())
            {
                echo "Požadovaná stránka neexistuje.";
                break;
            }
            if(isset($_POST['id_mc']))
                $_SESSION['id_mc'] = $_POST['id_mc'];

            // Auto submit
            echo "<form action=\"?page=calcAll\" method=\"POST\">";
            echo "<select name=\"id_mc\" onchange=\"this.form.submit()\">";
            $result = @mysql_query("SELECT id_zamestnanec, jmeno, prijmeni FROM zamestnanec WHERE role=".MANAGER);
            
            if(mysql_num_rows($result) > 0)
            {
                echo "<option value=\"null\">Vyberte manažera</option>";
                while($row = mysql_fetch_array($result, MYSQL_ASSOC))
                {
                    if(isset($_SESSION['id_mc']) && $_SESSION['id_mc'] == $row['id_zamestnanec'])
                    {
                        echo "<option value=\"".$row['id_zamestnanec']."\" selected>";
                        echo $row['jmeno']." ".$row['prijmeni'];
                        echo "</option>";
                    }
                    else
                    {
                        echo "<option value=\"".$row['id_zamestnanec']."\">";
                        echo $row['jmeno']." ".$row['prijmeni'];
                        echo "</option>";
                    }
                }
            }
            echo "</select>";
            echo "</form>";
            echo "<br />";

            if(isset($_SESSION['id_mc']) && $_SESSION['id_mc'] != "null")
            {
                $user->idCalendar = $_SESSION['id_mc'];
                $calc = new Calendar($user);
                $calc->drawMonth();
            }
            break;
        default:
            echo "Požadovaná stránka neexistuje.";
    }
}    
?>
</div>
</body>
</html>
