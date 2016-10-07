<?php
//  ----------------------------------------------------------------------------
// ------------------------ Подключение к MySQL БД -----------------------------
$host = "localhost";       
$user = "root";             
$password = "vecrek";                 
$db = "TaskDB";         
if (!$link = mysql_connect ($host, $user, $password))
  { 
   echo "Не могу соедениться с MySQL"; 
   die; 
  } 
if (!mysql_select_db($db, $link))
  { 
   echo "Не могу выбрать базу $db. Ошибка: ".mysql_error($link); 
   die;
  } 
// -----------------------------------------------------------------------------
// ----------------------------------- МЕНЮ h4 ---------------------------------
function status($status)
  {
	 if ($status == "важно")
     {
      $text = "<font color='red'>".$status."</font>";
     }
	 elseif ($status == "в процессе")
     {
      $text = "<font color='blue'>".$status."</font>";
     }    
    else
     {
      $text = $status;
     } 
 
   return $text;
  }
// -----------------------------------------------------------------------------
//----------------------------- Пункт left_meny --------------------------------
function menu_item($url='#', $name='пункт меню', $img = "img/menu.gif")
  {
	 $text = "<tr valign='baseline'>\n
           <td style='padding-right:5px;' width='26'><img src='".$img."' height='30'></td>
				   <td width='100%' valign='middle'><a href='".$url."' class='menu'>".$name."</a></td>\n			
           </tr>\n";
   return $text;
  }
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
function GetUserIP()
  {
   if (isset($_SERVER['HTTP_CLIENT_IP']))
     { 
      $ip = $_SERVER['HTTP_CLIENT_IP']; 
     }
   elseif (isset($_SERVER['HTTP_X_FORWARDED_FOR']))
     { 
      $ip = $_SERVER['HTTP_X_FORWARDED_FOR']; 
     }
   else
     { 
      $ip = $_SERVER['REMOTE_ADDR']; 
     }
  return($ip);
 } 
