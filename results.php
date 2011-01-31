<html><body>

<?php

  $user="morris";
  $password="rooski";
  $database="ninjabunny_org";

  mysql_connect(localhost,$user,$password);
  @mysql_select_db($database) or die( "Unable to select database");

  $sql = "SELECT * FROM sports";
  $result = mysql_query($sql2);

$i = 0;
$j = 0;
   
$event= 0;     
$type     = 0;
$speed     = 0;
$strength     = 0;
$strategy     = 0;
$run     = 0;
$jump     = 0;
$ball     = 0;
$contact     = 0;
$endurance     = 0;
$sweat     = 0;
$heart     = 0;
$stick     = 0;
$race     = 0;
$vehicle     = 0;
$skill     = 0;
$time     = 0;
$stadium     = 0;
$cheer     = 0;
$league     = 0;
$tv     = 0;
$ref     = 0;
$judges     = 0;
$music     = 0;
$sport     = 0;
$ip= 0;
$location= 0;


// printing HTML result

        while($line = mysql_fetch_row($result2)){
              if ($line[24]) {          
			$strength = $strength + $line[3];
			$strategy = $strategy + $line[4];
			}
		$sport = $sport + $line[24];
                $j = $j + 1;
        }

$percent_strength  = 100 * $stregth / $sport;
$percent_strat = 100 * $strategy / $sport;


print "<p>To date, $percent_stregth % of all sports require strength 
and $percent_strat % require strategy.<p>";


