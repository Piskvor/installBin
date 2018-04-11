<?php

namespace Fetcher;

class Fetcher
{

    /**
     * @var array
     */
    private $accounts;

    /**
     * @var string
     */
    private $url;

    /**
     * @var callable
     */
    private $parser;

    /**
     * Fetcher constructor.
     * @param array $accounts
     * @param string $url
     * @param callable $parser
     */
    public function __construct($accounts, $url, $parser)
    {
        $this->accounts = $accounts;
        $this->url = $url;
        $this->parser = $parser;
    }

    /**
     * @param \DateTime $from
     * @param \DateTime $to
     * @return array
     */
    public function fetch(\DateTime $from, \DateTime $to)
    {
        $results = array();
        $parser = $this->parser;
        $curl = curl_init();

        foreach ($this->accounts as $name => $token) {
            $url = str_replace(
                array(
                    '$token',
                    '$from',
                    '$to'
                ),
                array(
                    $token,
                    $from->format('Y-m-d'),
                    $to->format('Y-m-d'),
                ),
                $this->url
            );
            // Set some options - we are passing in a useragent too here
            curl_setopt_array($curl, array(
                CURLOPT_RETURNTRANSFER => 1,
                CURLOPT_URL => $url,
            ));
            // Send the request & save response to $resp
            $data = curl_exec($curl);
            if ($data) {
                $results[$name] = $parser($data);
            }
        }
        // Close request to clear up some resources
        curl_close($curl);
        return $results;
    }
}
