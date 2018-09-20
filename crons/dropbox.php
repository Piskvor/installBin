<?php

require_once __DIR__ . '/dropbox.config.php';

$configData = new ConfigData();

require_once __DIR__ . '/vendor/autoload.php';

use Kunnu\Dropbox\Dropbox;
use Kunnu\Dropbox\DropboxApp;

$dropboxApp = new DropboxApp(
    $configData->getDropboxClientId(),
    $configData->getDropboxClientSecret(),
    $configData->getDropboxAccessToken()
);
$dropbox = new Dropbox($dropboxApp);

header('Content-Type: application/json');
$usage = $dropbox->getSpaceUsage();
$usedGb = round($usage['used'] / 1024 / 1024 / 1024, 2);
$freeGb = round(($usage['allocation']['allocated'] - $usage['used'])  / 1024 / 1024 / 1024, 2);
$availableGb = round($usage['allocation']['allocated']  / 1024 / 1024 / 1024, 2);
$percent = round($usage['used'] / $usage['allocation']['allocated'] * 100, 1);
echo json_encode(
    array(
        'free' => $freeGb,
        'used' => $usedGb,
        'total' => $availableGb,
        'percent' => $percent
    )
);