//------------------------------------------------------------------------------
//----------------------------- HTML страница ----------------------------------
function html_begin($title,$zagolovok,$ip=false)
  {
   //print $ip;
   $query = "SELECT * FROM `oai_users` WHERE `ip`='".$ip."'";
	 $result = mysql_query_or_die($query);
	 $row = mysql_fetch_assoc($result);
	 $num = mysql_num_rows($result);
	 $administrator=0;
   if ($num>0)
	   {
      if ($row['admin']==1)
        {
         $administrator=1;
        }
      elseif ($row['admin']==2)
        {
         $administrator=2;
        }
     }
   //print $administrator; <script type='text/javascript' src='BubbleTooltips.js'></script>
   //
   print "<html>
          <head>
          <meta http-equiv='Content-Type' content='text/html; charset=windows-1251' />
          <title>".$title."</title>
          <link rel='icon' href='./favicon.ico' type='image/x-icon'/>
          <link href='css/style.css' rel='stylesheet' type='text/css'>
          <link href='css/select.css' rel='stylesheet' type='text/css'>
          <script language='JavaScript' src='./calendar.js'></script>
          
          </head>
          <body>
          <table width='1128' border='0' align='center' cellpadding='0' cellspacing='0'>
          <tr>";
          /*print "<td><div style='position:absolute; margin-top:12px; margin-left:84px;'><img src='images/logo.gif' alt='' width='65' height='65'></div>
          <div class='company_name'>ООО \"Алмаз\"</div>
          <img src='images/p1.jpg' alt='' width='1128' height='135'></td>";*/
          print "<td>
          <img src='images/p4.jpg' alt='' width='1128' height='135'></td>";  
          /*print "<td>
          <img src='images/p3.gif' alt='' width='1128' height='135'></td>";  */                

    print"</tr>
          <tr>
    <td background='images/mbg.gif'><table width='100%' border='0' cellspacing='0' cellpadding='0'>
      <tr>
        <td width='6'><img src='images/ml.gif' alt='' width='6' height='38'></td>
        <td><table border='0' align='center' cellpadding='0' cellspacing='0'>
         
          <tr>
            <td class='menu'><a href='./index.php'>Home</a></td>
            <td width='5'><img src='images/ms.gif' alt='' width='5' height='38'></td>
            <td class='menu'><a href='./internet.php'>Internet</a></td>";
     if ($administrator==1 or $administrator==2)
       {
        print "<td width='5'><img src='images/ms.gif' alt='' width='5' height='38'></td>
               <td class='menu'><a href='./oai.php'>ОАиИ</a></td>";
       }
     
     print "<td width='5'><img src='images/ms.gif' alt='' width='5' height='38'></td>
            <td class='menu'><a href='#'>бла</a></td>
            <td width='5'><img src='images/ms.gif' alt='' width='5' height='38'></td>
            <td class='menu'><a href='#'>бла</a></td>
            <td width='5'><img src='images/ms.gif' alt='' width='5' height='38'></td>
            <td class='menu'><a href='#'>бла</a></td>
          </tr>
         
        </table></td>
        <td width='6'><img src='images/mr.gif' alt='' width='6' height='38'></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td class='cbg'><table width='100%' border='0' cellspacing='0' cellpadding='0'>
      
      <tr>";
       
       if ($_SERVER['PHP_SELF']!="/almaz/oai.php")
         {
          print "<td width='203' valign='top'>
        <div class='lmenu'><div class='l_title'>Новости</div><p>26.11.10 Начало разработки внутреннего сайта предприятия</p>
          <p>бла бла бла</p>
          <img src='images/lbot.gif' alt=''></div></td>
          
        ";
        }
/*print " <div class='lmenu'><div class='l_title'>Продукция</div><div id='anvsoft-photo-flash-maker'>
<script type='text/javascript' src='./flash/swfobject.js'></script>
  <script type='text/javascript'>
    var so = new SWFObject('./flash/sl.swf','player','240','195','9');
    so.addVariable('xml_path','./flash/slides.xml');
    so.addParam('quality','high');
    so.addParam('allowfullscreen','true');
    so.addParam('wmode','transparent');
    so.addParam('allowscriptaccess','always');
    so.addParam('_flashcreator','http://www.photo-flash-maker.com');
    so.addParam('_flashhost','http://www.go2album.com');
    so.write('anvsoft-photo-flash-maker');
  </script>
</div>";  */       
         
         //<img src='images/lbot.gif' alt=''></div></td>
                    
          print "<td class='body_txt' align='center'><h1>".$zagolovok."</h1>
";
  }
//------------------------------------------------------------------------------
//---------------------------- конец HTML страницы -----------------------------
function html_end($bottom=false,$menu=false,$ip=false) 
  {
	 print "</td>
      </tr>

    </table></td>
  </tr>
  <tr>
    <td><img src='images/cbot.gif' alt='' width='1128' height='5'></td>
  </tr>
  <tr>
  
    <td class='bottom_menu'><a href='./index.php'>Home</a>  |  <a href='./internet.php'>Internet</a>  |  <a href='#'>бла</a>  |  <a href='#'>бла</a>  |  <a href='#'>бла</a>  |  <a href='#'>бла</a></td>

  </tr>
  <tr>
    <td class='bottom_addr'>&copy; 2010 OOO Almaz</td>
  </tr>
</table>
</body>
</html>";
   
    
     mysql_close(); 
   } 
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function getmicrotime() 
  {
	 list($usec, $sec) = explode(" ", microtime());
	 return ((float)$usec + (float)$sec);
  }
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function mysql_query_or_die($query)
  {
	 $res = mysql_query($query);
	 if(!$res)
		 die ("Ошибка БД в запросе '$query'.<br>MySQL пишет: ". mysql_error() ."<BR> <b>Ничего не сделано!</b><BR><BR>"); 
	 return $res;
  }
//---------- возвращает значение поля $field из $table, где id = $id -----------
//------------------------------------------------------------------------------
function getSomeById($table, $field, $id ) 
  { 
	 $query = "SELECT `$field` FROM `$table` WHERE id = $id";
	 $result = @mysql_query($query);
	 if($row = @mysql_fetch_assoc($result))
		 return $row[$field];
  }
