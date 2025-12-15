# Advent Of Code 2025

To run the scripts, install GNU-APL (e.g. `brew install gnu-apl` on
OSX) and then do e.g. `./aoc3a.apl`

Each script prints the output for the test data, and then for the full
data.  Errors about a missing server can be safely ignored,
apparently.

`aoc2a.apl` is awkward and `aoc2b.apl` is just foolish.  In both of
them, the `overlaps` function is wrong!  There is a working version in
`aoc5b.apl`, which is the first place it was actually needed.

`aoc8b.apl` has a cleaner version of the circuit builder than `aoc8a.apl`

`aoc9b.apl` took ~ 15 minutes to run on a 2024 Macbook Pro; the
selected square is shown in `aoc9b_plot.png`

`aoc10b.apl` took just under 2 minutes on the same computer; I'm sure
there's a clean way to use the QR factorization provided by the ⌹[2]
function, but I gave up on it too soon.  This approach uses (hand
crafted!) gaussian elimination to reduce the dimension of the solution
search space down to the rank of the button/counter matrix.  There are
a few direct reductions attempted first, but none of these has a
dramatic effect on the size of the search space (see `aoc10b.log`).





