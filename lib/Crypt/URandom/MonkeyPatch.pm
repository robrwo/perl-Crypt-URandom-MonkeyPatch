package Crypt::URandom::MonkeyPatch;

use v5.16;
use warnings;

use Crypt::URandom qw( urandom );

BEGIN {

    *CORE::GLOBAL::rand = sub {
        my $a = shift || 1;
        my ($b) = unpack( "N", urandom(4) );
        say STDERR __PACKAGE__ . "::urandom returns $b" if $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG};
        return $a * $b / 0xffffffff;
    };

}

1;
