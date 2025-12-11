#!/opt/homebrew/bin/apl -s -f

⍝ readprob returns a nested array
⍝ - the first element is a nested character vector
⍝   with each device name.
⍝ - the second element is a nested array where the n'th
⍝   element is a vector of integers giving the numbers
⍝   of the devices to which device n's outputs are attached
∇ y ← readprob f; n; m; a; b
  x ← ⎕FIO['read_text'] f
  n ← ({(¯1+⍵⍳':')↑⍵}¨x),⊂'out'
  m ← {a←' '=(⍵⍳':')↓⍵ ◊ b←+\a ◊ b[a/⍳⍴a] ← 0 ◊ n ⍳ b⊂(⍵⍳':')↓⍵}¨x
  y ← n (m,⊂0⍴0)
∇

⍝ npath finds the number of paths from device i to device j
⍝ it assumes the edge map is in the variable e defined in the
⍝ caller's environment
∇ y ← to npath from
  y ← 1
  →(to=from)/0
  y ← +/to npath¨ from ⊃ e
∇

⍝ the solution
∇ y ← aoc11a f;p;n;e
  p ← readprob f
  n ← 1⊃p
  e ← 2⊃p
  y ← (n⍳⊂'out') npath n⍳⊂'you'
∇



⍞←"\r"
⍞←aoc11a 'aoc11a_testdata.txt'
⍞←"\n"
⍞←aoc11a 'aoc11_data.txt'
⍞←"\n"

)OFF
