package Net::Matrix::Webhook;

# ABSTRACT: A http->matrix webhook

use strict;
use warnings;
use 5.010;

our $VERSION = "3.000";

use Net::Async::HTTP::Server::PSGI;
use Net::Async::Matrix;
use IO::Async::Loop;
use IO::Async::Timer::Countdown;
use Plack::Request;
use Plack::Response;
use Digest::SHA1 qw(sha1_hex);
use Encode;
use Log::Any qw($log);

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors( qw(
    matrix_home_server matrix_user matrix_password
    http_port
    secret
));

binmode( STDOUT, ':utf8' );

sub run {
    my $self = shift;

    my $loop = IO::Async::Loop->new;

    my $matrix = Net::Async::Matrix->new(
        server => $self->matrix_home_server,
        SSL    => 1,
    );
    $loop->add($matrix);

    $matrix->login(
        user_id  => $self->matrix_user,
        password => $self->matrix_password,
    )->get;
    $log->infof( "Logged in as %s at %s", $self->matrix_user, $self->matrix_home_server );
    my $room = $matrix->join_room('#test:validad.net')->get;
    $log->infof( "Joined room %s", $room->name );

    my $httpserver = Net::Async::HTTP::Server::PSGI->new(
        app => sub {
            my $env = shift;
            my $req = Plack::Request->new($env);

            my $params = $req->parameters;
            my $msg    = decode_utf8( $params->{message} );
            if ( $self->secret ) {
                my $token = $params->{token};
                my $check = sha1_hex( encode_utf8($msg), $self->secret );
                if ( !$token || ( $token ne $check ) ) {
                    return Plack::Response->new( 401, undef, 'bad token' )->finalize;
                }
            }
            $log->debugf( "got message >%s<", $msg );

            eval { $room->send_message($msg)->get };
            if ($@) {
                return Plack::Response->new( 500, undef, $@ )->finalize;
            }
            return Plack::Response->new( 200, undef, 'message posted to matrix' )->finalize;
        }
    );
    $loop->add($httpserver);

    $httpserver->listen(
        addr => { family => "inet", socktype => "stream", port => $self->http_port }, )->get;

    $log->infof( "Started http server at http://localhost:%s", $self->http_port );

    $loop->run;
}

1;
