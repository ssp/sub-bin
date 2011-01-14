<?php
/*
============================================================================================
Filename: 
---------
xml2json_test.php

Description: 
------------
The code in this PHP program is just a test driver that exercises the XML to JSON converter
class. This PHP program reads the contents of a filename passed in the command line and 
converts the XML contents in that file to JSON formatted data.

This program takes a XML filename as a command line argument as shown below:
php -f xml2json_test.php test1.xml

License:
--------
This code is made available free of charge with the rights to use, copy, modify,
merge, publish and distribute. This Software shall be used for Good, not Evil.

First Created on:
-----------------
Oct/04/2006

Last Modified on:
-----------------
Jan/14/2011
adapted by Sven-S. Porst <porst@sub.uni-goettingen.de>
============================================================================================
*/
require_once("xml2json.php");

// Filename from where XML contents are to be read.
$fileList;

// Read the filename from the command line.
if ($argc <= 1) {
	$fileList = array('php://stdin');
} else {
	$fileList = array_slice($argv, 1);
}


foreach ($fileList as $fileName) {
	$xmlStringContents = file_get_contents($fileName); 
	$jsonContents = "";	

	// Convert it to JSON now.
	// xml2json simply takes a String containing XML contents as input.
	error_reporting(E_ERROR);
	$jsonContents = xml2json::transformXmlStringToJson($xmlStringContents);

	if ($argc <= 1) {
		echo($jsonContents);
	}
	else {
		$JSFileName = str_replace('xml', 'js', $fileName);
		$file = fopen($JSFileName, 'w');
		fwrite($file, $jsonContents);
		fclose($file);
		print 'converted ' . $fileName . " to " . $JSFileName . "\n";
	}
}
?>
