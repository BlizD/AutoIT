<?php
include("config.php");
if (isset($_REQUEST['user_id'])) $user_id = $_REQUEST['user_id']; else $user_id = "5";
//------------------------------------------------------------------------------
//
//html_begin("��� '�����'","���������� ����",$ip);
/*
$(document).ready(function(){
	
	$('.accordion h3:first').addClass('active');
	$('.accordion span').hide();

	$('.accordion h3').click(function(){
		$(this).next('span').slideToggle('slow')
		.siblings('span:visible').slideUp('slow');
		$(this).toggleClass('active');
		$(this).siblings('h3').removeClass('active');
	});

});

*/
print "<html>
<head>
<meta http-equiv='Content-Type' content='text/html' />
<title>Accordion 1</title>

<script type='text/javascript' src='./js/jquery.min.js'></script>

<script type='text/javascript'>
$(document).ready(function(){
	
	$('.accordion h3:first').addClass('active');
	$('.accordion span').hide();

	$('.accordion h3').click(function(){
		$(this).next('span').slideToggle('slow')
		.siblings('span:visible').slideUp('slow');
		$(this).toggleClass('active');
		$(this).siblings('h3').removeClass('active');
	});

});
</script>

<style type='text/css'>
body {
	margin: 10px auto;
	width: 570px;
	font: 75%/120% Arial, Helvetica, sans-serif;
}
.accordion {
	width: 480px;
	border-bottom: solid 1px #c4c4c4;
}
.accordion h3 {
	background: #e9e7e7 url(img/arrow-square.gif) no-repeat right -51px;
	padding: 7px 17px;
	margin: 0;
	font: bold 120%/100% Arial, Helvetica, sans-serif;
	border: solid 1px #c4c4c4;
	border-bottom: none;
	cursor: pointer;
}
.accordion h3:hover {
	background-color: #e3e2e2;
}
.accordion h3.active {
	background-position: right 5px;
}
.accordion p {
	background: #f7f7f7;
	margin: 0;

	border-left: solid 1px #c4c4c4;
	border-right: solid 1px #c4c4c4;
}
span {
    background: #f7f7f7;
    margin: 0;
    display:none;
    border-left: solid 1px #c4c4c4;
    border-right: solid 1px #c4c4c4;
}
.accordion t1 {
	background: #e9e7e7;
}
.accordion label {
	font: bold 120%/100% Arial, Helvetica, sans-serif;
}
</style>
</head>

<body>

<div class='accordion'>
	<h3>������</h3>
	<span>
	<form name='test' method='post' action='input1.php'>
	<label class='label'>���������:</label><br>
	<input type='checkbox' name='Worker' value='1'>�������� ������� 
  <input type='checkbox' name='Worker' value='2'>������ �����
  <input type='checkbox' name='Worker' value='3'>�������� ������
  <input type='checkbox' name='Worker' value='4'>������ ���������
  <input type='checkbox' name='Worker' value='5'>������� �����
	<input type='checkbox' name='Worker' value='6'>���������� ���������
  <input type='checkbox' name='Worker' value='7'>������� ���������	<br>
	<label class='label'>������:</label>	<br>
  <input type='checkbox' name='Status' value='1'>�� ������
  <input type='checkbox' name='Status' value='2'>� ��������
	<input type='checkbox' name='Status' value='3'>�����
  <input type='checkbox' name='Status' value='4'>���������
  <input type='checkbox' name='Status' value='5'>�������� <br>
	<input type='submit' name='' value='������������'/>					
	</form>	
	</span>";
	
  $query = "SELECT DATE_FORMAT(Tasks.Date,'%d.%m.%Y') AS Date, Tasks.status AS Status,Tasks.Name,Workers.Name AS Worker,Tasks.id_Task,Tasks.id_Worker,Tasks.id_Chief,Chief.Name AS Chief FROM Tasks LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Tasks.id_Worker LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Chief ON Chief.id_Worker=Tasks.id_Chief  WHERE Tasks.id_Worker=".$user_id." AND  Tasks.status<>'���������' AND Tasks.status<>'��������'";
  $result = mysql_query_or_die($query);
  while ($row = mysql_fetch_assoc($result))
    {
     print "<h3>".$row["Date"]." (".status($row["Status"]).") ".$row["Name"]."</h3>"; 
     $query_ = "SELECT DATE_FORMAT(WorkCourse.date,'%d.%m.%Y') AS date,WorkCourse.LineNumber,WorkCourse.Description,Workers.Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task = ".$row['id_Task']." ORDER BY LineNumber";
     //print $query_;
     $result_ = mysql_query_or_die($query_);
    
    
  
     print "<span>
	       <table  border='1' width=480>
         <tr class='t1'>
         <td width='5%'>����</td>
         <td width='70%'>���</td>
         <td width='25%'>�����</td>	 
         </tr>	";
     while ($row_ = mysql_fetch_assoc($result_))
       {	 
        print "<tr>
        <td width='5%'>".$row_['date']."</td>
        <td width='75%'>".$row_['Description']."</td>
        <td width='15%'>".$row_['Author']."</td>	 
        </tr>";
       }
	     print" </table>		
	      </span> ";   
    }
	
 /* print "
  <h3>���������� ��� ��� �������� � �������, ��������� �������� �����</h3>
	<span>
	<table  border='1'
   <tr class='t1'>
   <td width='5%'>����</td>
   <td width='70%'>���</td>
   <td width='25%'>�����</td>	 
   </tr>	
   <tr>
   <td width='5%'>10.10.11</td>
   <td width='75%'>����� �� ����� ��������� ����� ��������, ������ ���������, �� ������� ���������� ������ �� � �� ���� ���</td>
   <td width='15%'>������ �����</td>	 
   </tr>		 
   <tr>
   <td width='5%'>12.10.11</td>
   <td width='75%'>����������� CF ����������, ������ � ���� ������ 1� �����������, ������ ���������</td>
   <td width='15%'>������ �����</td>	 
   </tr>		 	 
	</table>		
	</span>
	<h3>�������� ���������� �� Gemo � Desmos</h3>
	<span>
	<table  border='1'
   <tr class='t1'>
   <td width='5%'>����</td>
   <td width='70%'>���</td>
   <td width='25%'>�����</td>	 
   </tr>	
   <tr>
   <td width='5%'>10.10.11</td>
   <td width='75%'>����� �� ����� ��������� ����� ��������, ������ ���������, �� ������� ���������� ������ �� � �� ���� ���</td>
   <td width='15%'>������ �����</td>	 
   </tr>		 
   <tr>
   <td width='5%'>11.10.11</td>
   <td width='75%'>�������� �����</td>
   <td width='15%'>������ �����</td>	 
   </tr>		 	 	 
   <tr>
   <td width='5%'>12.10.11</td>
   <td width='75%'>����������� CF ����������, ������ � ���� ������ 1� �����������, ������ ���������.</td>
   <td width='15%'>������ �����</td>	 
   </tr>		 	 
	</table>	
	</span>
	<h3>������� ������.</h3>
	<span>
	<table  border='1'
   <tr class='t1'>
   <td width='5%'>����</td>
   <td width='70%'>���</td>
   <td width='25%'>�����</td>	 
   </tr>	
   <tr>
   <td width='5%'>12.10.11</td>
   <td width='75%'>����������� CF ����������, ������ � ���� ������ 1� �����������, ������ ���������.</td>
   <td width='15%'>������ �����</td>	 
   </tr>		 	 
	</table>	
	</span>*/
  print "
</div>

</body>
</html>";
 
?>
