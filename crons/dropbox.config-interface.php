<?php

interface ProvidesConfigData {
    public function getDropboxClientId();
    public function getDropboxClientSecret();
    public function getDropboxAccessToken();
}
