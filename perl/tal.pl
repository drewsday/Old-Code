#!/usr/bin/perl

$count = 99;

while ($count < 201 ) {

 `wget www.wbez.org/ta/$count\.rm\n`;

$count = $count + 1;

}

