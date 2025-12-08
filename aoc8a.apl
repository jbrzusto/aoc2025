#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads file f into an n x 3 integer matrix
∇ y ← readprob f
  y ← ⊃ ⍎¨ 1 ⊂ ', ' ⎕map ⊃ (⎕FIO['read_text'] f)
  y ← y[⍳1↑⍴y; 1; ⍳¯1↑⍴y]
∇

⍝ dists calculates distances between distinct rows in
⍝ an nx3 matrix, finds the largest m such distances, and
⍝ returns a matrix with 3 columns corresponding to these
⍝ distances, sorted in increasing order of distance
⍝ - [;1] index of first row
⍝ - [;2] index of second row (<[;1])
∇ y ← m dists x; n; d; r1; r2
  n ← 1↑⍴x
  d ← (1⊂x)∘.{+/(⍺-⍵)*2}(1⊂x)
  r1 ← n/⍳n
  r2 ← (n×n)⍴⍳n
  y ← r1,r2,⍪,d
  y ← (y[;3] > 0)⌿y
  y ← y[⍋y;]
  y ← ((1↑⍴y)⍴1 0)⌿y
  y ← y[m↑⍋y[;3]; 1 2]
∇

⍝ circuits makes the connections between junction boxes
⍝ as indicated by an nx2 matrix m of junction box numbers,
⍝ where each row is a connection between junction boxes.
⍝ It returns a nested array of circuits, each of which is
⍝ a vector of junction boxes.
∇ y ← circuits m; n; cn; r; nc
  m ← m[⍋m;]
  n ← ⌈/,m ⍝ largest jb number
  cn ← n ⍴ 0 ⍝ circuit number for each jb; 0 means not in a circuit yet
  r ← 1 ⍝ current row
  nc ← 0 ⍝ number of circuits
loop:
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
  r ← 1 + r
  →(r ≤ 1↑⍴m)/loop
  icn ← ⍋cn
  y ← cn[icn]⊂(⍳n)[icn]
∇

⍝ checksum calculates the product of the sizes of the n
⍝ largest circuits created from the edge matrix m
⍝ m is of the form returned by dists
∇ y ← n checksum m; s
  s ← ,⊃⍴¨circuits m
  y ← ×/s[(⍒s)[⍳n]]
∇


⍝ solution: calculate the product of the n[1] largest circuits
⍝ created by the n[2] largest distances in problem file f
∇ y ← n aoc8a f; p; m
  p ← readprob f
  m ← n[2] dists p
  y ← n[1] checksum m
∇

⍞←"\r"
⍞←3 10 aoc8a 'aoc8_testdata.txt'
⍞←"\n"
⍞←3 1000 aoc8a 'aoc8_data.txt'
⍞←"\n"

)OFF
