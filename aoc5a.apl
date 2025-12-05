#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads a problem file and returns a nested array
⍝ with these two items:
⍝   1 ⊃ y: an n x 2 matrix of ranges of integers, with each row
⍝          in the form (low, high)
⍝   2 ⊃ y: a vector of integer item numbers
∇ y ← readprob f; s; r; n; i
  x ← ⎕FIO['read_text'] f
  s ← (,⊃0=⍴¨x)/⍳⍴x   ⍝ where to split the file
  r ← ⍎'- ' ⎕MAP ,(⊃(s-1)↑x),' '
  n ← 0.5 × ⍴r
  r ← (n, 2)⍴r
  i ← ⍎,(⊃s↓x), ' '
  y ← (⊂r),⊂i
∇

⍝ rangecount returns the number of integers from vector i
⍝ which are in at least one of the ranges given in the 2-column
⍝ matrix r
∇ y←i rangecount r
  y←+/ ∨/ (i ∘. ≥ r[;1]) ∧ i ∘.≤ r[;2]
∇

⍝ the solution: read the problem from file f
⍝ and return the number of items which are fresh
∇ y←aoc5a f; r; i
  ri ← readprob f
  y←(2 ⊃ ri) rangecount 1 ⊃ ri
∇

⎕pp←15

⍞←"\r"
⍞←aoc5a 'aoc5_testdata.txt'
⍞←"\n"
⍞←aoc5a 'aoc5_data.txt'
⍞←"\n"

)OFF

