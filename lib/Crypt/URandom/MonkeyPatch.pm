package Crypt::URandom::MonkeyPatch;

# ABSTRACT: override core rand function to use system random sources

use v5.8.0;

use strict;
use warnings;

use Crypt::URandom qw( urandom );

use constant SIZE => 1 << 31;
use constant MASK => SIZE - 1;

our $VERSION = 'v0.1.3';

use version 0.77; $VERSION = version->declare($VERSION);

BEGIN {

    *CORE::GLOBAL::rand = \&rand;
}

sub rand(;$) {
    my $a = shift || 1;
    my ($b) = unpack( "N", urandom(4) ) & MASK;
    if ( $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG} ) {
        my ( $package, $filename, $line ) = caller;
        print STDERR __PACKAGE__ . "::urandom used from ${package} line ${line}\n";
    }
    return $a * $b / SIZE;
}

=begin :prelude

=for stopwords cryptographic

=end :prelude

=head1 SYNOPSIS

    use Crypt::URandom::MonkeyPatch;

=head1 DESCRIPTION

This module globally overrides the builtin Perl function C<rand> with one based on the operating system's cryptographic
random number source, e.g. F</dev/urandom>.

The purpose of this module is monkey patch legacy code that uses C<rand> for security purposes.

You can verify that it is working by running code with the C<CRYPT_URANDOM_MONKEYPATCH_DEBUG> environment variable set,
e.g.

    local $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG} = 1;

    my $salt = random_string("........");

Every time the C<rand> function is called, it will output a line such as

    Crypt::URandom::MonkeyPatch::urandom used from Some::Package line 123

=head1 KNOWN ISSUES

This module is not intended for use with new code, or for use in CPAN modules.  If you are writing new code that needs a
secure source of random bytes, then use L<Crypt::URandom> or see the L<CPAN Author's Guide to Random Data for
Security|https://security.metacpan.org/docs/guides/random-data-for-security.html>.

This should only be used when the affected code cannot be updated.

Because this updates the builtin function globally, it may affect other parts of your code.

=export rand

This globally overrides the builtin C<rand> function using 31-bits of data from the operating system's random source.

=head1 SEE ALSO

L<Crypt::URandom>

L<CORE>

L<perlfunc>

=head1 prepend:SUPPORT

Only the latest version of this module will be supported.

Only Perl versions released in the past ten (10) years are supported, even though this module may run on earlier versions.

=head1 append:SUPPORT

=head2 Reporting Security Vulnerabilities

Security issues should not be reported on the bugtracker website. Please see F<SECURITY.md> for instructions how to
report security vulnerabilities.

=cut

1;
