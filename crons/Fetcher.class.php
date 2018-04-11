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
            $data = file_get_contents($url);
            if ($data) {
                $results[$name] = $parser($data);
            }
        }
        return $results;
    }
}
