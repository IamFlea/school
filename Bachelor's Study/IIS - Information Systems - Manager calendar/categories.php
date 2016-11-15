<?php
/**
 * File:    categoties.php
 * Author:  Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 *
 * This file contains management of categories
 *
 * Administration of categories EDIT and DELETE
 */

if(! defined("M_ADD"))
    define("M_ADD", 0);
if(! defined("M_EDIT"))
    define("M_EDIT", 1);

class Category 
{
    public $user;   // class user
    public $id;     // id of cat
    public $name;   // name 
    public $color;  // color without #

    /**
     * Fill it with $user
     */
    public function __construct($user)
    {
        $this->user = $user;
    }

    /**
     * Check if user can edit category.
     */
    public function canEdit()
    {
        $r = @mysql_query("SELECT id_kategorie FROM kategorie WHERE id_zamestnanec = ".$this->user->idCalendar." AND id_kategorie = ".$this->id);
        if(mysql_num_rows($r) > 0)
            return true;
        else
            return false;
    }

    /**
     * Delete category
     */
    public function delete()
    {
        if(! $this->canEdit())
        {
            echo "Nelze smazat";
            return false;
        }
        $r = "DELETE FROM kategorie WHERE id_kategorie=".$this->id;
        if(@mysql_query($r))
            return true;
        return false;
    }

    

    
    /**
     * Check variables, if are they correct
     */
    public function checkCat(&$err, $flag)
    {
        $ok = true;
        if($flag & M_EDIT)
        {
            $ok = $this->canEdit();
            if(! $ok)
            {
                $err[] = "Tuto akci nemůžete upravovat.";
                unset($_POST['catName']);
                unset($_POST['catColor']);
            }
        }

        if(strlen($this->name) <= 1)
        {
            $ok = false;
            $err[] = "Název kategorie je krátký.";
            unset($_POST['catName']);
        }
        else
            $this->name = htmlspecialchars(addslashes(trim($this->name)), ENT_QUOTES, "UTF-8");

        if($this->name > 64)
        {
            $ok = false;
            $err[] = "Název kategorie je příliš dlouhý. Maximální délka je 64 znaků.";
            unset($_POST['catName']);
        }
        if(! preg_match("/^[a-f0-9]{6}$/is", $this->color)) 
        {
            $ok = false;
            $err[] = "Barva kategorie je ve špatném formátu. Použijte prosím připravený javascript nebo hexadecimální tvar.";
            unset($_POST['catColor']);
        }
        $r = @mysql_query("SELECT id_kategorie, nazev_kat FROM kategorie WHERE id_zamestnanec = ".$this->user->idCalendar." AND nazev_kat = '".$this->name."' AND id_kategorie <> ".$this->id);
        if(mysql_num_rows($r) > 0)
        {
            while($row = @mysql_fetch_array($r, MYSQL_ASSOC))
            {
                if($row['nazev_kat'] == $this->name)
                {
                    $ok = false;
                    $err[] = "Název ".$this->name." kategorie již existuje. Použijte prosím jiný.";
                    unset($_POST['catName']);
                }
            }
        }
        
        return $ok;
    } //checkCat


    /**
     * Editing category
     */
    public function updateCategory(&$err)
    {
        if(isset($_POST['catName']) && isset($_POST['catColor']))
        {
            $this->color = $_POST['catColor'];
            $this->name  = $_POST['catName'];
            if($this->checkCat($err, M_EDIT))
            {

                $clr   = $this->color;
                $red   = hexdec(substr($clr, 0, 2));
                $green = hexdec(substr($clr, 2, 2));
                $blue  = hexdec(substr($clr, 4, 2));
                $fontColor = 
                    0.213 * $red +
                    0.715 * $green +
                    0.072 * $blue 
                    < 127 ? 'FFFFFF' : '000000'; // Grayscale + trashholding 
                $result = @mysql_query("UPDATE kategorie SET nazev_kat='$this->name', barva='$this->color', pismo='$fontColor' WHERE id_kategorie=$this->id;");
                //echo mysql_error();
                if(! $result)
                {
                    $err[] = "Chyba s databází!";
                    return false;
                }
                if(isset($info))
                    $info[] = "Kategorie byla přidána do databáze.";
                unset($_POST['catName'], $_POST['catColor']);
                return true;
            }
        }
        else
        {
            echo "Prázdné pole ve formuláři";
            return false;
        }
    }

