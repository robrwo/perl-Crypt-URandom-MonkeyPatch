#!perl

use strict;
use warnings;

BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    print qq{1..0 # SKIP these tests are for testing by the author\n};
    exit
  }
}

use Test2::V0;

if ( $] < 5.014 ) {
    plan skip_all => "Test::MixedScripts cannot run on this Perl";
}

eval "use Test::MixedScripts qw( all_perl_files_scripts_ok )";

plan skip_all => "Test::MixedScripts not installed" if $@;

all_perl_files_scripts_ok();

done_testing;