// ------------------------------------------------------------------------------------------------------------
// ----------------------------------------------- Текст красного цвета ---------------------------------------
function red_text($text){
$red_text="<span style='color:red;'>".$text."</span>";
return $red_text;
}
// ------------------------------------------------------------------------------------------------------------

// ----------------------------------------------- Текст зеленого цвета ---------------------------------------
function green_text($text){
$green_text="<span style='color:green;'>".$text."</span>";
return $green_text;
}
// ------------------------------------------------------------------------------------------------------------
// ----------------------------------------------- Текст белого цвета -----------------------------------------
function white_text($text){
$white_text="<span style='color:white;'>".$text."</span>";
return $white_text;
}
// ------------------------------------------------------------------------------------------------------------
// ----------------------------------------------- Текст orange цвета -----------------------------------------
function orange_text($text){
$white_text="<span style='color:orange;'>".$text."</span>";
return $white_text;
}
// ------------------------------------------------------------------------------------------------------------
// ----------------------------------------------- Текст серого цвета -----------------------------------------
function grey_text($text){
$white_text="<span style='color:#909090;'>".$text."</span>";
return $white_text;
}
// ------------------------------------------------------------------------------------------------------------
// ----------------------------------------------- Текст синего цвета -----------------------------------------
function blue_text($text){
$white_text="<span style='color:blue;'>".$text."</span>";
return $white_text;
}
// ------------------------------------------------------------------------------------------------------------

