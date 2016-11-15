<?php
/**
 * File:    funcitons.php
 * Authors: Petr Dvoracek  <xdvora0n@stud.fit.vutbr.cz>
 *          Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Subject: IIS - Manager calendar
 * Created: Autumn 2012
 *
 * License: Muzes kreslit, muzes psat ale listy netrhat
 *
 *  <'##)~
 *   ^ ^
 */



/**
 * What day is today?
 * @return string contains today date.
 */
function mToday()
{
    return "Dnes je: ".date("j").". ".date("M")." ".date("Y");
}




/**
 * What month is today?
 * @return string contains the month.
 */
function mMonth($date)
{
    $mesice = array ("Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec");
    return $mesice[date("n", $date)-1].date(" Y", $date);
}



/**
 * What day was that day?
 * @param $date     unix timestamp
 * @return          string contains date
 */
function mDate($date)
{
    $mesiceSklon = array ("ledna", "února", "března", "dubna", "května", "června", "července", "srpna", "září", "října", "listopadu", "prosince");
    return date("j. ", $date).$mesiceSklon[date("n", $date)-1].date(" Y", $date);
}



/**
 * Give first day of month
 * @param $date     unix timestamp
 * @return          unix timestamp 
 */
function mFirstDayofMonth($date)
{
    return $date - DAY * (date("j", $date) - 1);
}



/**
 * Give last day of month
 * @param $date     unix timestamp
 * @return          unix timestamp 
 */
function mLastDayMonth($date)
{
    return $date - DAY * (date("j", $date) - 1);
}



/**
 * parse unix timestamp to format YY-mm-dd
 */
function mUnixtimeToDate($utime)
{
    return date("Y-m-d", $utime);
}



/**
 * Cutting the day, same efekt as in sampling signal 
 * @param $src  YYYY-MM-DD HH:MM:SS format
 * @param $date timestamp 
 * @retuern     sampled date format
 */
function mCutDay($src, $date)
{
    $a = explode(" ", $src);
    $b = date("Y-m-d", $date);
    if($a[0] > $b)
        $result = "23:59:00";
    else if($a[0] < $b)
        $result = "00:00:00";
    else
        $result = $a[1];
    return $b ." ". $result; 
}



/**
 * Gives sum of minutes for the day
 * @param $begin    Y-m-d format of day
 * @param $end      Y-m-d format of day
 * @return          minutes during begin and end 
 */
function mSumMinutes($begin, $end, $date)
{
    $begin = strtotime(mCutDay($begin, $date));
    $end = strtotime(mCutDay($end, $date));
    return round(abs($end - $begin)/60);
}


/**
 * Converts datetime to just time
 * @param $date     Y-m-d H:M:S format of day
 * @return          H:M
 */
function mDatetimeToTime($date)
{
    $tmp = explode(" ", $date);
    if(isset($tmp[1]))
    {
        $tmp = explode(":", $tmp[1]);
        if(isset($tmp[1], $tmp[1]))
            return $tmp[0].":".$tmp[1];
    }
    return false;
}



/**
 * Converts datetime to just date
 * @param $date     Y-m-d H:M:S format of date
 * @return          d.m.Y
 */
function mDatetimeToDateCs($date)
{
    $tmp = explode(" ", $date);
    if(isset($tmp[0]))
    {
        $tmp = explode("-", $tmp[0]);
        if(isset($tmp[0], $tmp[1], $tmp[2]))
            return $tmp[2].".".$tmp[1].".".$tmp[0];
        else
            return false;
    }
    return false;
}



/**
 * Check format of date.
 * @param   string  YYYY-MM-DD HH:MM:SS
 * @return  boolean
 */
function mCheckDatetime($date)
{
    if(! preg_match('/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) ([0-1][0-9]|2[0-4]):[0-5][0-9]:[0-5][0-9]$/', $date))
        return false;
    else
        return true;
}

?>
