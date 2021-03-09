<?php

require __DIR__ . '/vendor/autoload.php';

use Prometheus\CollectorRegistry;
use Prometheus\RenderTextFormat;
use Prometheus\Storage\Redis;

if (isset($_REQUEST['uri'])) {
    if ($_REQUEST['uri'] == '/metrics') {
        Redis::setDefaultOptions(
            [
                'host' => 'redis',
                'port' => 6379,
                'database' => 0,
                'password' => null,
                'timeout' => 0.1, // in seconds
                'read_timeout' => '10', // in seconds
                'persistent_connections' => false
            ]
        );
        $registry = CollectorRegistry::getDefault();
        $renderer = new RenderTextFormat();
        $result = $renderer->render($registry->getRegistry()->getMetricFamilySamples());
        header('Content-type: ' . RenderTextFormat::MIME_TYPE);
        echo $result;
        die;
    }
}

echo json_encode(
    ["service" => "metrics"]
);
