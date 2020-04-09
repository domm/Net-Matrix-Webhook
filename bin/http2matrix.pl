#!/usr/bin/env perl
use strict;
use warnings;

# ABSTRACT: run Net::Matrix::Webhook
# PODNAME: http2matrix.pl

use Getopt::Long;
use Log::Any::Adapter ( $ENV{LOGADAPTER} || 'Stdout', log_level => $ENV{LOGLEVEL} || 'info' );
use Net::Matrix::Webhook;

my %opts = (
    'matrix_home_server' => $ENV{MATRIX_HOME_SERVER},
    'matrix_room'        => $ENV{MATRIX_ROOM},
    'matrix_user'        => $ENV{MATRIX_USER},
    'matrix_password'    => $ENV{MATRIX_PASSWORD},
    'http_port'          => $ENV{HTTP_PORT} || 8765,
    'secret'             => $ENV{SECRET},
);
GetOptions( \%opts, qw(matrix_home_server=s matrix_room=s matrix_user=s matrix_password=s http_port:i secret:s) );

Net::Matrix::Webhook->new( \%opts )->run;

=pod

=head1 SYNOPSIS

  http2matrix.pl
      --matrix_home_server matrix.example.com
      --matrix_room '#dev:example.com'
      --matrix_user your-bot
      --matrix_password 12345
      --http_port 8080
      --secret s3cr3+

=head1 DESCRIPTION

A wrapper script for L<Net::Matrix::Webhook>. More info available there...

Per default, output will go to C<STDOUT> via L<Log::Any> with a default log level of C<info>. You can set environment vars C<LOGADAPTER> and C<LOGLEVEL> to change this, or write your own wrapper...


