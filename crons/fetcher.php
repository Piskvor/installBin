#!/usr/bin/env php
<?php

use Fetcher\Fetcher;

# .htaccess or php.ini config required:
# php_value output_buffering On
if (ob_get_level() > 0) {
    ob_clean();
}

require_once __DIR__.DIRECTORY_SEPARATOR.'fetcher.config.php';
require_once __DIR__.DIRECTORY_SEPARATOR.'Fetcher.class.php';

$from = new \DateTime('today midnight');
$to = new \DateTime('tomorrow midnight');

if (PHP_SAPI === 'cli') {
    $format = 'text/plain';
} else {
    $format = @$_REQUEST['format'];
    if (!$format) {
        $format = @$_SERVER['HTTP_ACCEPT'];
    }
    if (!$format) {
        $format = 'text/html';
    }
}

$fetcher = new Fetcher(
    $accounts,
    $url_template,
    $parse_balance
);

foreach($fetcher->fetch($from,$to) as $name => $balance) {
    echo "$name: $balance\n";
}


