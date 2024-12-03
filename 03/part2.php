#! /usr/bin/php
<?php

function find_mults($input) {
	$pattern = '/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don\'t\(\)/';
	preg_match_all($pattern, $input, $matches);
	return $matches;
}

$f = fopen( 'php://stdin', 'r' );

$result = 0;
$do = true;
while($line = fgets($f)) {
	$matches = find_mults($line);
	for ($i = 0; $i < count($matches[0]); $i++) {
		if ($matches[0][$i] == "do()") {
			$do = true;
			continue;
		}
		if ($matches[0][$i] == "don't()") {
			$do = false;
			continue;
		}
		if ($do) {
			$result += $matches[1][$i] * $matches[2][$i];
		}
	}
}
echo $result . PHP_EOL;

fclose( $f );
?>
