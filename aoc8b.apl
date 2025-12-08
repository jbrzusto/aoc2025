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

⍝ fullcircuit makes the connections between junction boxes
⍝ as indicated by an nx2 matrix m of junction box numbers,
⍝ where each row is a connection between junction boxes.
⍝ It adds edges in order from shortest to longest distance
⍝ until either all edges have been added or all junction boxes
⍝ are in a single circuit.
⍝ it returns the indexes of the last two junction boxes added
∇ y ← fullcircuit m; n; cn; r; nc
  n ← ⌈/,m ⍝ largest jb number
  cn ← n ⍴ 0 ⍝ circuit number for each jb; 0 means not in a circuit yet
  r ← 1 ⍝ current row
  nc ← 0 ⍝ number of circuits
loop:
  → ((nc > 0) ∧ ((⌈/cn) = ⌊/cn))/done ⍝ all jbs in same circuit
  → ((cn[m[r; 1]] > 0) ∧ (cn[m[r; 2]] > 0))/merge
  → (cn[m[r; 1]] > 0)/joinleft
  → (cn[m[r; 2]] > 0)/joinright
  nc ← nc + 1
  cn[m[r; 1], m[r; 2]] ← nc
  → 1/next
joinleft:
  ⍝ right jb joins left circuit
  cn[m[r; 2]] ← cn[m[r; 1]]
  → 1/next
joinright:
  ⍝ left jb joins right circuit
  cn[m[r; 1]] ← cn[m[r; 2]]
  → 1/next
merge:
  ⍝ jbs in larger circuit relabelled to be in smaller circuit
  cn[(cn=⌈/cn[m[r;⍳2]])/⍳⍴cn] ← ⌊/cn[m[r;⍳2]]
  → 1/next
next:
  ⍝ comment
  y ← m[r; ⍳2]
  r ← 1 + r
  →(r ≤ 1↑⍴m)/loop
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
