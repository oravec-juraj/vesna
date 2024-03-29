<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'mailgun' => [
        'domain' => env('MAILGUN_DOMAIN'),
        'secret' => env('MAILGUN_SECRET'),
        'endpoint' => env('MAILGUN_ENDPOINT', 'api.mailgun.net'),
        'scheme' => 'https',
    ],

    'postmark' => [
        'token' => env('POSTMARK_TOKEN'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'arduino' => [
        'key' => env('ARDUINO_ACCESS_KEY_ID'),
        'secret' => env('ARDUINO_SECRET_ACCESS_KEY'),
    ],

    'credentials' => [
        'admin_email' => env('ADMIN_EMAIL'),
        'admin_pass'  => env('ADMIN_PASSWORD'),
        'user_email'  => env('USER_EMAIL'),
        'user_pass'   => env('USER_PASSWORD'),
    ],
];
