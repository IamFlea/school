
<?php
/**
 * File:    event.php
 * Author:  Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 *
 * License: Muzes kreslit, muzes psat ale listy netrhat
 */

include_once("user.php");

if(! defined("UNCHECKED"))
    define("UNCHECKED", 0);    // Event wasnt added by owner

if(! defined("CHECKED"))
    define("CHECKED", 1);      // Event was added by owner the calendar

if(! defined("NOT_COMMING"))
    define("NOT_COMMING", 2);  // Event was checked but manager is not going there.




class Event
{
    // Actual logged in user
    public $user;

    // For inserting, editing this table in db.
    public $id;
    public $begin;
    public $end;
    public $title;
    public $idCategory;
    public $summary;
    public $author;
    public $addedOn;

    public $endFixed;
    public $beginFixed;
    public $column;
    public $rowspan;
    public $printed;

    // If idCategory wasnt selected. You can create new category from this varibales.
    public $category;
    public $color;
    public $fontColor;

    public function showme()
    {
        echo $this->id;
        echo "<br>";
        echo $this->begin;
        echo "<br>";
        echo $this->end;
        echo "<br>";
        echo $this->title;
        echo "<br>";
        echo $this->idCategory;
        echo "<br>";
        echo $this->summary;
        echo "<br>";
        echo $this->author;
        echo "<br>";
        echo $this->addedOn;
        echo "<br>";
        echo $this->endFixed;
        echo "<br>";
        echo $this->beginFixed;
        echo "<br>";
        echo $this->column;
        echo "<br>";
        echo $this->rowspan;
        echo "<br>";
        echo $this->printed;
        echo "<br>";
        echo $this->category;
        echo "<br>";
        echo $this->color;
        echo "<br>";
        echo $this->fontColor;
    } 

    /**
     * Fills $this->user varibale which mean actual user.
     */
    public function __construct($user, $row=null)
    {
        $this->user = $user;
        if($row != null)
        {
            if(isset($row['id_akce']))
                $this->id          = $row['id_akce'];
            if(isset($row['vlozil']))
                $this->author      = $row['vlozil'];
            if(isset($row['vlozil']))
                $this->addedOn     = $row['vlozeno_dne'];
            if(isset($row['id_kategorie']))
                $this->idCategory   = $row['id_kategorie'];
            if(isset($row['nazev_kat']))
                $this->category    = $row['nazev_kat'];
            if(isset($row['barva']))
                $this->color       = $row['barva'];
            if(isset($row['pismo']))
                $this->fontColor   = $row['pismo'];
            if(isset($row['zacatek']))
                $this->begin       = $row['zacatek'];
            if(isset($row['konec']))
                $this->end         = $row['konec'];
            if(isset($row['nazev']))
                $this->title       = $row['nazev'];
            if(isset($row['podrobnosti']))
                $this->summary     = $row['podrobnosti'];
        }
    }

    /**
     * Fills class variables from POST
     */
    public function constructFromPost()
    {
        if($_POST['newCat'] == "OK")
        {
            if(isset($_POST['category'])) 
                $this->idCategory   = $_POST['category'];
            if(isset($_POST['nameCat']))
                $this->category    = $_POST['nameCat'];
            if(isset($_POST['colorCat']))
                $this->color       = $_POST['colorCat'];        // Because nyan cat is too mainstream
            if(isset($_POST['from'])) 
                $this->beginDate = $_POST['from'];
            if(isset($_POST['fromTime']))
                $this->beginTime = $_POST['fromTime'];
            if(isset($_POST['to'])) 
                $this->endDate = $_POST['to'];
            if(isset($_POST['toTime']))
                $this->endTime = $_POST['toTime'];
            if(isset($_POST['name']))
                $this->title       = $_POST['name'];
            if(isset($_POST['summary']))
                $this->summary     = $_POST['summary'];
            if(isset($_POST['id_boss']) && $_POST['id_boss'] == true)
                $this->participants[]= $this->user->id;
            if(isset($_POST['id_manager']))
                $this->participants[]= $_POST['id_manager'];
        }
    }

