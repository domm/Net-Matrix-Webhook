requires "Class::Accessor::Fast" => "0";
requires "Digest::SHA1" => "0";
requires "Encode" => "0";
requires "Getopt::Long" => "0";
requires "IO::Async::Loop" => "0";
requires "IO::Async::SSL" => "0";
requires "IO::Async::Timer::Countdown" => "0";
requires "Log::Any" => "0";
requires "Log::Any::Adapter" => "0";
requires "Net::Async::HTTP::Server::PSGI" => "0";
requires "Net::Async::Matrix" => "0";
requires "Plack::Request" => "0";
requires "Plack::Response" => "0";
requires "base" => "0";
requires "perl" => "5.010";
requires "strict" => "0";
requires "warnings" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.28";
};

on 'test' => sub {
  requires "Test::More" => "0";
};

on 'configure' => sub {
  requires "Module::Build" => "0.28";
};