// -------------------------------------- Преобразование даты платежа -----------------------------------------
function convert_date($engdate){
  $month_ip = array("январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь");
  //$month_rp = array("января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря");
  $month_rp = array("янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек");
  global $s_y, $s_m, $s_o, $s_p;
  
	if ($engdate == "0000-00-00" OR !$engdate) return "&nbsp;";
	list($year, $month, $day) = explode("-", $engdate);
	$rusdate = ((int)$day);
  $rusdate .= "<a href='".$PHP_SELF."?list=3&s_y=".$s_y."&s_m=".$month."&s_o=".$s_o."&s_p=".$s_p."' title='Выбрать только за ".$month_rp[(int)$month-1]." месяц' style='text-decoration:none;'> ".$month_rp[(int)$month-1]."</a>";
  $rusdate .= "<a href='?list=3&s_y=".$year."&s_m=".$s_m."&s_o=".$s_o."&s_p=".$s_p."' title='Выбрать только за ".$title." год' style='text-decoration:none;'> ".$year."</a>";
  /*
  if ($month=='01' or $month=='02' or $month=='03')
    $kvartal="1";
  if ($month=='04' or $month=='05' or $month=='06')
    $kvartal="2";
  if ($month=='07' or $month=='08' or $month=='09')
    $kvartal="3";
  if ($month=='10' or $month=='11' or $month=='12')
    $kvartal="4";
        
  $rusdate .=" (";
	if ($session['vibor_sig_k']=='')
     $rusdate .= "<a href='".$PHP_SELF."?vibor_sig_k=".$kvartal."' title='Выбрать только за ".$kvartal." квартал' style='text-decoration:none;'>".$kvartal."</a>";
  else
     $rusdate .= "<a href='".$PHP_SELF."?vibor_sig_k=' title='Сброс выборки по кварталу' style='text-decoration:none;'>".$kvartal."</a>";
  
  $rusdate .=")";
  */
	return $rusdate;
} 
// ------------------------------------------------------------------------------------------------------------
function date_minus_month($engdate){
	if ($engdate == "0000-00" OR !$engdate) return "&nbsp;";
	list($year, $month) = explode("-", $engdate);
$month=$month-1;
$time=mktime(0,0,0,$month,1,$year);
$newdate=date("Y-m", $time);
	return $newdate;
}
// -------------------------------------- удаление мантис (копеек) --------------------------------------------
function del_mantis($sum)
{
	if ($sum == 0) return "&nbsp;";
	$dig = 2; 
	if (floor($sum) == $sum) $dig = 0;
	return number_format($sum, $dig, ',', ' ');
} 
// -----------------------------------------------------------------------------
function normal_size($size) 
  {
   if ($size>0)
     {
      $kb = 1024;         // Kilobyte
      $mb = 1024 * $kb;   // Megabyte
      $gb = 1024 * $mb;   // Gigabyte
      $tb = 1024 * $gb;   // Terabyte
      if($size < $kb) 
        {
         return $size." B";
        }
      else 
        {
         if($size < $mb) 
           {
            return round($size/$kb,2)." KB";
           }
         else
           {
            if($size < $gb) 
              {
               return round($size/$mb,2)." MB";
              }
            else 
              {
               if($size < $tb) 
                 {
                  return round($size/$gb,2)." GB";
                 }
               else 
                 {
                  return round($size/$tb,2)." TB";
                 }
              }
           }
        }
     }
   else
     {
      return "-";
     }  
}
//------------------------------------------------------------------------------
// -----------------------------------------------------------------------------
function normal_size_2($size) 
  {
   if ($size>0)
     {
      $kb = 1024;         // Kilobyte
      $mb = 1024 * $kb;   // Megabyte
      $gb = 1024 * $mb;   // Gigabyte
      $tb = 1024 * $gb;   // Terabyte
      if($size < $kb) 
        {
         return $size." B";
        }
      else 
        {
         if($size < $mb) 
           {
            return round($size/$kb,1)." KB";
           }
         else
           {
            if($size < $gb) 
              {
               return round($size/$mb,1)." MB";
              }
            else 
              {
               if($size < $tb) 
                 {
                  return round($size/$gb,1)." GB";
                 }
               else 
                 {
                  return round($size/$tb,1)." TB";
                 }
              }
           }
        }
     }
   else
     {
      return "-";
     }  
}
//------------------------------------------------------------------------------
function max_trafik_month($month,$year,$user_id=false,$otdel=false)
  {
   $unix_time = mktime (1, 1, 1, $month, 1, $year);
   $count_month = date('t', $unix_time); 
   for($j=1;$j<=$count_month;$j++) 
     {
      $unix_time_ = mktime (1, 1, 1, $month, $j, $year);
      $date = date("Y-m-d", $unix_time_);
      if ($user_id == false and $otdel == false)
        $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE `date`='".$date."' ";
      elseif ($user_id == false and $otdel != false)
        {
         $where = "";
         $query_ = "SELECT `id` FROM `users` WHERE `otdel`='".$otdel."' "; 
         $result_ = mysql_query_or_die($query_);
         while ($row_ = mysql_fetch_assoc($result_))
	         {
            if ($where == "")
              $where .= "AND ( `user_id`='".$row_['id']."' ";
            else
              $where .= "OR `user_id`='".$row_['id']."' ";  
           }
         $where .= ")";        
         $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE `date`='".$date."' ".$where." ";
        }
      else
        $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE `date`='".$date."' AND `user_id`='".$user_id."' ";        
	    $result = mysql_query_or_die($query);
	    $row = mysql_fetch_assoc($result);
      if ($row['sum_size'])$sum_size[$j]=$row['sum_size'];
      else $sum_size[$j]=0;
     }
   $max=normal_size(max($sum_size));
   return $max;
  }
//------------------------------------------------------------------------------
function all_trafik_month($month,$year,$user_id=false,$otdel=false)
  {
   if ($user_id == false and $otdel == false)
     $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE MONTH(`date`)='".$month."' AND YEAR(`date`)='".$year."' ";
   elseif ($user_id == false and $otdel != false)
     {
      $where = "";
      $query_ = "SELECT `id` FROM `users` WHERE `otdel`='".$otdel."' "; 
      $result_ = mysql_query_or_die($query_);
       while ($row_ = mysql_fetch_assoc($result_))
	     {
         if ($where == "")
           $where .= "AND ( `user_id`='".$row_['id']."' ";
         else
           $where .= "OR `user_id`='".$row_['id']."' ";  
       }
      $where .= ")";
      $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE MONTH(`date`)='".$month."' AND YEAR(`date`)='".$year."' ".$where." ";
     }
   else
     $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE MONTH(`date`)='".$month."' AND YEAR(`date`)='".$year."' AND `user_id`='".$user_id."' ";        
	 $result = mysql_query_or_die($query);
	 $row = mysql_fetch_assoc($result);
   return normal_size($row['sum_size']);
   //return $query;
  }
