#!/usr/bin/php
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

require_once __DIR__.DIRECTORY_SEPARATOR.'pathfinder.config.php';
require_once __DIR__.DIRECTORY_SEPARATOR.'Pathfinder.class.php';

$selected_config = @$argv[1];

$pf = new Pathfinder(
    $config_defaults,
    array(
        'url' => 'https://maps.googleapis.com/maps/api/directions/json',
        'method' => 'GET',
        'level' => 4,
        'pushjet_secret' => $pushjet_secret,
        'PUSHJET' => $PUSHJET,
        'demo_data' => $demo_data,
    )

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

echo $result['text'] , "\n";
