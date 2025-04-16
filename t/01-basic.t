use v5.16;
use warnings;

use Test::More;

use Crypt::URandom::MonkeyPatch;

ok rand(), "rand()";

ok rand(0), "rand(0)";

ok rand(10), "rand(10)";

done_testing;
