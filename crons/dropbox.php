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
echo json_encode($dropbox->getSpaceUsage());
