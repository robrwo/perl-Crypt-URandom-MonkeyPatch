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
    if ( $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG} ) {
        my ( $package, $filename, $line ) = caller;
        say STDERR __PACKAGE__ . "::urandom used from ${package} line ${line}";
    }
    return $a * $b / SIZE;
}

=head1 SYNOPSIS

    use Crypt::URandom::MonkeyPatch;

=head1 DESCRIPTION

This module globlly overrides the builtin Perl function C<rand> with one based on the operating system's cryptographic
random number source, e.g. F</dev/urandom>.

The purpose of this module is monkey patch legacy code that uses C<rand> for security purposes.

You can verify that it is working by running code with the C<CRYPT_URANDOM_MONKEYPATCH_DEBUG> environment variable set,
e.g.

    local $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG} = 1;

    my $salt = random_string("........");

Every time the C<rand> function is called, it will output a line such as

    Crypt::URandom::MonkeyPatch::urandom used from Some::Package line 123

This module is not intended for use with new code, or for use in CPAN modules.  If you are writing new code that needs a
secure souce of random bytes, then use L<Crypt::URandom> or see the L<CPAN Author's Guide to Random Data for
Security|https://security.metacpan.org/docs/guides/random-data-for-security.html>.

=head1 EXPORTS

=head2 rand

This globally overrides the builtin C<rand> function.

=head1 SEE ALSO

L<Crypt::URandom>

L<CORE>

L<perlfunc>

=cut

1;