//------------------------------------------------------------------------------
function name_user($user_id)
  {
   $user = getsomebyid("users", "user", $user_id);
   list($f, $i, $o) = explode(" ", $user);
   $user = $f;
   return $user;
  }
//------------------------------------------------------------------------------
function max_trafik_year($month,$year,$user_id=false,$otdel=false)
  {
   $unix_time[1] = mktime (1, 1, 1, $month, 1, $year);
   for($j=2;$j<=12;$j++) 
     {
      $unix_time[$j] = mktime (1, 1, 1, $month-$j+1, 1, $year);
     }
   for($j=1;$j<=12;$j++) 
     {
      $month_ = date("m", $unix_time[$j]);
      $year_ = date("Y", $unix_time[$j]);
      if ($user_id == false and $otdel == false)
        $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE MONTH(`date`)='".$month_."' AND YEAR(`date`)='".$year_."' ";
      elseif ($user_id == false and $otdel != false)
        {
         $where = "";
         $query_ = "SELECT `id` FROM `users` WHERE `otdel`='".$otdel."' "; 
         $result_ = mysql_query_or_die($query_);
         while ($row_ = mysql_fetch_assoc($result_))
	         {
            if ($where == "")
              $where .= "AND ( `user_id`='".$row_['id']."' ";
            else
              $where .= "OR `user_id`='".$row_['id']."' ";  
           }
         $where .= ")";        
         $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE MONTH(`date`)='".$month_."' AND YEAR(`date`)='".$year_."' ".$where." ";
        }
      else
        $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE MONTH(`date`)='".$month_."' AND YEAR(`date`)='".$year_."' AND `user_id`='".$user_id."' ";        
	    $result = mysql_query_or_die($query);
	    $row = mysql_fetch_assoc($result);
      if ($row['sum_size'])$sum_size[$j]=$row['sum_size'];
      else $sum_size[$j]=0;
     }
   $max=normal_size(max($sum_size));
   return $max;
  }
//------------------------------------------------------------------------------
function all_trafik_year($month,$year,$user_id=false,$otdel=false)
  {
   $unix_time_end = date("Y-m-d" , mktime (1, 1, 1, $month+1, 1, $year));
   $unix_time_first = date("Y-m-d" , mktime (1, 1, 1, $month-11, 1, $year));
   if ($user_id == false and $otdel == false)
     $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE `date`>='".$unix_time_first."' AND `date`<='".$unix_time_end."' ";
   elseif ($user_id == false and $otdel != false)
     {
      $where = "";
      $query_ = "SELECT `id` FROM `users` WHERE `otdel`='".$otdel."' "; 
      $result_ = mysql_query_or_die($query_);
       while ($row_ = mysql_fetch_assoc($result_))
	     {
         if ($where == "")
           $where .= "AND ( `user_id`='".$row_['id']."' ";
         else
           $where .= "OR `user_id`='".$row_['id']."' ";  
       }
      $where .= ")";
      $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE `date`>='".$unix_time_first."' AND `date`<='".$unix_time_end."' ".$where." ";
     }
   else
     $query = "SELECT SUM(`size`) as `sum_size` FROM `squid_log_summ` WHERE `date`>='".$unix_time_first."' AND `date`<='".$unix_time_end."' AND `user_id`='".$user_id."' ";        
	 $result = mysql_query_or_die($query);
	 $row = mysql_fetch_assoc($result);
   return normal_size($row['sum_size']);
   //return $query;
  }