    public function add(&$err)
    {
        $this->color = $_POST['catColor'];
        $this->name  = $_POST['catName'];
        $this->id    = 0;
        $ok = $this->checkCat($err, M_ADD);
        if($ok)
        {
            $clr   = $this->color;
            $red   = hexdec(substr($clr, 0, 2));
            $green = hexdec(substr($clr, 2, 2));
            $blue  = hexdec(substr($clr, 4, 2));
            $fontColor = 
                0.213 * $red +
                0.715 * $green +
                0.072 * $blue 
                < 127 ? 'FFFFFF' : '000000'; // Grayscale + trashholding 
            $r = @mysql_query("INSERT INTO kategorie (`id_kategorie`, `id_zamestnanec`,   `nazev_kat`,       `barva`       , `pismo`) VALUES
                (NULL,          ".$this->user->idCalendar.", '$this->name', '$this->color' , '$fontColor');");
            $this->idCategory = mysql_insert_id();
            if(! $r)
            {
                $err[] = "Chyba při vkládání do databáze!";
                return false;
            }
            $ok = mysql_insert_id();
            if(isset($info))
                $info[] = "Kategorie byla přidána do databáze.";
            unset($_POST['catName'], $_POST['catColor']);
        }
        return $ok;
    }
    /**
     * Create form
     */
    public function createForm()
    {
        if(! $this->user->idCalendar)
            return;
        $rslt = false;
        $err = array();
        if(isset($_GET['action']) && $_GET['action'] == "addCat")
        {
            if(! $this->add($err))
                foreach($err as &$e)
                    echo "<font color=\"#ff0000\">$e</font><br />";
        }
        if(isset($_GET['idDel']))
        {
            $this->id = $_GET['idDel'];
            if($this->delete())
                echo "Smazáno <br />";
        }
        if(isset($_GET['id']))
        {
            $this->id = $_GET['id'];
            if((isset($_GET['edit']) && $_GET['edit'] == 2))
                $rslt = $this->updateCategory($err);
        }
        if(isset($_GET['id']) && $rslt == false)
        {
            $this->id = $_GET['id'];
            foreach($err as &$item)
                echo "<font color=\"#ff0000\">$item</font><br />";
            if((isset($_GET['edit']) && $_GET['edit'] == 1) || ($rslt == false))
            {

                if(isset($_POST['catColor']) || isset($_POST['catName']))
                {
                    if(isset($_POST['catName']) && $_POST['catName'] != NULL)
                        $nazev = $_POST['catName'];
                    else
                        $nazev = "";

                    if(isset($_POST['catColor']) && $_POST['catColor'] != NULL)
                        $barva = $_POST['catColor'];
                    else
                        $barva = "";
                }
                else
                {
                    $r = @mysql_query("SELECT * FROM kategorie WHERE id_zamestnanec=".$this->user->idCalendar." AND id_kategorie=".$this->id);
                    if($row = mysql_fetch_array($r, MYSQL_ASSOC))
                    {
                        $nazev = $row['nazev_kat'];
                        $barva = $row['barva'];
                    }
                }
                echo '<h3> Úprava kategorie </h3>';
                echo '<form action="?page=categories&id='.$this->id.'&edit=2" method="POST">';
                echo '<table>';
                echo '<tr><td>Název</td><td><input type="text" name="catName" value="'.$nazev.'" /></td></tr>';
                echo '<tr><td>Barva</td><td><input class="color" name="catColor" value="'.$barva.'" /></td></tr>';
                echo '</table>';
                echo '<input type="submit" name="submit" value="Uložit" />';
                echo '</form>';
                echo '<a href="?page=categories">Zpět</a>';
            }
        }
        else
        {
            echo '<h3>Všechny kategorie</h3>';
            echo "<table>";
            echo "<tr>";
            echo "<td style=\"text-align: center; text-decoration: underline;\">Název</td><td style=\"text-align: center; text-decoration: underline;\">Barva</td>";//<td>Editace</td><td>Smazat</td>";
            echo "</tr>";
            $r = @mysql_query("SELECT * FROM kategorie WHERE id_zamestnanec=".$this->user->idCalendar);
            if(mysql_num_rows($r) == 0)
                echo "<tr><td colspan=\"2\">Nemáte žádnou kategorii </td></tr>";
            while ($row = mysql_fetch_array($r))
            {
                echo "<tr>";
                echo "<td style=\"text-align: center;\">".$row['nazev_kat']."</td><td><div style=\"background-color: #".$row['barva']."; color: #".$row['pismo']."\"\">".$row['barva']."</div></td>";

                echo "<td style=\"text-align: center;\">&nbsp;<a href=\"?page=categories&id=".$row['id_kategorie']."&edit=1\">";
                echo "<img style=\"border: 0px;\" src=\"edit.png\" alt=\"E\" title=\"Upravit\" \>";
                echo "</a>&nbsp;</td>";

                echo "<td style=\"text-align: center;\"><a href=\"?page=categories&idDel=".$row['id_kategorie']."\">";
                echo "<img style=\"border: 0px;\" src=\"delete12.png\" alt=\"X\" title=\"Smazat\" \>";
                echo "</a></td>";

                echo "</tr>";
            }
            echo "</table><br />";
            if(isset($_POST['catName']) && $_POST['catName'] != NULL)
                $nazev = $_POST['catName'];
            else
                $nazev = "";
            if(isset($_POST['catColor']) && $_POST['catColor'] != NULL)
                $barva = $_POST['catColor'];
            else
                $barva = "";
            echo '<form method="POST" action="?page='.$_GET['page'].'&action=addCat">';
            echo '<table><tr><td><b>Název</b> </td><td><input type="text" name="catName" value="'.$nazev.'"/></td></tr>';
            echo '<tr><td><b>Barva</b></td><td><input class="color" name="catColor" value="'.$barva.'"/> ';
            echo '</td></tr> </table>';
            echo '<input type="submit" value="OK" name="newCat" />';
            echo '</form>';
        }
    }
}
?>
