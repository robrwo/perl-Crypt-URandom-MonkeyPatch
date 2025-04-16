use v5.16;
use warnings;

use Test::More;
use Test::Output;

use Crypt::URandom::MonkeyPatch;

ok rand(), "rand()";

ok rand(0), "rand(0)";

ok rand(10), "rand(10)";

stderr_like {

    local $ENV{CRYPT_URANDOM_MONKEYPATCH_DEBUG} = 1;

    rand();
}
qr/^Crypt::URandom::MonkeyPatch::urandom returns [0-9]+$/, "debug output";

done_testing;
