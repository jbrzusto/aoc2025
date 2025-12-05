#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads a problem file and returns an n x 2
⍝ matrix of ranges of integers, with each row
⍝ in the form (low, high)
∇ y ← readprob f; s; n
  x ← ⎕FIO['read_text'] f
  s ← (,⊃0=⍴¨x)/⍳⍴x   ⍝ where to split the file
  y ← ⍎'- ' ⎕MAP ,(⊃(s-1)↑x),' '
  n ← 0.5 × ⍴y
  y ← (n, 2)⍴y
∇

⍝ box reshapes a vector into an nx2 matrix
∇ y ← box x
  y ← ((.5×⍴x),2)⍴x
∇

⍝ overlaps merges overlaps in an nx2 matrix of ranges
∇ y ← overlaps x
  x ← ,x[⍋x;]
  y ← box (2↑x) lapper 2↓x
∇

⍝ lapper moves/folds the first range from its right argument
⍝ to its left argument, merging or deleting as needed
∇ z ← x lapper y
  z ← x
  →(0=⍴y)⍴0 ⍝ nothing left to do
  →((¯1↑x) < ¯1 + 1 ↑ y)/copy
merge:
  x←(¯1↓x),(¯1↑x)⌈y[2]
  →cont
copy:
  x←x, 2↑y
cont:
  z←x lapper 2↓y
∇

⍝ rangecount returns the number of distinct integers
⍝ which are in at least one of the ranges given in the 2-column
⍝ matrix r
∇ y←rangecount r
  r ← overlaps r
  y ← +/ 1 + r[;2] - r[;1]
∇

⍝ the solution: read the problem from file f
⍝ and return the total number of known fresh items
∇ y←aoc5b f; r
  y ← rangecount readprob f
∇

⎕pp←15

⍞←"\r"
⍞←aoc5b 'aoc5_testdata.txt'
⍞←"\n"
⍞←aoc5b 'aoc5_data.txt'
⍞←"\n"

)OFF

