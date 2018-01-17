#!/usr/bin/php
<?php

$url = 'https://maps.googleapis.com/maps/api/directions/json';
$method = 'GET';

$level = 4;
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
require_once __DIR__ . DIRECTORY_SEPARATOR . 'pathfinder.config.php';

$configs = array(
    'JSw' => array( // Jizni spojka to west
        'origin' => 'place_id:ChIJ787quzuSC0cRD_7TdV9wCG8', // bus Bachova
        'destination' => 'place_id:ChIJa3qYGECUC0cRbz9FDbO25cY', // Shell Strakonicka Lihovar
        'waypoints' => 'via:place_id:ChIJy1GHhMGTC0cR9g9n5hexXAQ', // Shell JS u Zapa Betonu
        'x-time_expected' => 960 // travel time expected
    ),
);
$configs['JSe'] = $configs['JSw']; // Jizni spojka to east
$configs['JSe']['origin'] = $configs['JSw']['destination'];
$configs['JSe']['destination'] = 'place_id:ChIJ7TjLf8iTC0cR7-Q5xiHHEJ0'; // OBI
unset($configs['JSe']['waypoints']);

$selected_config = @$argv[1];
if ($selected_config && isset($configs[$selected_config])) {
    $config = $config_defaults + $configs[$selected_config];
} else {
    echo "Unknown config, please select:\n";
    echo implode(" ",array_keys($configs));
    echo "\n";
    echo "Usage $argv[0] CONFIG\n";
    return 1;
}

if (!$demo_data) {
    if ($method == 'POST') {
        $data_string = json_encode($config);

        $ch = curl_init($url);

        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt(
            $ch,
            CURLOPT_HTTPHEADER,
            array(
                'Content-Type: application/json',
                'Content-Length: '.strlen($data_string)
            )
        );
    } else {
        $params = '';
        foreach ($config as $key => $value) {
            if (strpos($key,'x-') === 0) {
                continue;
            }
            $params .= $key.'='.urlencode($value).'&';
        }

        $params = trim($params, '&');
        $ch = curl_init($url.'?'.$params);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    }

    $http_result = curl_exec($ch);
    $result = json_decode($http_result, true);
} else {
    $result = $demo_data;
}

//var_export($result);exit;

if ($result['status'] !== 'OK') {
    echo $result['status'];
    return 2;
} else if (count($result['routes']) < 1) {
    echo "No routes!";
    return 3;
}

$filtered = array(

);

foreach($result['routes'] as $route) {
    $route_filtered = array(
        'via' => array(),
        'time' => 0
    );
    $route_filtered['polyline'] = $route['overview_polyline'];
    $route_filtered['via'][] = $route['summary'];
    $route_filtered['expected_time'] = $config['x-time_expected'];

    foreach ($route['legs'] as $leg) {
        $route_filtered['via'][] = first_part($leg['end_address']);
        if (isset($leg['duration_in_traffic'])) {
            $time = $leg['duration_in_traffic']['value'];
        } else {
            $time = $leg['duration']['value'];
        }
        $route_filtered['time'] += $time;
    }
    $filtered[] = $route_filtered;
}

foreach ($filtered as $route) {
    $via = implode(', ' , $route['via']);
    $type = 'usual';
    if ($route['expected_time'] < $route['time']) {
        $level = 5;
        $via = '! ' . $via;
        $type = 'HIGH';
    }
    $time = gmdate('H:i', $route['time']) . " min in $type traffic";
    echo "$via $time\n";

    exec("$PUSHJET -s $pushjet_secret -l $level -t " . escapeshellarg($via) . ' -m ' . escapeshellarg($time));// . ' -u ' . escapeshellarg(get_polyline_map($route['polyline'])));
}
exit;

function first_part($address) {
    $address_parts = explode(',' , $address);
    return $address_parts[0];
}
//
//function get_polyline_map($polyline) {
//
//}
