#!/opt/homebrew/bin/apl -s -f

⍝ readprob returns a nested array
⍝ - the first element is a nested array with the shapes;
⍝   each shape is a boolean matrix, with 1 corresponding
⍝   to a slot occupied by the present
⍝ - the second element is a nested array giving the regions;
⍝   each region is a nested array, with the first slot
⍝   giving a zero matrix of the appropriate size and shape,
⍝   and the second slot giving the vector of desired shape counts
∇ y ← readprob f; s; i; r
  x ← ⎕FIO['read_text'] f
  ⍝ grab shapes
  s ← (∊{((⍴⍵)<⍵⍳':')∨(0=⍴⍵)}¨x)/x
  i ← (1,,⊃({0=⍴⍵}¨s))/⍳1+⍴s
  s ← {'#'=⍵}¨{⊃s[i[⍵]+¯1+⍳¯1+i[⍵+1]-i[⍵]]}¨⍳¯1+⍴i
  ⍝ grab regions
  r ← (¯1+(⍴s)+¯1↑i)↓x
  r ← {(⊂⍎(('x ')⎕MAP ((¯1+⍵⍳':')↑⍵)),'⍴0'),⊂⍎(1+⍵⍳':')↓⍵}¨r
  y ← (⊂s),⊂r
∇

⍝ poses returns the unique poses for the square matrix x.
⍝ A pose is a rotation or a rotation and a flip.
⍝ The poses are returned as a nested array of matrices
⍝ of the same shape as x.
∇ y ← poses m
  y ← ∪ (m) (⊖m) (⌽m) (⌽⊖m) (⍉m) (⍉⊖m) (⍉⌽m) (⍉⌽⊖m)
∇

⍝ <======  NOT USED IN CURRENT SOLUTION ===========>
⍝ frame returns a 7x7 matrix with pose p at its
⍝ centre and zeroes elsewhere
∇ y ← frame p
  y ← 7 7⍴0
  y[2+⍳3; 2+⍳3] ← p
∇

⍝ interlocks returns a list of offset vectors that permit
⍝ poses p and q to interlock without overlapping
⍝ An offset vector is (r, c), which is a permitted displacement
⍝ from the centre of p to the centre of q, moving r slots
⍝ vertically and c slots horizontally.  Either or both of x, y
⍝ can be negative.  This algorithm only works for 3x3 poses.
∇ y ← p interlocks q; d; fp; fq
  ⍝ maximum displacement in each dimension where pieces still
  ⍝ potentially overlap
  d ← (⍳5) ⊂ (⍳5)-3
  ⍝ frame each pose
  fp ← frame p
  fq ← frame q
  ⍝ check which displacements dont overlap
  y ← (,(d ∘.{1=⌈/,fp+⍺⊖⍵⌽fq} d)) / ,(d ∘., -d)
∇  
⍝ </======  NOT USED IN CURRENT SOLUTION ===========>

⍝ iterpos gives the 2-vector which is the next centre
⍝ location to try after p, which is a two vector
⍝ giving the row and column of the current position
⍝ the problem space matrix r is assumed to be defined in
⍝ the caller's environment.
⍝ returns an empty vector if this is the last position
⍝ this algorithm runs down columns from left to right
∇ y ← iterpos p
  y ← p + 1 0
  → (y[1] < 1↑⍴r)/0
  y ← 2, 1+1↓p
  → (y[2] < 1↓⍴r)/0
  y ← 0⍴0
∇

⍝ fit returns 1 if the set of shapes with counts l fits into the
⍝ region matrix r.
⍝ assumes the nested array of shapes 'sh' is defined in the caller's environment
∇ y ← l fit r
  ⍝ do a sanity check in case the number of cells occupied by the desired
  ⍝ presents is bigger than the grid
  y ← 0
  →((×/⍴r)<(,{+/,⍵}¨sh)+.×l)/0
  ⍝ do a trival solution check in case each present could simply be placed
  ⍝ in its own 3×3 square without overlapping any other presents
  y ← 1
  →((×/⌊(⍴r)÷3)≥+/l)/0
  ⍝ fine, do it the hard way
  y ← (l (2 2)) rfit r
∇
  
⍝ rfit is the recursive worker for fit
⍝ The counts vector is 1⊃l, and the next position to
⍝ try is 2⊃l, which is a 2-vector giving the row and column of the
⍝ centre to try.  The nested array of poses 'ps' is assumed to be
⍝ defined in the caller's environment
∇ y ← l rfit r; c; p; cell; i; j; rr; cc
  ⍝ ⎕←l
  ⍝ ⎕←r
  c ← 1⊃l
  y ← 1
  ⍝ return true if no pieces to place
  →(0=⌈/c)/0
  y ← 0
  p ← 2⊃l
posloop:
  ⍝ return false if no positions left to try
  →(0=⍴p)/0
  cell ← r[¯1 0 1 + p[1]; ¯1 0 1 + p[2]]
  i ← 1
pieceloop:
  ⍝ try next position if no pieces left to try at this position
  →(i>⍴ps)/nextpos
  ⍝ try next piece if we've used all of current piece
  →(c[i]=0)/nextpiece
  j ← 1
poseloop:
  ⍝ try next piece if no poses left to try at this position
  →(j>⍴i⊃ps)/nextpiece
  ⍝ try next pose if this pose overlaps any 1s in the cell
  →(0≠+/,cell×j⊃i⊃ps)/nextpose
⍝  ⎕←'trying' j i 'at' p
  rr ← r
  rr[¯1 0 1 + p[1]; ¯1 0 1 + p[2]] ← cell + j⊃i⊃ps
  cc ← c
  cc[i] ← c[i] - 1
  y ← (cc (iterpos p)) rfit rr
  →y/0
nextpose:
  j ← j + 1
  → poseloop
nextpiece:
  i ← i + 1
  → pieceloop
nextpos:
  p ← iterpos p
  → posloop
∇

⍝ the solution
∇ y ← aoc12a f; prob; sh; ps
  prob ← readprob f
  sh ← 1⊃prob
  ps ← poses ¨ sh
  y ← +/ {(2⊃⍵) fit 1⊃⍵} ¨ 2⊃prob
∇



⍞←"\r"
⍞←aoc12a 'aoc12_testdata.txt'
⍞←"\n"
⍞←aoc12a 'aoc12_data.txt'
⍞←"\n"

)OFF
