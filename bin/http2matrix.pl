#!/usr/bin/env perl
use strict;
use warnings;

use Log::Any::Adapter ( $ENV{LOGADAPTER} || 'Stdout', log_level => $ENV{LOGLEVEL} || 'info' );
use Net::Matrix::Webhook;

#use Getopt::Long;
#my $data   = "file.dat";
#my $length = 24;
#my $verbose;
#GetOptions ("length=i" => \$length,    # numeric
#            "file=s"   => \$data,      # string
#            "verbose"  => \$verbose)   # flag
#or die("Error in command line arguments\n");
#
Net::Matrix::Webhook->new({
    matrix_home_server => $ENV{MATRIX_HOME_SERVER},
    matrix_user => $ENV{MATRIX_USER},
    matrix_password => $ENV{MATRIX_PASSWORD},
    http_port => $ENV{HTTP_PORT} || 8765,
    secret=>$ENV{SECRET},
})->run;


