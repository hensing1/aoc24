#! /usr/bin/php
<?php

function find_mults($input) {
	$pattern = '/mul\((\d{1,3}),(\d{1,3})\)/';
	preg_match_all($pattern, $input, $matches);
	return $matches;
}

$f = fopen( 'php://stdin', 'r' );

$result = 0;
while( $line = fgets( $f ) ) {
	$matches = find_mults($line);
	for ($i = 0; $i < count($matches[0]); $i++) {
		$result += $matches[1][$i] * $matches[2][$i];
	}
}
echo $result . PHP_EOL;

fclose( $f );
?>
