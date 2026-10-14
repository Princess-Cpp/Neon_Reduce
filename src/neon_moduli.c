#include "neon_reduce.h"
#define M(q,inv,mu) { (q), (inv), (mu) }
/* qinv values are -q^-1 mod 2^32; mu=floor(2^64/q).
 * Keep this table in flash/rodata on embedded targets. */
const struct neon_modulus neon_moduli[] = {
 M(3329u,       2480617617u, 5548994068745ull),
 M(3457u,       2709555055u, 5339373154231ull),
 M(769u,        1450632721u, 23990231724119ull),
 M(2017u,       2708735775u, 9138347135511ull),
 M(16776961u,   3271856415u, 1099511689217ull),
 M(67104769u,   19088743u,   275724548923ull)
};
