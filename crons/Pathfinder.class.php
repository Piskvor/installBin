<?php

namespace Pathfinder;

class Pathfinder
{
    const AUTO_NOTIFY = true;
    const NO_AUTO_NOTIFY = false;

    private $auto_notify = true;
    private $notified = false;

    private $result = array();
    private $errors = array();

    private $via_glue = ', ';

    private $configs = array(
        'pb' => array(
            'origin' => 'Praha',
            'destination' => 'Brno',
        ),
        'JSw' => array( // Jizni spojka to west
            'origin' => 'place_id:ChIJ787quzuSC0cRD_7TdV9wCG8', // bus Bachova
            'destination' => 'place_id:ChIJa3qYGECUC0cRbz9FDbO25cY', // Shell Strakonicka Lihovar
            'waypoints' => 'via:place_id:ChIJy1GHhMGTC0cR9g9n5hexXAQ', // Shell JS u Zapa Betonu
            'x-time_expected' => 960, // travel time expected
            'x-summary_expected' => 'Městský Okruh',
            'x-preferred-url' => array(
                'usual' => 'https://www.google.cz/maps/dir/Caf%C3%A9+Z%C3%A1ti%C5%A1%C3%AD,+Ure%C5%A1ova+1757,+148+00+Praha-Kunratice/50.0717146,14.4021649/@50.0459649,14.4205399,13z/data=!3m1!4b1!4m11!4m10!1m5!1m1!1s0x470b922af22e3a97:0x5c2c5821630db9c4!2m2!1d14.4867234!2d50.0218867!1m0!2m1!5e0!3e3?hl=cs',
                'HEAVY' => 'https://www.google.cz/maps/dir/Caf%C3%A9+Z%C3%A1ti%C5%A1%C3%AD,+Ure%C5%A1ova+1757,+148+00+Praha-Kunratice/50.0717146,14.4021649/@50.0562447,14.4124154,13z/data=!3m1!4b1!4m9!4m8!1m5!1m1!1s0x470b922af22e3a97:0x5c2c5821630db9c4!2m2!1d14.4867234!2d50.0218867!1m0!3e3?hl=cs',
            ),
        ),
        'JSe' => array(
            'origin' => 'place_id:ChIJa3qYGECUC0cRbz9FDbO25cY', // Shell Strakonicka Lihovar
            'destination' => 'place_id:ChIJ7TjLf8iTC0cR7-Q5xiHHEJ0', // OBI
            'x-time_expected' => 960, // travel time expected
            'x-summary_expected' => 'Městský Okruh',
            'x-preferred-url' => array(
                'usual' => 'https://www.google.cz/maps/dir/50.0717146,14.4021649/Caf%C3%A9+Z%C3%A1ti%C5%A1%C3%AD,+Ure%C5%A1ova+1757,+148+00+Praha-Kunratice/@50.0459649,14.4207441,13z/data=!3m1!4b1!4m11!4m10!1m0!1m5!1m1!1s0x470b922af22e3a97:0x5c2c5821630db9c4!2m2!1d14.4867234!2d50.0218867!2m1!5e0!3e3?hl=cs',
                'HEAVY' => 'https://www.google.cz/maps/dir/50.0717146,14.4021649/Caf%C3%A9+Z%C3%A1ti%C5%A1%C3%AD,+Ure%C5%A1ova+1757,+148+00+Praha-Kunratice/@50.0521712,14.4124154,13z/data=!3m1!4b1!4m11!4m10!1m0!1m5!1m1!1s0x470b922af22e3a97:0x5c2c5821630db9c4!2m2!1d14.4867234!2d50.0218867!2m1!5e3!3e3?hl=cs',
            ),
        ),
    );

    /**
     * @var array
     */
    private $config_defaults;
    /**
     * @var string[]
     */
    private $options;

    private $time_ratio = 1.5;

    public function __construct($config_defaults, $options = array(), $auto_notify = true)
    {
        $this->config_defaults = $config_defaults;
        $this->options = $options;
        $this->auto_notify = $auto_notify;
    }


