package Crypt::URandom::MonkeyPatch;

use v5.16;
use warnings;

use Crypt::URandom qw( urandom );

BEGIN {
    *CORE::GLOBAL::rand = \&rand;
}

use constant MASK => 0x7fffffff;

sub rand(;$) {
    my $a = shift || 1;
    my ($b) = unpack( "N", urandom(4) ) & MASK;
    say STDERR __PACKAGE__ . "::urandom used" if $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG};
    return $a * $b / ( 1 + MASK ); # ensure  ratio is < 1
}

=head1 SEE ALSO

L<Crypt::URandom>

L<CORE>

L<perlfunc>

=cut

1;
