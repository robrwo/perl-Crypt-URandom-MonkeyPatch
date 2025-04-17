package Crypt::URandom::MonkeyPatch;

use v5.16;
use warnings;

use Config;
use Crypt::URandom qw( urandom );

use constant SIZE => 2**( $Config{ivsize} * 8 );
use constant MASK => SIZE - 1;

BEGIN {

    *CORE::GLOBAL::rand = \&rand;
}

sub rand(;$) {
    my $a = shift || 1;

    state $bytes =
      $Config{ivsize} == 8
      ? sub { unpack( "Q", urandom(8) ) }
      : sub { unpack( "N", urandom(4) ) };

    my ($b) = $bytes->() & MASK;
    say STDERR __PACKAGE__ . "::urandom used" if $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG};
    return $a * $b / SIZE;
}

=head1 SEE ALSO

L<Crypt::URandom>

L<CORE>

L<perlfunc>

=cut

1;