//------------------------------------------------------------------------------  
// -----------------------------------------------------------------------------
function hit_normal_size($size,$skobki) 
  {
   if ($size>0)
     {
      $kb = 1024;         // Kilobyte
      $mb = 1024 * $kb;   // Megabyte
      $gb = 1024 * $mb;   // Gigabyte
      $tb = 1024 * $gb;   // Terabyte
      if($size < $kb) 
        {
         if ($skobki==1)
           return blue_text("(".$size." B)");
         else
           return blue_text($size." B");
        }
      else 
        {
         if($size < $mb) 
           {
            if ($skobki==1)
              return blue_text("(".round($size/$kb,2)." KB)");
            else
              return blue_text(round($size/$kb,2)." KB");
           }
         else
           {
            if($size < $gb) 
              {
               if ($skobki==1)
                 return blue_text("(".round($size/$mb,2)." MB)");
               else
                 return blue_text(round($size/$mb,2)." MB");
              }
            else 
              {
               if($size < $tb) 
                 {
                  if ($skobki==1)
                    return blue_text("(".round($size/$gb,2)." GB)");
                  else
                    return blue_text(round($size/$gb,2)." GB");                 
                 }
               else 
                 {
                  if ($skobki==1)
                    return blue_text("(".round($size/$tb,2)." TB)");
                  else
                    return blue_text(round($size/$tb,2)." TB");                  
                 }
              }
           }
        }
     }
   else
     {
      return blue_text("-");
     }  
}
//------------------------------------------------------------------------------
function dateDiff($startDate, $endDate)
	{
	    $startArry = date_parse($startDate);
	    $endArry = date_parse($endDate);
	 

	    $start_date = gregoriantojd($startArry["month"], $startArry["day"], $startArry["year"]);
	    $end_date = gregoriantojd($endArry["month"], $endArry["day"], $endArry["year"]);
	 
	    // Return difference
	    return round(($end_date - $start_date), 0);
	}
//------------------------------------------------------------------------------
function convert_date2($engdate){
  $month_ip = array("январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь");
  $month_rp = array("января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря");
  
	if ($engdate == "0000-00-00" OR !$engdate) return "&nbsp;";
	list($year, $month, $day) = explode("-", $engdate);
	$rusdate = ((int)$day);
  $rusdate .= " ".$month_rp[(int)$month-1]." ";
  $rusdate .= $year;
  /*
  if ($month=='01' or $month=='02' or $month=='03')
    $kvartal="1";
  if ($month=='04' or $month=='05' or $month=='06')
    $kvartal="2";
  if ($month=='07' or $month=='08' or $month=='09')
    $kvartal="3";
  if ($month=='10' or $month=='11' or $month=='12')
    $kvartal="4";
        
  $rusdate .=" (";
	if ($session['vibor_sig_k']=='')
     $rusdate .= "<a href='".$PHP_SELF."?vibor_sig_k=".$kvartal."' title='Выбрать только за ".$kvartal." квартал' style='text-decoration:none;'>".$kvartal."</a>";
  else
     $rusdate .= "<a href='".$PHP_SELF."?vibor_sig_k=' title='Сброс выборки по кварталу' style='text-decoration:none;'>".$kvartal."</a>";
  
  $rusdate .=")";
  */
	return $rusdate;
} 
//------------------------------------------------------------------------------
function convert_date3($engdate){
  $month_ip = array("январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь");
  $month_rp = array("января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря");
  
	if ($engdate == "0000-00-00" OR !$engdate) return "&nbsp;";
	list($year, $month, $day) = explode("-", $engdate);
  $rusdate = $month_ip[(int)$month-1]." ";
  $rusdate .= $year;
	return $rusdate;
} 
//------------------------------------------------------------------------------
function vaznost($vazn){
   if ($vazn==1)
     $vazn_="не срочно";
   if ($vazn==2) 
     $vazn_="срочно";
   if ($vazn==3)
     $vazn_="ЖОПА ( . )";          
   return $vazn_;
  } 
//------------------------------------------------------------------------------
function fio($fio){
list($f, $i, $o) = explode(" ", $fio);
return $f;
}
//------------------------------------------------------------------------------
function stadiya($stad){
   if ($stad==1)
     $stad_="в работе";
   if ($stad==2) 
     $stad_="тест";
   if ($stad==3)
     $stad_="выполненно";          
   return $stad_;
  } 
//------------------------------------------------------------------------------
function select($znach1,$znach2){
   if ($znach1==$znach2)
      return "selected";
   else
      return "";
  } 
//------------------------------------------------------------------------------

?>