    /**
     * @param string $selected_config
     * @return bool
     */
    public function find($selected_config)
    {
        if ($selected_config && isset($this->configs[$selected_config])) {
            $config = $this->config_defaults + $this->configs[$selected_config];
        } else {
            $this->errors[] = 'no config';

            return false;
        }

        $url = $this->options['url'];
        if (empty($this->options['demo_data'])) {
            if ($this->options['method'] === 'POST') {
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
                        'Content-Length: '.strlen($data_string),
                    )
                );
            } else {
                $params = '';
                foreach ($config as $key => $value) {
                    if (strpos($key, 'x-') === 0) {
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
            $result = $this->options['demo_data'];
        }

//var_export($result);exit;

        if ($result['status'] !== 'OK') {
            $this->errors[] = $result['status'];
        } else {
            if (\count($result['routes']) < 1) {
                $this->errors[] = 'No routes!';

                return false;
            }
        }

        $filtered = array();

        foreach ($result['routes'] as $route) {
            $route_filtered = array(
                'via' => array(),
                'time' => 0,
            );
            $route_filtered['polyline'] = $route['overview_polyline'];
            $route_filtered['via'][] = $route['summary'];
            $route_filtered['expected_time'] = !empty($config['x-time_expected']) ? $config['x-time_expected'] : 0;
            $route_filtered['expected_via'] = !empty($config['x-summary_expected']) ? $config['x-summary_expected'] : null;

            foreach ($route['legs'] as $leg) {
                $route_filtered['via'][] = $this->firstPart($leg['end_address']);
                if (isset($leg['duration_in_traffic'])) {
                    $time = $leg['duration_in_traffic']['value'];
                } else {
                    $time = $leg['duration']['value'];
                }
                $route_filtered['time'] += $time;
            }
            $filtered[] = $route_filtered;
        }
        $level = $this->options['level'];
        foreach ($filtered as $route) {
            foreach ($route['via'] as $k => $addr) {
                $route['via'][$k] = trim(preg_replace('~[\d]+/[\d]+$~', '', $addr));
            }
            $via = implode($this->via_glue, $route['via']);
            $deviated = false;
            if ($route['expected_via']) {
                if (strpos($via, $route['expected_via']) === false) {
                    $deviated = true;
                }
            }
            $type = '';
            $normal_time = '';
            $url = null;
            $subtype = null;
            if ($route['expected_time']) {
                if ($route['expected_time'] < $route['time']
                    && gmdate('H:i', $route['expected_time']) !== gmdate('H:i', $route['time'])
                ) {
                    $level = 5;
                    $type = 'HEAVY';
                    $normal_time = ' (usual: '.gmdate('H:i', $route['expected_time']).')';
                    if ($route['expected_time'] * $this->time_ratio > $route['time']) {
                        $via = '? '.$via;
                        $subtype = 'slow';
                    } else {
                        if ($deviated) {
                            $via = '!!!' . $via;
                        } else {
                            $via = '! '.$via;
                        }
                    }
                } else {
                    $type = 'usual';
                }
            }

            if (!$subtype) {
                $subtype = $type;
            }
            $time = gmdate('H:i', $route['time'])." min in $subtype traffic".$normal_time;
            $command = $this->options['PUSHJET']
                .' -s '.$this->options['pushjet_secret']
                .' -l '.$level
                .' -t '.escapeshellarg(
                    $via
                ).' -m '.escapeshellarg($time);
            if (isset($config['x-preferred-url'], $config['x-preferred-url'][$type])) {
                $url = $config['x-preferred-url'][$type];
                $command .= ' -u '.escapeshellarg($url);
            }
            $this->result = array(
                'text' => "$via $time",
                'url' => $url,
                'command' => $command,
            );

        }

        return true;
    }

    public function getConfigs()
    {
        return $this->configs;
    }

    public function getResult()
    {
        if ($this->auto_notify) {
            $this->notify();
        }

        return $this->result;
    }

    public function getErrors()
    {
        return $this->errors;
    }

    private function firstPart($address)
    {
        $address_parts = explode(',', $address);

        return $address_parts[0];
    }

    public function notify($once = true)
    {
        if ($once && $this->notified) {
            return;
        }
        $command = trim(@$this->result['command']);
        if ($command) {
            exec($command);
            $this->notified = true;
        }
    }

    public function setGlue($glue)
    {
        $this->via_glue = $glue;
    }
}
