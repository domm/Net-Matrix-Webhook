#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long;
use Log::Any::Adapter ( $ENV{LOGADAPTER} || 'Stdout', log_level => $ENV{LOGLEVEL} || 'info' );
use Net::Matrix::Webhook;

my %opts = (
    'matrix_home_server' => $ENV{MATRIX_HOME_SERVER},
    'matrix_user'        => $ENV{MATRIX_USER},
    'matrix_password'    => $ENV{MATRIX_PASSWORD},
    'http_port'          => $ENV{HTTP_PORT} || 8765,
    'secret'             => $ENV{SECRET},
);
GetOptions( \%opts, qw(matrix_home_server=s matrix_user=s matrix_password=s http_port:i secret:s) );

Net::Matrix::Webhook->new( \%opts )->run;

