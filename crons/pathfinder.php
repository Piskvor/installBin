<?php

use Pathfinder\Pathfinder;

# set defaults, perhaps changed in .config.php?
$pushjet_secret = '';
$PUSHJET = '/usr/local/bin/pushjet-cli';
$demo_data = null;
$config_defaults = array(
    'key' => null, // filled in pathfinder.config.php
    'language' => 'cs_CZ',
    'mode' => 'driving',
    'departure_time' => 'now',
    'traffic_model' => 'pessimistic',
);
$auto_notify = true;

require_once __DIR__.DIRECTORY_SEPARATOR.'pathfinder.config.php';
require_once __DIR__.DIRECTORY_SEPARATOR.'Pathfinder.class.php';

if (PHP_SAPI === 'cli') {
    $selected_config = @$argv[1];
} else {
    $selected_config = @$_REQUEST['route'];
    if (!$selected_config) {
        $selected_config = @$_SERVER['QUERY_STRING'];
    }
    $format = @$_REQUEST['format'];
    if (!$format) {
        $format = @$_SERVER['HTTP_ACCEPT'];
    }
    if (!$format) {
        $format = 'text/html';
    }

    if (isset($_REQUEST['notify'])) {
        $auto_notify = (bool)$_REQUEST['notify'];
    }

    if ($format === 'application/json') {
        function formatter($result)
        {
            unset($result['command']);
            header('Content-Type: application/json');

            return json_encode($result);
        }
    } elseif ($format === 'text/plain') {
        function formatter($result)
        {
            return $result['text'];
        }
    } else {
        function formatter($result)
        {
            return '<a href="'.$result['url'].'">'.$result['text'].'</a>';
        }
    }
}

if (!function_exists('formatter')) {
    function formatter($result)
    {
        return $result['text']."\n";
    }
}

$pf = new Pathfinder(
    $config_defaults,
    array(
        'url' => 'https://maps.googleapis.com/maps/api/directions/json',
        'method' => 'GET',
        'level' => 4,
        'pushjet_secret' => $pushjet_secret,
        'PUSHJET' => $PUSHJET,
        'demo_data' => $demo_data,
    ),
    $auto_notify
);
if (!$pf->find($selected_config)) {
    echo implode("\n", $pf->getErrors())."\n";
    echo "Known configs:\n";
    echo implode(' ', array_keys($pf->getConfigs()));
    echo "\n";
    echo "Usage $argv[0] CONFIG\n";

    return 1;
}

$result = $pf->getResult();

echo formatter($result);
