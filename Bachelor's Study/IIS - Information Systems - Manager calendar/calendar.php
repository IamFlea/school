<?php
/**
 * File:    calendar.php 
 * Authors: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 *          Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 *
 * Prasatko pro Joeyho
 *  <'##)~
 *   ^ ^
 */

include("event.php");

// Day on planet Earth has 86400 seconds... Really!!
if(! defined("DAY"))
    define("DAY", 86400);

if(! defined("BIG"))
    define("BIG", 42);

class Calendar
{
    public $events;         // Array of events

    private $maxEvents;     // Maximal number of overlapping events
    private $user;          // Acutall logged in user
    private $managers;      // ID of managers 

    private $page;          // $_GET['page']

    /**
     * Prepare variables of this class
     */
    public function __construct($user)
    {
        $this->events = array();
        $this->managers = array();
        if(isset($_SESSION['managers']))
            $this->managers = $_SESSION['managers'];
        else
            $_SESSION['managers'] = array();
        $this->user = $user;
        if(isset($_GET['page']))
            $this->page = $_GET['page'];
        else
            $this->page = "calc";
    }



    /**
     * Fill array with events for actual day
     * @param <date>    unixtime
     */
    private function fillEvents($date, $managers=false)
    {
        $date = mUnixtimeToDate($date);
        $ok = false;

        # Classic
        if($managers == false)
        {
            $tmp = "(SELECT a.*, s.id_kategorie, k.nazev_kat, k.barva, k.pismo
            FROM akce a, se_zucastni s, kategorie k
            WHERE a.id_akce = s.id_akce 
                AND s.id_kategorie = k.id_kategorie
                AND s.id_zamestnanec=".$this->user->idCalendar."
                AND ((a.zacatek > \"".$date." 00:00:00\" AND a.zacatek < \"".$date." 23:59:59\") 
                    OR (a.konec > \"".$date." 00:00:00\" AND a.konec < \"".$date." 23:59:59\") 
                    OR (a.zacatek < \"".$date." 00:00:00\" AND a.konec > \"".$date." 23:59:59\")))
            UNION
            (SELECT a.*, s.id_kategorie, NULL, NULL, NULL
            FROM akce a, se_zucastni s
            WHERE a.id_akce = s.id_akce 
                AND s.id_kategorie IS NULL
                AND s.id_zamestnanec = ".$this->user->idCalendar."
                AND ((a.zacatek > \"".$date." 00:00:00\" AND a.zacatek < \"".$date." 23:59:59\") 
                    OR (a.konec > \"".$date." 00:00:00\" AND a.konec < \"".$date." 23:59:59\") 
                    OR (a.zacatek < \"".$date." 00:00:00\" AND a.konec > \"".$date." 23:59:59\")))
                    ORDER BY zacatek";
        }

        # Special - if boss wants to see pritomnost of managers
        else
        {
            $tmp = "SELECT a.*, s.id_kategorie, NULL
            FROM akce a, se_zucastni s
            WHERE a.id_akce = s.id_akce 
                AND ((a.zacatek > \"".$date." 00:00:00\" AND a.zacatek < \"".$date." 23:59:59\") 
                    OR (a.konec > \"".$date." 00:00:00\" AND a.konec < \"".$date." 23:59:59\") 
                    OR (a.zacatek < \"".$date." 00:00:00\" AND a.konec > \"".$date." 23:59:59\"))
                AND s.id_zamestnanec IN (".$managers.")
                    ORDER BY zacatek";
        }
        
        $result = @mysql_query($tmp);
        while($row = mysql_fetch_array($result, MYSQL_ASSOC))
        {
            $event = new Event($this->user, $row);
            $this->events[] = $event;
            $ok = true;
        }

        return $ok;
    }//fill events

    /**
     * If there are new events for manager
     * @return number of new events
     */
    public function newEvents()
    {
        if($this->user->idCalendar)
        {
            $r = @mysql_query("SELECT * FROM se_zucastni WHERE id_zamestnanec=".$this->user->idCalendar." AND checked=0");
            return mysql_num_rows($r);
        }
        else
            return 0;
    }

    /**
     * Create month with correct offset. 
     * @return array 
     */
    private function createMonth($time)
    {
        $start = mFirstDayofMonth($time);
        $offset = date("N", $start);
        $maxMonthDay = date("t", $start);
        $d = 1; // day counter
        $i = 0; // iterate counter

        // Make offset
        while(($i+1) < $offset)
        {
            $result[$i] = "&nbsp;";
            $i++;
        }

        // Start counting days
        while($d <= $maxMonthDay)
        {
            $result[$i] = $d;
            $d++;
            $i++;
        }

        // Fill up rest of array
        while($i < 42)
        {
            $result[$i] = "&nbsp;";
            $i++;
        }

        return $result;
    }

    /**
     * Sets event's variable called column. 
     *
     * e
     * ^
     * | !--3--!
     * | !----2----|  |--2--|
     * | |-----------1-------|-----1----|
     * @----------------------------------------> t
     *
     * @return <int> max number of overlapping events.
     */ 
    private function overlappingEvents()
    {
        $i = 0;
        do {
            $ok = false;
            $state = "first";
            // Vsechny akce napresujeme nejdriv do jedneho sloupce... 
            // co zbude do druheho.. co zbude do tretiho etc.
            foreach($this->events as &$event)
            {
                // Uz ji byl pridelen sloupec, vykasli se na ni
                if(is_numeric($event->column))
                    continue;

                else if($state == "first")
                {
                    $state = "second";
                    $i++;
                    $event->column = $i; 
                    $last = $event;
                }
                else if($last->end <= $event->begin)
                {
                    $event->column = $i;
                    $last = $event;
                }
            }

            foreach($this->events as &$event)
                if(! is_numeric($event->column))
                    $ok = true;
        } while ($ok);

        return $i;
    }

    /**
     * Sorting events. 
     */
    private function sortEvents()
    {
        //select sort sry
        for($i = 0; $i < (count($this->events) - 1); $i++)
        {
            $mi = $i;
            for($j = $i+1; $j < count($this->events); $j++)
            {
                $a = $this->events[$j];
                $b = $this->events[$mi];
                if($a->begin < $b->begin)
                    $mi = $j;
            }
            $t = $this->events[$i];
            $this->events[$i] = $this->events[$mi];
            $this->events[$mi] = $t;
        }

    }

    /**
     * Another sorting 
     */
    private function edges()
    {
        $result = array();
        foreach ($this->events as &$event)
        {
            $result[] = $event->begin;
            $result[] = $event->end;
        }
        sort($result, SORT_STRING);
        return array_unique($result);
    }

    /**
     * Calculate something with rowspan.. 
     * Joey did it.. Ask him!
     */
    private function asianGuy($hranice)
    {
        foreach($this->events as &$event)
        {
            $i = -1;
            foreach($hranice as &$cas) 
            {
                if($event->begin == $cas)
                    $i = 1;
                elseif($event->end == $cas)
                    break;
                else
                    $i++;
            }
            $event->rowspan = $i;
        }
    }

    /**
     * Print events for actual day.
     */
    public function echoEvents($date)
    {
        $w = 700;
        $h = 350;
        $hranice = $this->edges();
        $minut = mSumMinutes($hranice[0], end($hranice), $date );

        $pixelMinute = 1.5*$h/$minut;
        $oldtime = -1;
        $maxEvents = $this->overlappingEvents();
        $this->asianGuy($hranice);
        for($i=1; $i <= $maxEvents; $i++)
            $a[$i] = 1;
        echo "<br/>";
        echo "<script>";
        echo "$(function() {";
        echo    "$( \"#tableDay\" ).tooltip();";
        echo "});";
        echo "</script>";
        echo "<table id=\"tableDay\" style=\"border-collapse: collapse\"  border=\"1\">";
        $bool = false;
        if($maxEvents >= 3)
        {
            $maxEvents++;
            $bool = true;
        }
        foreach ($hranice as $row =>  &$time)
        {
            if(($oldtime) == -1)
                echo "<tr>";
            else
                echo "<tr class=\"dayRow\" id=\"".$minut."#".mSumMinutes($oldtime, $time, $date)."\" height=\"".round(mSumMinutes($oldtime, $time, $date) * $pixelMinute) ."\">";

            for($i = 0; $i <= $maxEvents; $i++)
            {
                if($i == 0 || ($i == $maxEvents && $bool))
                {
                    echo '<td style="vertical-align: bottom; background-color: #D6D6D6;">';
                    $tmp = new Event($this->user);
                    echo mDatetimeToTime(mCutDay($time, $date));
                    echo "</td>";
                }
                else if($row != 0)
                {
                    $found = false;
                    foreach($this->events as &$akce)
                    {
                        if($akce->column == $i && $oldtime == $akce->begin)
                        {
                            if(empty($akce->color))
                                $akce->color = "FFFFFF";

                            // DO NOT TOUCH MAGIC
                            echo "<td"; 
                            if ($akce->summary != "")
                                echo " title=\"".$akce->summary."\"";
                            else
                                echo " title=\"<i>Bez popisu</i>\"";

                            echo " onClick=\"$(function() {";
                            echo "    $( '#dialogEvent".$akce->id."' ).dialog();";
                            echo "});\"";
                            echo ' style="text-align:center; background-color: #'.$akce->color.'; color: #'.$akce->fontColor.'; border: 1px solid black; max-width: 250px; min-width: 150px; overflow: auto"';
                            echo " rowspan=\"$akce->rowspan\">";
                            echo "$akce->title";
                            $found = true;
                            $a[$i] = $akce->rowspan;
                            echo "<div style=\"display: none;\" id=\"dialogEvent".$akce->id."\" title=\"";

                            if(date("Ymd", strtotime($akce->begin)) == date("Ymd", $date) && date("Ymd", strtotime($akce->end)) == date("Ymd", $date))
                                echo mDatetimeToTime($akce->begin)." - ".mDatetimeToTime($akce->end);
                            else
                                echo date("j.m H:i", strtotime($akce->begin))." - ".date("j.m H:i", strtotime($akce->end));

                            echo "<br />".$akce->title."\">";
                            $q = "SELECT z.jmeno, z.prijmeni FROM zamestnanec z, se_zucastni s WHERE z.id_zamestnanec=s.id_zamestnanec AND s.id_akce=".$akce->id ." AND s.id_zamestnanec != ". $this->user->id;
                            $rr = @mysql_query($q);
                            if(isset($akce->id) && mysql_num_rows($rr) > 0)
                            {
                                echo "<div style=\"text-align: left; font-size: 12px\">";
                                echo "<b>Zúčastní se také: </b>";
                                $true = false;
                                while($row2 = mysql_fetch_array($rr, MYSQL_ASSOC))
                                {
                                    if($true)
                                        echo ", ";
                                    echo $row2['jmeno'] ." ". $row2['prijmeni'];
                                    $true = true;
                                }
                                echo "</div>";
                            }
                            echo "<p>".$akce->summary."</p>";
                            if(isset($akce->author, $akce->addedOn))
                            {
                                echo "<div style=\"text-align: left; font-size: 12px\">";
                                echo "<i>Vložil(a) ";
                                $q = "SELECT role, jmeno, prijmeni FROM zamestnanec WHERE id_zamestnanec=".$akce->author;
                                $rr = @mysql_query($q);
                                if($row2 = mysql_fetch_array($rr, MYSQL_ASSOC))
                                    echo $row2['jmeno'] ." ". $row2['prijmeni']; 
                                echo "<br/>dne ". mDate(strtotime($akce->addedOn)) ." v ".mDatetimeToTime($akce->addedOn).".</i><br />";
                                echo "</div>";
                            }
                            echo "</div>";
                            echo "</td>";
                        }
                    }
                    if(! $found)
                    {
                        if($a[$i] == 1)
                            echo "<td> &nbsp; </td>";
                        else
                            $a[$i]--;
                    }
                }
                else 
                {
                    echo '<td> &nbsp; </td>';
                }
            }
            echo "</tr>";
            $oldtime = $time;
        }
        echo "</table>";
        return; 
    } 


    /**
     * Print events in cell of celandar.
     */
    private function printShortEvent($date)
    {
        $first = true;
        foreach($this->events as &$event)
        {
            if($first != true)
                echo "<div style=\"height:3px;\"></div>";
            $event->begin = mCutDay($event->begin, $date);
            $event->end = mCutDay($event->end, $date);
            if($event->idCategory == null)
                echo "<div style=\"text-align:left;\">";
            else
                echo '<div style="text-align:left ;background-color: #'.$event->color.'; color: #'.$event->fontColor.';">';

            echo substr($event->title, 0, 16);
            
            if(! $this->user->isSecretary())
            {
                echo "<div style=\"float: right;\">";
                if($this->user->isManager() || $this->user->isBoss() && $this->user->idCalendar == $this->user->id || $event->canEdit())
                {
                    echo "<a href=\"?page=".$this->page."&date=".$_GET['date']."&eeid=$event->id\">";
                    echo "<img style=\"border: 0px;\" src=\"edit.png\" alt=\"E\" title=\"Upravit\" \>";
                    echo "</a>";
                }

                if($event->canEdit())
                {
                    echo "<a href=\"?page=".$this->page."&date=".$_GET['date']."&action=delEvent&id=$event->id\">";
                    echo "<img style=\"border: 0px;\" src=\"delete12.png\" alt=\"X\" title=\"Smazat\" \>";
                    echo "</a>";
                }

                echo "</div>";
            }
            echo "<br/>";
            echo mDatetimeToTime($event->begin) ." -- ". mDatetimeToTime($event->end);
            echo "</div>";
            $first = false;
        }
    }

    /**
     * Reverse merged events
     *
     * ^
     * |            a_begin----a_end
     * +--------------------------> 
     *
     * Result:
     * ^
     * |a_begin-----a_end
     * +-------------------------->
     *
     */
    private function reverse($mergedEvents, $date)
    {   
        $result = array();
        $tmp = false;
        $r_begin = "00:00";
        $r_end   = "23:59";

        if(empty($mergedEvents))
            $result[] = array($r_begin, $r_end);
        else
        {
            foreach ($mergedEvents as &$rangedEvents)
            {
                $begin = mCutDay($rangedEvents[0], $date);
                $tmp = explode(" ", $begin);
                $begin = $tmp[1];
                $tmp = explode(":", $begin);
                $begin = $tmp[0] .":". $tmp[1];

                $end = mCutDay($rangedEvents[1], $date);
                $tmp = explode(" ", $end);
                $end = $tmp[1];
                $tmp = explode(":", $end);
                $end= $tmp[0] .":". $tmp[1];

                if($begin == $r_begin) // 00:00
                {
                    $r_begin = $end;
                    if($end == $r_end)
                        break;
                    continue;
                }

                
                $result[] = array($r_begin, $begin);
                $r_begin = $end;
                $tmp = true;
            }
            if($end != $r_end)      // 23:59
                $result[] = array($r_begin, $r_end);
        }
        if(! empty($result))
        {
            foreach($result as &$t)
                echo $t[0] ." -- ". $t[1]."<br/>";
        }
    }

    /**
     * Merges evnets into one.
     * 
     *  ^ a_begin----a_end
     *  |         b_begin----b_end
     *  +----------------------------> t
     *
     * Result:
     *  ^ a_begin------------a_end
     *  | 
     *  +-----------------------------> t
     */ 
    private function merge()
    {
        $tmp = "0000-00-00 00:00:00";
        $state = "first";
        $result = array();
        foreach($this->events as &$event)
        {
            if($state == "first")
            {
                $mBegin = $event->begin;
                $mEnd = $event->end;
                $state = "second";
            }
            else
            {
                // Events are overlapping, merge them
                if($event->begin > $mEnd)
                {
                    $result[] = array($mBegin, $mEnd);
                    $mBegin = $event->begin;
                    $mEnd   = $event->end;
                }
                else if($event->end >= $mEnd)
                    $mEnd = $event->end;
            }
        }
        if($state == "second")
            $result[] = array($mBegin, $mEnd);
    
        return $result;
    }


    /**
     * Print merged events
     */ 
    private function printMerged($mergedDates, $title = false)
    {
        echo "<div style=\"margin-bottom:3px; text-align: left;\">";
        if($title)
            echo "<i>Ředitel nepřítomen</i> <br />";
        foreach($mergedDates as &$date)
        {
            echo mDatetimeToTime($date[0]) ." -- ". mDatetimeToTime($date[1]);
            echo "<br />";
        }
        echo "</div>";
    } 
    
    /**
     * Print month in table format
     */ 
    public function drawMonth($flag = null)
    {
        // Check date
        if(isset($_GET['date']))
            $date = $_GET['date'];
        else
        {
            $date = time();
            $_GET['date'] = $date;
        }
        $date = $date - date("H", $date)*3600 - date("i", $date)*60 - date("s", $date) + 15*3600;
        // is it todays date?
        if(date("my", time()) == date("my", $date))
            $thisDate = true;
        else
            $thisDate = false;

        // hack
        if(isset($_GET['eeid']))
        {
            $e = new Event($this->user);
            $r = $e->editForm();
            if(! $r)
                return; // hack
            // another hack
        }

        echo "<center><h3>";
        echo mMonth($date);
        echo "</h3></center>";
        $d = mFirstDayofMonth($date);
        $month = $this->createMonth($date);
        if($flag == "freetimes")
        {
            $managers = join(",", $this->managers);
        }
        
        // Navigation
        # datum nekdy konecem mesice 31 or 30 or 28
        $prevMonth = $date - date("j", $date) * 24 * 60 * 60; 
        # datum je zacatkem mesice tedy vzdy jednicka, a to my chcem
        $nextMonth = $prevMonth + 24*60*60 * (date("t", $date) + 1);
        # datum predchoziho mesice se zmeni na prvniho 
        $prevMonth = mFirstDayofMonth($prevMonth);

    
        $prevDay = $date - 24 * 60 * 60; 
        $nextDay = $date + 24*60*60;
        // Draw table
        echo "<table class=\"month\" style=\"border-collapse: collapse\" border=1>";
        echo "<tbody>";
        echo "<tr class=\"header\">";
        // Header of table
        echo "<td class=\"arrow leftArrow\" rowspan=\"7\"><h1><a href=\"?page=".$this->page."&date=$prevMonth\">&#171;</a>&nbsp;</h1></td><td class=\"day\">Po</td><td class=\"day\">Út</td><td class=\"day\">St</td><td class=\"day\">Čt</td><td class=\"day\">Pá</td><td class=\"day\">So</td><td class=\"day\">Ne</td><td class=\"arrow rightArrow\" rowspan=\"7\"><h1>&nbsp;<a href=\"?page=".$this->page."&date=$nextMonth\">&#187;</a></h1></td>";
        echo "</tr>";
        $j = 1; $b = true;

        foreach($month as $i=>&$day)
        {

            // Start of week means new row in table
            if($i % 7 == 0)
                echo "<tr>";

            // Cell of day
            if(! is_numeric($day))
                echo "<td class=\"notDay\">";
            else if(is_numeric($day) && $day == date("d", $date))
                echo "<td class=\"selectedDay\" style=\"font-size: 10px\">";
            else
                echo "<td class=\"day\">";

            if(is_numeric($day))
                echo "<div onClick=\"window.location.replace('?page=".$this->page."&date=".$d."');\" >";
            else
                echo "<div>";

            // The day can be character "x" - not defined
            if(is_numeric($day))
            {
                echo "<div style=\"height:20px;vertical-align:middle;\">";
                // Print day
                if($thisDate && $day == date("d", time())) {
                    echo "<div style=\"float:left; font-size: 16px; font-weight: bold; margin-left:3px;\">$day</div>";
                } else {
                    echo "<div style=\"float:left; font-size: 12px; margin-top:3px;margin-left:3px;\">$day</div>";
                }

                echo "</div>";
                echo "<div class=\"day\" style=\"overflow: auto;\">";
                // Print freetime calendar
                if($flag == "freetimes")
                {
                    $this->fillEvents($d, $managers);                       // Fill up array
                    $this->reverse($this->merge(), $d); // Print it
                    $this->events = array();                                // Free it .. easy huh?? 
                }
                // Print normal calendar
                else
                {
                    // Boss AFKness, only for manager 
                    if($this->user->isManager())
                    {
                        $boss = new User($this->user->bossId);
                        $bossCalc = new Calendar($boss);
                        if($bossCalc->fillEvents($d))
                            $bossCalc->printMerged($bossCalc->merge(), true );
                    }
                    // Print rest
                    $this->fillEvents($d);
                    $this->printShortEvent($d);
                    $this->events = array();
                      
                }
                $d = $d + DAY; 
            }
            else
                echo "<div>$day</div><div class=\"day\">";
            echo "</div></div></td>";
            // End

            // End of week means end of row
            if($i % 7 == 6)
                echo "</tr>"; 
        } //foreach
        echo "</tbody>";
        echo "</table>";


        // Navigation
        echo "<center>";
        echo "<div id=\"calcNav\">";
        echo "<a href=\"?page=".$this->page."&date=$prevDay#calcNav\">&#171;</a>";
        echo " | ";
        echo "<a href=\"?page=".$this->page."\">Dnes</a>";
        echo " | "; 
        echo "<a href=\"?page=".$this->page."&date=$nextDay#calcNav\">&#187;</a>";
        echo "</div>";
        echo "</center>";
        echo "<br />";



        // Vypis akci pro aktualni den
        if($flag != "freetimes")
        {
            echo "<hr />";
            echo mDate($date);
            echo "<br />";

            # Vykresleni akce k danemu dni 
            if($this->fillEvents($date))
            {
                if($this->user->isManager())
                {
                    $boss = new User($this->user->bossId);
                    $bossCalc = new Calendar($boss);
                    if($bossCalc->fillEvents($date))
                    {
                        $tmp2 = $bossCalc->merge(); 
                        foreach($tmp2 as &$tmp)
                        {
                            $e = new Event($this->user);
                            $e->begin = $tmp[0];
                            $e->end = $tmp[1];
                            $e->title = "<i>Ředitel nepřítomen</i>";
                            array_unshift($this->events, $e);
                            //$this->events[] = $e;
                        }
                        $this->sortEvents();
                    }
                }
                $this->echoEvents($date);
            }
            else
            {
                if($this->user->isManager())
                {
                    $boss = new User($this->user->bossId);
                    $bossCalc = new Calendar($boss);
                    if($bossCalc->fillEvents($date))
                    {
                        $tmp2 = $bossCalc->merge(); 
                        foreach($tmp2 as &$tmp)
                        {
                            $e = new Event($this->user);
                            $e->begin = $tmp[0];
                            $e->end = $tmp[1];
                            $e->title = "<i>Ředitel nepřítomen</i>";
                            array_unshift($this->events, $e);
                            //$this->events[] = $e;
                        }
                        $this->echoEvents($date);
                    }
                }
                else
                    echo "<br />K tomuto dni nemáte žadné akce.<br />";
            }

            echo "<br />";
            $newEvent = new Event($this->user);
            $newEvent->createForm($date);
        }

    }


    /**
     * Print forms for coworking events
     * (Splecne akce)
     */
    public function coworkingEvent() 
    {
        if(empty($_GET['page']))
            return;
        if(empty($_GET['date']))
            $date = time();
        else
            $date = $_GET['date'];
        echo "<h1>Volné časy</h1>";
        echo '<table>';
        echo '<tr>';
        echo '<td>';
        // Process each id_zamestnanec, which is selected and which isn't
        // Close your eyes and dont read next lines, thanks
        if(isset($_GET['submitmeh']))
        {
            $this->managers = array();
            foreach($_POST as $key => $value)
            {
                // Gimme id_ from post 
                if(preg_match("/^id_[0-9]+$/", $key) && $value == true)
                {
                    $tmp = explode("_", $key);
                    $this->managers[] = $tmp[1];
                }
            }
        }
        $_SESSION['managers'] = $this->managers; 
        $printForm = true;
        if($this->managers != null)
            $this->drawMonth("freetimes");
        else
        {
            echo 'Nebyl vybrán žadný manažer';
            $printForm = false;
        }
        echo '</td>';
        echo '<td rowspan="2">';
        echo '<form action="?page='.$this->page.'&submitmeh" method="POST">';
        $result = @mysql_query("SELECT id_zamestnanec, jmeno, prijmeni
                                FROM zamestnanec
                                WHERE role=".MANAGER." OR role = ".BOSS);
        if(mysql_num_rows($result) > 0)
        {
            while($row = mysql_fetch_array($result))
            {
                echo '<input type="checkbox" ';
                echo        'name="id_'.$row['id_zamestnanec'].'" ';
                echo        'onchange="this.form.submit() "'; 
                echo        (false !== array_search($row['id_zamestnanec'], $_SESSION['managers']))? "checked" : "";
                echo ' />';
                echo $row['jmeno'] ." ". $row['prijmeni'];
                echo "<br />"; // << i have no idea what i am writing..
            }
        }
        else
            echo "Nemáte žádné manažery.";
        echo '</form>';
        echo '</td>';
        if($printForm == true)
        {
            echo '<tr>';
            echo '<td>';
            $e = new Event($this->user);
            $e->createForm($date, true);
            echo '</td>';
            echo '</tr>';
        }
        echo '</table>';
    }


    /**
     * Check event as read
     */
    private function check($id, $role)
    {   
        if($role == SECRETARY)
        {
            $q = "UPDATE akce SET vlozil=".$this->user->idCalendar." WHERE id_akce=$id";
            $r = @mysql_query($q);
            if( ! $r)
                return false;
        }
        $q = "UPDATE se_zucastni SET checked=1 WHERE id_zamestnanec=".$this->user->idCalendar." AND id_akce=$id";
        $r = @mysql_query($q);
        if($r)
            return true;
        echo mysql_error();
        return false;
    }

    /**
     * Print new events
     */
    public function drawNewEvents()
    { 
        if($this->user->isSecretary())
            return;
        if(isset($_GET['id']) && isset($_POST['check']))
            $this->check($_GET['id'], $_POST['role']);
        echo "<h2>Nově přidané akce</h2>";
        $q = "SELECT a.* FROM akce a, se_zucastni s 
              WHERE s.id_zamestnanec = ".$this->user->idCalendar."
                AND s.checked = 0
                AND a.id_akce = s.id_akce";
        $r = @mysql_query($q);
        $e = new Event($this->user);
        if(mysql_num_rows($r) > 0)
        {
            while($row = mysql_fetch_array($r, MYSQL_ASSOC))
            {
                echo '<div style="border: solid 1px; background-color: #ffffff; width: 700px; text-align: center ">';
                echo "<h3>".$row['nazev']."</h3>";
                echo "<table style=\"margin: auto\">";
                echo "<tr><td>".mDate(strtotime($row['zacatek']))."</td><td rowspan=\"2\">&nbsp;-&nbsp;</td><td>".mDate(strtotime($row['konec']))."</td></tr>";
                echo "<tr><td style=\"text-align: center\">".mDatetimeToTime(($row['zacatek']))."</td><td style=\"text-align: center\">".mDatetimeToTime($row['konec'])."</td></tr>";
                echo "</table>";// */
                echo "<br/>";
                $q = "SELECT z.jmeno, z.prijmeni FROM zamestnanec z, se_zucastni s WHERE z.id_zamestnanec=s.id_zamestnanec AND s.id_akce=".$row['id_akce'] ." AND s.id_zamestnanec != ". $this->user->id;
                $rr = @mysql_query($q);
                if(mysql_num_rows($rr) > 0)
                {
                    echo "<b>Další účastníci</b>";
                    echo "<table style=\"margin: auto\">";
                    while($row2 = mysql_fetch_array($rr, MYSQL_ASSOC))
                        echo "<tr><td>" . $row2['jmeno'] ." ". $row2['prijmeni'] . "</td></tr>";
                    echo "</table>";
                    echo "<br />";
                }
                echo "<b>Podrobnosti</b>";
                echo "<br/>";
                if($row['podrobnosti'])
                    echo $row['podrobnosti'];
                else
                    echo "<i>Bez komentáře</i>";
                echo "<br/><br />";
                echo "<i>Vložil(a) ";
                $q = "SELECT role, jmeno, prijmeni FROM zamestnanec WHERE id_zamestnanec=".$row['vlozil'];
                $rr = @mysql_query($q);
                if($row2 = mysql_fetch_array($rr, MYSQL_ASSOC))
                    echo $row2['jmeno'] ." ". $row2['prijmeni']; 
                echo " dne ". mDate(strtotime($row['vlozeno_dne'])) ." v ".mDatetimeToTime($row['vlozeno_dne']).".</i><br />";
                echo "<form action=\"?page=newEvents&id=".$row["id_akce"]."\" method=\"POST\">";
                echo "<br />";
                if(isset($row2['role']))
                    echo '<input type="hidden" name="role" value="'.$row2['role'].'" />';
                echo "<input type=\"submit\" name=\"check\" value=\"Přečteno\" />";
                echo "<br />";
                echo "<br />";
                echo "</form>";
                echo "</div>";
                echo "<br/>";
            }
        }
        else
            echo "Nemáte žádné nové akce.<br />";
    }
}
?>
