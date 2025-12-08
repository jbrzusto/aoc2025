#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads file f into an n x 3 integer matrix
∇ y ← readprob f
  y ← ⊃ ⍎¨ 1 ⊂ ', ' ⎕map ⊃ (⎕FIO['read_text'] f)
  y ← y[⍳1↑⍴y; 1; ⍳¯1↑⍴y]
∇

⍝ dists calculates (squared) distances between distinct rows in an nx3 matrix
⍝ and returns a matrix with 2 columns corresponding to these
⍝ distances, sorted in increasing order of distance:
⍝ - [;1] index of first row
⍝ - [;2] index of second row
∇ y ← dists x; n; d; r1; r2
  n ← 1↑⍴x
  d ← (1⊂x)∘.{+/(⍺-⍵)*2}(1⊂x)
  r1 ← n/⍳n
  r2 ← (n×n)⍴⍳n
  y ← r1,r2,⍪,d
  ⍝ drop diagonal
  y ← (y[;3] > 0)⌿y
  ⍝ get lower triangle
  y ← y[⍋y;]
  y ← ((1↑⍴y)⍴1 0)⌿y
  ⍝ sort by increasing distance and drop distance
  y ← y[⍋y[;3];1 2]
∇

⍝ fullcircuit makes the connections between junction boxes as
⍝ indicated by an nx2 matrix m of junction box numbers, where each row
⍝ is a connection between junction boxes given by indexes in the first
⍝ and second columns. It connects pairs of junction boxes using edges
⍝ in order from shortest to longest distance until either all edges
⍝ have been added or all junction boxes are in a single circuit.  It
⍝ returns a vector of the two junction boxes whose connection
⍝ completed the circuit.
∇ y ← fullcircuit m; jbs; s; r
  ⍝ start with each (unique) jb in its own nested circuit
  jbs ← ∪,m
  s ← (⍳⍴jbs)⊂jbs
  ⍝ process connection matrix rows
  r ← 0
loop:
  r ← 1 + r
  → (r > 1↑⍴m)/done
  ⍝ in which nested circuits are the junction boxes for the next
  ⍝ connection?
  i ← {∨/m[r;]∊⍵}¨s
  ⍝ drop the individual nested circuits, then append their union
  s ← ((~i)/s), ∪/i/s
  ⍝ continue if not yet down to a single circuit
  → (1 ≠ ⍴s)/loop
  ⍝ return the last connected junction boxes
  y ← m[r;]
  done:
∇

⍝ checksum calculates the product of the x coordinates of the two
⍝ last junction boxes connected to complete a full circuit
⍝ p is a problem matrix, as read by readprob
∇ y ← checksum p; m; s
  m ← dists p  
  jbs ← fullcircuit m
  y ← ×/p[jbs; 1]
∇

⍝ solution: calculate the product of the x-coordinates of the
⍝ two last junction boxes added when creating a full circuit
⍝ by adding connections from shortest to longest
∇ y ← aoc8b f; p; m
  p ← readprob f
  y ← checksum p
∇

⍞←"\r"
⍞←aoc8b 'aoc8_testdata.txt'
⍞←"\n"
⍞←aoc8b 'aoc8_data.txt'
⍞←"\n"

)OFF