    /**
     * Checking variables, adding row in category table... 
     * @param err   array of errors, 
     */
    public function checkClass(& $err)
    {
        $result = true;
        // Regexp for checking date
        // Format: DD.MM.YYYY
        // Including leap years. 
        // yea i should make another function for this..
        $regexpDate = "/^(((0?[1-9]|1\d|2[0-8])\.(0?[1-9]|1[012])|(29|30)\.(0?[13456789]|1[012])|31\.(0?[13578]|1[02]))\.(19|[2-9]\d)\d{2}|29\.0?2\.((19|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(([2468][048]|[3579][26])00)))$/";

        // Regexp Checking time HH:MM
        $regexpHours = "/^(0?[0-9]|1[0-9]|2[0-4]):(0?[0-9]|[1-5][0-9])$/";


        // Check begining time 
        if(isset($this->beginDate))
        {   
            if(! preg_match($regexpDate, $this->beginDate))
                $err[] = "Nesprávný formát začátku akce.";
            else
                $_POST['e_begin_date'] = $_POST['from'];
        }
        if(isset($this->beginTime))
        {
            if(! preg_match($regexpHours, $this->beginTime))
                $err[] = "Nesprávný formát začátku akce.";
            else
                $_POST['e_begin_time'] = $_POST['fromTime'];

        }
        if(isset($_POST['e_begin_date'], $_POST['e_begin_time']))
        {
            $tmp = explode("-", $this->beginDate);
            if(!isset($tmp[1])) {
                $tmp = explode(".", $this->beginDate);
            }
            if(strlen($tmp[2]) == 1)
                $tmp[2] = "0".$tmp[2];
            if(strlen($tmp[1]) == 1)
                $tmp[1] = "0".$tmp[1];
            $tmph = explode(":", $this->beginTime);
            if(strlen($tmph[0]) == 1)
                $tmph[0] = "0".$tmph[0];
            if(strlen($tmph[1]) == 1)
                $tmph[1] = "0".$tmph[1];
            $this->begin = $tmp[2] ."-". $tmp[1] ."-". $tmp[0] ." ".$tmph[0].":".$tmph[1].":00";
        }


        // Check ending time
        if(isset($this->endDate))
        {   
            if(! preg_match($regexpDate, $this->endDate))
                $err[] = "Nesprávný formát konce akce.";
            else
                $_POST['e_end_date'] = $this->endDate; 
        }
        if(isset($this->endTime))
        {
            if(! preg_match($regexpHours, $this->endTime))
                $err[] = "Nesprávný formát konce akce.";
            else
                $_POST['e_end_time'] = $this->endTime; 

        }
        if(isset($_POST['e_end_date'], $_POST['e_end_time']))
        {
            $tmp = explode("-", $this->endDate);
            if(!isset($tmp[1])) {
                $tmp = explode(".", $this->endDate);
            }
            if(strlen($tmp[2]) == 1)
                $tmp[2] = "0".$tmp[2];
            if(strlen($tmp[1]) == 1)
                $tmp[1] = "0".$tmp[1];

            $tmph = explode(":", $this->endTime);
            if(strlen($tmph[0]) == 1)
                $tmph[0] = "0".$tmph[0];
            if(strlen($tmph[1]) == 1)
                $tmph[1] = "0".$tmph[1];
            $this->end= $tmp[2] ."-". $tmp[1] ."-". $tmp[0] ." ".$tmph[0].":".$tmph[1].":00";
        }

        if(isset($_POST['to']) && isset($_POST['toTime']))
        {
            $_POST['e_end_date'] = $_POST['to'];
            $_POST['e_end_time'] = $_POST['toTime'];
            $tmp = explode("-", $_POST['to']);
            if(!isset($tmp[1])) {
                $tmp = explode(".", $this->endDate);
            }
            $this->end = $tmp[2] ."-". $tmp[1] ."-". $tmp[0] ." ".$_POST['toTime'].":00";
        }




        // Begin
        if($this->begin != null)
        {
            if(! mCheckDatetime($this->begin))
                $err[] = "Nesprávný formát začátku akce.".$this->begin;
            else
            {
                if(empty($this->id) && $this->begin <= (date("Y-m-d")." 00:00:00"))
                    $err[] = "Akce musí začínat později!";
                else
                {
                    $_POST['e_begin'] = $this->begin;
                }
            } 
        }
        else
            $err[] = "Chybí Vám vyplnit datum začátku akce.";
        


        //End
        if($this->end !== null)
        {
            if(! mCheckDatetime($this->end))
                $err[] = "Nesprávný formát datumu konce akce.";
            else
            {
                if($this->end < $this->begin)
                {
                    echo $this->end. "<" .$this->begin;
                    $err[] = "Konec akce je dříve než začátek.. vymyslel jste snad stroj času??";
                }
                else
                {
                    $_POST['e_end'] = $this->end;
                }
            }
        }
        else
            $err[] = "Chybí Vám vyplnit datum konce akce.";


        // Title check
        if($this->title != null)
        {
            $this->title = htmlspecialchars(addslashes(trim($this->title)), ENT_QUOTES, "UTF-8");
            if(strlen($this->title) >= 64)
                $err[] = "Délka názvu akce musí být kratší než 64 znaků!";
            else
            {
                $_POST['e_title'] = $this->title; 
            }
        }
        else
            $err[] = "Prosím zadejte název akce.";


        // Description of event
        if($this->summary != null)
        {
            $this->summary = htmlspecialchars(addslashes(trim($this->summary)), ENT_QUOTES, "UTF-8");
            if(strlen($this->summary) >= 65535)
                $err[] = "Prosím zkraťte podrobnosti akce. Nikdo nebude číst Vaše slohy o tom, jak Ted poznal svou manželku!";
            else
            {
                $_POST['e_summary'] = $this->summary;
                $this->summary= "'".$this->summary."'";
            }
        }
        else
        {
            $this->summary = "NULL";
        }

        
        // Category
        if($this->idCategory == "null" && $this->idCategory == NULL) // <-- hack
        {
            $_POST['e_idCat'] = $this->idCategory;
            $this->idCategory = NULL;
        }
        else if($this->idCategory == "new") 
        {
            if($this->category != null)
            {
                $ok = true;
                $_POST['e_cat_title'] = $this->category;
                $_POST['e_cat_color'] = $this->color;

                if(strlen($this->category) > (64))
                {
                    $ok = false;
                    $err[] = "Název kategorie je příliš dlouhý. Maximální délka je 64 znaků.";
                    unset($_POST['e_cat_title']);
                }
                if(! preg_match("/^[a-f0-9]{6}$/is", $this->color)) 
                {
                    $ok = false;
                    $err[] = "Barva kategorie je ve špatném formátu. Použijte prosím připravený javascript nebo hexadecimální tvar.";
                    unset($_POST['e_cat_color']);
                }
                $r = @mysql_query("SELECT id_kategorie FROM kategorie WHERE id_zamestnanec = ".$this->user->idCalendar." AND nazev_kat = '".$this->category."'");
                if(mysql_num_rows($r) > 0)
                {
                    $ok = false;
                    $err[] = "Název této kategorie již existuje. Použijte prosím jiný.";
                    unset($_POST['e_cat_title']);
                }
                
                if($ok)
                {
                    $clr = $this->color;
                    $red   = hexdec(substr($clr, 0, 2));
                    $green = hexdec(substr($clr, 2, 2));
                    $blue  = hexdec(substr($clr, 4, 2));
                    $fontColor = 
                        0.213 * $red +
                        0.715 * $green +
                        0.072 * $blue 
                        < 127 ? 'FFFFFF' : '000000'; // Grayscale + trashholding 
                    $r = @mysql_query("INSERT INTO kategorie (`id_kategorie`, `id_zamestnanec`,   `nazev_kat`,       `barva`       , `pismo`) VALUES
                        (NULL,          ".$this->user->idCalendar.", '$this->category', '$this->color' , '$fontColor');");
                    $this->idCategory = mysql_insert_id();
                    if(! $r)
                    {
                        $err[] = "Chyba při vkládání do databáze!";
                        return false;
                    }
                    if(isset($info))
                        $info[] = "Kategorie byla přidána do databáze.";
                    unset($_POST['e_cat_title'], $_POST['e_cat_color']);
                    $_POST['e_idCat'] = $this->idCategory;
                }
            }
        }
        else  // Use existing category
        {
            $_POST['e_idCat'] = $this->idCategory;
        }


        // Margin two lists
        $err = array_merge($err);
        // If some error, return false instead of string
        if(! empty($err))
            $result = false;
        return $result;
    } // checkClass 



    /**
     * Add event in DB.
     * @err         Array of errors
     * @param $user Array of participant of this event. 
     * @return      boolean
     */
    public function create(& $err)
    { 
        // Check data.
        if($this->checkClass($err, 1) == false)
            return false;
        
        //var_dump($this);
        //return false;
        // Insert event
        $result = @mysql_query("INSERT INTO akce (`id_akce`, `vlozil`,           `vlozeno_dne`, `zacatek`,      `konec`,      `nazev`,        `podrobnosti`) VALUES
                                                 (NULL,     ".$this->user->id.", NOW(),         '$this->begin', '$this->end', '$this->title', $this->summary);");
        $idEvent  = mysql_insert_id();
        if($result)
        {
            // Boss is adding for managers
            if(!empty($this->participants))
            {
                if($this->user->isBoss())
                {
                    $insert = "INSERT INTO se_zucastni (`id_akce`, `id_zamestnanec`, `id_kategorie`, `checked`) VALUES";
                    foreach($this->participants as $participant)
                    {
                        if($participant == $this->user->id)
                            $insert .= "($idEvent, $participant, NULL, 1),";
                        else
                            $insert .= "($idEvent, $participant, NULL, 0),";
                    }
                    // Delete last char in $insert
                    $insert = preg_replace("/^(.+).$/","\${1}",$insert); 
                    $insert .= ";";
                }
                else
                {
                    $err[] = "Pouze ředitel může přidávat akce všem zaměstnancům.";
                    return false;
                }
            }
            // User or secretary is adding event for himself
            else
            {
                if($this->user->isSecretary())
                    $insert ="INSERT INTO se_zucastni (`id_akce`, `id_zamestnanec`, `id_kategorie`, `checked`) VALUES
                        ($idEvent, ".$this->user->idCalendar.", ".$this->idCategory.", 0);";
                else
                    $insert ="INSERT INTO se_zucastni (`id_akce`, `id_zamestnanec`, `id_kategorie`, `checked`) VALUES
                        ($idEvent, ".$this->user->idCalendar.", ".$this->idCategory.", 1);";
            }

            $result = @mysql_query($insert);
            if ($result)
            {
                unset($_POST['e_begin'], $_POST['e_end'], $_POST['e_title'],$_POST['e_summary'],$_POST['e_cat_title'], $_POST['e_cat_color']);
                return true;
            }
        }
        $err[] = "Došlo k chybě s databázi... ". $insert;
        return false;
    } // create



    /**
     * Edit event in DB
     * @err             array of errors;
     * @return          boolean
     */ 
    private function update(& $err)
    {
        // Can user edit this event?
        if(! $this->checkClass($err))
            return false;

        // Update it!
        $result = @mysql_query("UPDATE akce SET zacatek='$this->begin', konec='$this->end', nazev='$this->title', podrobnosti=$this->summary WHERE id_akce=$this->id");
        if($result)
            return true;
        else
        {
            $err[] = "Došlo k chybě s databázi... ". mysql_error();
            return false;
        }
    }



    /**
     * Delete event from DB
     * @param err       error string Array
     * @return          boolean
     */
    public function delete(& $err)
    {
        if(! $this->canEdit())
        {
            $err[] = "Nemáte povolení smazat tuto akci.";
            return false;
        }
        $result = @mysql_query("DELETE FROM akce WHERE id_akce=$this->id");
        if($result)
            return true;
        else
        {
            $err[] = "Došlo k chybě s databázi.";
            return false;
        }
    }



    /**
     * Can the user edit or delete this event?
     */
    public function canEdit()
    {
        if(empty($this->id))
            return false;
        // Sexretaries can not edit events.
        if($this->user->isSecretary())
            return false;
        
        $result = @mysql_query("SELECT vlozil, role, id_nadrizeny
            FROM akce
            JOIN zamestnanec ON zamestnanec.id_zamestnanec = akce.vlozil
            WHERE id_akce=$this->id");
        if($row = mysql_fetch_array($result, MYSQL_ASSOC))
        {
            if($row['vlozil'] == $this->user->id)
                return true;
            else if($row['role'] == SECRETARY && $row['id_nadrizeny'] == $this->user->id)
                return true;
        }

        return false;
    }

    /**
     * form
     * 
     */
    public function createForm($utime, $managers = null)
    {
        if(date("Ymd", $utime) < date("Ymd"))
        {
            if(empty($managers))
                return;
            else if(isset($_GET['date'])
                    && (date("Ym", $_GET['date']) < date("Ym")))
                return;
        }
        if(isset($_GET['page']))
            $page = $_GET['page'];
        else
            $page = "calc";
        if($page == "calc")
        {
            echo '<script type="text/javascript">';
            echo 'function chck()';
            echo '{';
            echo    'if(document.getElementById(\'nova\').selected==true) {';
            echo        'document.getElementById(\'baf\').style.display="block";';
            echo    '} else {';
            echo        'document.getElementById(\'baf\').style.display="none";';
            echo    '}';
            echo '}';
            echo '</script>';
        }
        echo '<br />';
        if($managers == true)
            echo '<form method="POST" action="?page='.$page.'&action=addEvents&date='.$utime.'">';
        else
            echo '<form method="POST" action="?page='.$page.'&action=addEvent&date='.$utime.'">';
        // echo '<b>Zacatek</b> <input type="text" id="eventStart" name="eventStart" /><br />';
        // echo '<b>Konec</b> <input type="text" id="eventEnd" name="eventEnd" /><br />';
        echo "<table>";
        echo "<tr>";
        echo "<td><b>Začátek</b></td>";
        echo '<td><input type="text" id="from" name="from" value="';
        if(isset($_POST['from']))
            echo $_POST['from'];
        else
            echo date("d.m.Y", $utime);
        echo '" size="7" /> ';
        echo ' <b>Čas</b> <input type="text" name="fromTime" value="';
        if(isset($_POST['fromTime']))
            echo $_POST['fromTime'];
        else
            echo date("H:i", time() + 5*60);
        echo '" size="4" /> </td>';
        echo "</tr><tr>";
        echo "<td><b>Konec</b></td>";
        echo '<td><input type="text" id="to" name="to" value="';
        if(isset($_POST['to']))
            echo $_POST['to'];
        else
            echo date("d.m.Y", $utime);
        echo '" size="7" /> ';
        echo ' <b>Čas</b> <input type="text" name="toTime" value="';
        if(isset($_POST['toTime']))
            echo $_POST['toTime'];
        else
            echo date("H:i", time() + 65*60);
        echo '" size="4" /> </td>';
        echo "</tr><tr><td>";
        echo '<b>Název</b></td> <td> <input type="text" name="name" ';
        if (isset($_POST['name']))
            echo "value=\"".$_POST['name']."\"";
        echo " /></td></tr>";
        echo '<tr><td>Podrobnosti: </td> <td><textarea name="summary" cols="19" rows="4">';
        if (isset($_POST['summary']))
            echo $_POST['summary'];
        echo '</textarea></td></tr>';
        if($page == "calc")
        {
            echo '<tr><td>Kategorie: </td><td>';
            echo '<select name="category" onchange="chck()">';
            echo '<option value="null" ';
            if(empty($_POST['e_idCat']) && empty( $_POST['e_cat_title']) && empty( $_POST['e_cat_color']))
                echo "selected";
            echo '>Žádná</option>';
            $result = @mysql_query("SELECT * FROM kategorie WHERE id_zamestnanec=".$this->user->idCalendar);
            $cnt = mysql_num_rows($result);
            if($cnt > 0)
            {
                while($row = mysql_fetch_array($result, MYSQL_ASSOC))
                {
                    echo '<option value="'.$row['id_kategorie'].'" ';
                    if(isset($_POST['e_idCat']) && $_POST['e_idCat'] == $row['id_kategorie'])
                        echo "selected";
                    echo ' >'.$row['nazev_kat'].'</option>';
                }
            }
            $nova = false;
            if(! $this->user->isSecretary())
            {
                echo '<option value="new" id="nova" ';
                echo " ";
                if(isset($_POST['e_idCat']) && $_POST['e_idCat'] == "new")
                {
                    echo "selected";
                    $nova = true;
                }
                echo '>Nová</option>';
            }
            echo '</select></td></tr>';
            if($nova == true)
                echo '<tr><td colspan="2"><div id="baf">';
            else
                echo '<tr><td colspan="2"><div id="baf" style="display:none">';
            echo '<table><tr><td><b>Název</b> </td><td><input type="text" name="nameCat"';
            echo ' ';
            if(isset($_POST['e_cat_title']))
                echo 'value="'.$_POST['e_cat_title'].'"';
            echo ' /></td></tr>';
            echo '<tr><td><b>Barva</b></td><td><input class="color" name="colorCat" ';
            if(isset($_POST['e_cat_color']))
                echo 'value="'.$_POST['e_cat_color'].'"';
            echo ' /> </td></tr> </table> </div>';
            echo '</td></tr>';
        }
        else if($page != "coworkingEvent")
        {
            echo '<tr><td>Zúčastněte se jí také:</td><td> <input type="checkbox" name="id_boss" />';
            echo '<input type="hidden" name="id_manager" value="'.$this->user->idCalendar.'"/></td></tr>';
        }
        echo "</table>";
        echo '<input type="submit" value="OK" name="newCat" />';
        echo '</form>';
    }

    private function editMyEvent(&$err)
    {
        if($this->idCategory == "new")
        {
            $ok = true;
            if(($c = strlen($this->category)) > (64))
            {
                $ok = false;
                $err[] = "Název kategorie je příliš dlouhý. Maximální délka je 64 znaků.";
            }
            if($c <= 2)
            {
                $ok = false;
                $err[] = "Název kategorie je krátký.";
            }
            if(! preg_match("/^[a-f0-9]{6}$/is", $this->color)) 
            {
                $ok = false;
                $err[] = "Barva kategorie je ve špatném formátu. Použijte prosím připravený javascript nebo hexadecimální tvar.";
            }
            $r = @mysql_query("SELECT id_kategorie FROM kategorie WHERE id_zamestnanec = ".$this->user->idCalendar." AND nazev_kat = '".$this->category."'");
            if(mysql_num_rows($r) > 0)
            {
                $ok = false;
                $err[] = "Název této kategorie již existuje. Použijte prosím jiný.";
            }
            
            if($ok)
            {
                $clr = $this->color;
                $red   = hexdec(substr($clr, 0, 2));
                $green = hexdec(substr($clr, 2, 2));
                $blue  = hexdec(substr($clr, 4, 2));
                $fontColor = 
                    0.213 * $red +
                    0.715 * $green +
                    0.072 * $blue 
                    < 127 ? 'FFFFFF' : '000000'; // Grayscale + trashholding 
                $r = @mysql_query("INSERT INTO kategorie (`id_kategorie`, `id_zamestnanec`,   `nazev_kat`,       `barva`       , `pismo`) VALUES
                    (NULL,          ".$this->user->idCalendar.", '$this->category', '$this->color' , '$fontColor');");
                if(! $r)
                {
                    $err[] = "Chyba při vkládání do databáze!";
                    return false;
                }
                else
                    $this->idCategory = mysql_insert_id();
            }
        }
        if(is_numeric($this->idCategory) || $this->idCategory == "null")
        {
            if($this->idCategory == "null")
                $this->idCategory = "NULL";  // CAPSLOCK ON
            $r = @mysql_query("UPDATE se_zucastni SET id_kategorie=$this->idCategory WHERE id_zamestnanec=".$this->user->id." AND id_akce=$this->id");
            if($r)
                return true;
            else
            {
                $err[] = "Nelze vložit do DB. ". mysql_error();
                return false;
            }
        }
    } 
    public function editForm()
    {
        if(! isset($_GET['date'], $_GET['eeid'], $_GET['page']))
            return true;
        $id = $_GET['eeid'];
        $this->id = $id;
        if(isset($_POST['newCat']) && $_POST['newCat'] == "OK")
        {
            $err = array();
            $rslt = true;
            if($this->canEdit())
            {
                $this->constructFromPost();
                $tmp = $this->idCategory;
                $this->idCategory = "null"; 
                $rslt = $this->update($err);
                $this->idCategory = $tmp;
            }
            $rslt2 = true;
            if(isset($_POST['idCategory']))
            {
                $this->constructFromPost();
                $this->idCategory = $_POST['idCategory'];
                $rslt2 = ($this->editMyEvent($err));
            }
            if($rslt == true && $rslt2 == true)
                return true;
            if(! empty($err))
            {
                foreach($err as &$item)
                    echo "<font color=\"#ff0000\">$item</font><br />";
            }

        }
        echo '<script type="text/javascript">';
        echo 'function chck()';
        echo '{';
        echo    'if(document.getElementById(\'nova\').selected==true) {';
        echo        'document.getElementById(\'baf\').style.display="block";';
        echo    '} else {';
        echo        'document.getElementById(\'baf\').style.display="none";';
        echo    '}';
        echo '}';
        echo '</script>';

        echo "<form action=\"?page=".$_GET['page']."&date=".$_GET['date']."&eeid=$id\" method=\"POST\">";
        echo "<table>";
        if($this->canEdit())
        {
            // Paranoid programmer
            $query = "SELECT *
                FROM akce
                WHERE id_akce = ".$id.";";
            $r = @mysql_query($query);
            if($r)
            {
                while($row = mysql_fetch_array($r, MYSQL_ASSOC))
                {
                    echo "<tr>";
                    echo "<td><b>Začátek</b></td>";
                    echo '<td><input type="text" id="from" name="from" value="';
                    if( isset($_POST['from']))
                        echo $_POST['from'];
                    else
                        echo mDatetimeToDateCs($row['zacatek']);
                    echo '" size="7" /> ';
                    echo ' <b>Čas</b> <input type="text" name="fromTime" value="';
                    if(isset($_POST['fromTime']))
                        echo $_POST['fromTime'];
                    else
                        echo mDatetimeToTime($row['zacatek']);
                    echo '" size="4" /> </td>';
                    echo "</tr><tr>";
                    echo "<td><b>Konec</b></td>";
                    echo '<td><input type="text" id="to" name="to" value="';
                    if(isset($_POST['to']))
                        echo $_POST['to'];
                    else
                        echo mDatetimeToDateCs($row['konec']);
                    echo '" size="7" /> ';
                    echo ' <b>Čas</b> <input type="text" name="toTime" value="';
                    if(isset($_POST['toTime']))
                        echo $_POST['toTime'];
                    else
                        echo mDatetimeToTime($row['konec']);
                    echo '" size="4" /> </td>';
                    echo "</tr><tr><td>";
                    echo '<b>Název</b></td> <td> <input type="text" name="name" value="';
                    if(isset($_POST['name']))
                        echo $_POST['name'];
                    else
                        echo $row['nazev'];
                    echo "\" /></td></tr>";
                    echo '<tr><td>Podrobnosti: </td> <td><textarea name="summary" cols="19" rows="4">';
                    if(isset($_POST['summary']))
                        echo $_POST['summary'];
                    else
                        echo $row['podrobnosti']; 
                    echo '</textarea></td></tr>';
                }
            }
            else
                echo mysql_error();
        }

        if($this->user->idCalendar == $this->user->id)
        {   // Vlastnik kalendare
            $query = "SELECT checked, id_kategorie FROM se_zucastni WHERE id_zamestnanec=".$this->user->id." AND id_akce=".$id;

            $r = @mysql_query($query); // nope
            if($row = mysql_fetch_array($r, MYSQL_ASSOC))
            {
                $checked    = $row['checked'];
                $idCategory = $row['id_kategorie'];
                if(isset($_POST['category']))
                    $idCategory = $_POST['category'];
            }
            else
            {
                echo mysql_error();exit;
            }
            echo '<tr><td>Kategorie: </td><td>';
            echo '<select name="idCategory" onchange="chck()">';
            echo '<option value="null" ';
            if($idCategory == "NULL")
                echo "selected";
            echo '>Žádná</option>';
            $result = @mysql_query("SELECT * FROM kategorie WHERE id_zamestnanec=".$this->user->idCalendar);
            $cnt = mysql_num_rows($result);
            if($cnt > 0)
            {
                while($row = mysql_fetch_array($result, MYSQL_ASSOC))
                {
                    echo '<option value="'.$row['id_kategorie'].'"';
                    if($idCategory == $row['id_kategorie'])
                        echo "selected";
                    echo ' >'.$row['nazev_kat'].'</option>';
                }
            }
            echo '<option value="new" id="nova">Nová</option>';
            echo '</select></td></tr>';
            echo '<tr><td colspan="2"><div id="baf" style="display:none">';
            echo '<table><tr><td><b>Název</b> </td><td><input type="text" name="nameCat" /></td></tr>';
            echo '<tr><td><b>Barva</b></td><td><input class="color" name="colorCat" ';
            echo ' /> </td></tr> </table> </div>';
            echo '</td></tr>';
        }

        echo "</table>";
        echo '<input type="submit" value="OK" name="newCat" />';
        echo '</form>';
        return false;
    }// editForm

}// class


?>
