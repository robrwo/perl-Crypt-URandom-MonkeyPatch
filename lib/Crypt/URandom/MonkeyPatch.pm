package Crypt::URandom::MonkeyPatch;

use v5.16;
use warnings;

use Crypt::URandom qw( urandom );

use constant SIZE => 2**32;
use constant MASK => SIZE - 1;

BEGIN {

    *CORE::GLOBAL::rand = \&rand;
}

sub rand(;$) {
    my $a = shift || 1;
    my ($b) = unpack( "N", urandom(4) ) & MASK;
    say STDERR __PACKAGE__ . "::urandom used" if $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG};
    return $a * $b / SIZE;
}

=head1 SEE ALSO

L<Crypt::URandom>

L<CORE>

L<perlfunc>

=cut

1;
