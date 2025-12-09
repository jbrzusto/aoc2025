#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads file f into an n x 2 integer matrix
∇ y ← readprob f
  y ← ⊃ ⍎¨ (⎕FIO['read_text'] f)
∇

⍝ Plotting the data shows the path is basically a circle
⍝ with a horizontal notch removed, almost all the way across.
⍝ This shape suggests that any rectangles with two red tiles as corners
⍝ but which lie entirely outside the overall path cannot be very large,
⍝ and so can safely be ignored because they won't be the rectangle with the
⍝ largest area.  So what follows isn't a general solution, because I'm
⍝ only filtering out rectangles crossed by the path, not those lying
⍝ completely outside it.


⍝ edgecut checks whether the edge between the points
⍝ e[1;] and e[;2] (assumed to be either vertical or horizontal)
⍝ crosses any of the edges of the rectangle
⍝ given in r. r is (xlo, xhi, ylo, yhi)
∇ y ← r edgecut e; h
  →(e[1;2] = e[2;2])/horiz
  ⍝ vertical line; it does not cut the rectangle if it
  ⍝ is to the left or right of the rectangle, or above or below
  y ← ~(e[1;1] ≤ r[1]) ∨ (e[1;1] ≥ r[2]) ∨ ((⌈/e[;2]) ≤ r[3]) ∨ ((⌊/e[;2]) ≥ r[4])
  →0
horiz:
  ⍝ horizontal line; similar test
  y ← ~(e[1;2] ≤ r[3]) ∨ (e[1;2] ≥ r[4]) ∨ ((⌈/e[;1]) ≤ r[1]) ∨ ((⌊/e[;1]) ≥ r[2])
∇

⍝ edgecuts checks whether any of the edges in the cyclic path
⍝ given by points in p is at least partly inside the
⍝ rectangle whose corner tiles are i[1] and i[2]
⍝ is a _×2 matrix
∇ z ← i edgecuts p; r; x; y
  r ← m[i;]
  x ← (⌊/r[;1]), ⌈/r[;1]
  y ← (⌊/r[;2]), ⌈/r[;2]
  z ← ∨/{(x,y) edgecut mp[⍵,⍵+1;]} ¨ ⍳nr
∇

⍝ good tests whether the rectangle with tiles i and j as corners
⍝ is within the problem path, assumed to be the variable mp,
⍝ defined in the caller's environment
∇ y ← i good j
  y ← ~ (i, j) edgecuts mp
∇


⍝ area calculates the area of the rectangle which has tiles
⍝ i and j as its corners.
⍝ m is the problem matrix, defined in the caller's environment
∇ y ← i area j
  y ← ×/1+|m[i;] - m[j;]
∇

⍝ allareas computes the areas of rectangles formed by all pairs of
⍝ red tiles, and filters out those which are crossed by the path.
⍝ nr is the number of red tiles
∇ y ← allareas nr
  y ← ((⍳nr)⊂(⍳nr)) ∘.{(⍺ good ⍵)/(⍺ area ⍵)} (⍳nr)⊂(⍳nr)
∇

∇ y ← aoc9b f
  m ← readprob f
  mp ← m⍪m[1;]
  nr ← 1↑⍴m
  y ← ⌈/∊allareas nr
∇

⍞←"\r"
⍞←aoc9b 'aoc9_testdata.txt'
⍞←"\n"
⍞←aoc9b 'aoc9_data.txt'
⍞←"\n"

)OFF
