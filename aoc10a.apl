#!/opt/homebrew/bin/apl -s -f

⍝ We represent the indicator lights as a boolean vector of length n.
⍝ Each button is a toggle, and can also be represented as
⍝ a boolean vector of length n, with 1 indicating
⍝ which display lights it toggles.
⍝ The target display light pattern is also a boolean n-vector
⍝
⍝ The problem is to find a sequence of button pushes that
⍝ leaves the (initially all off) indicator lights in the
⍝ desired pattern.
⍝
⍝ Pushing a button is equivalent to xor of the button's vector
⍝ with the current state of the indicator lights.
⍝ Because xor is commutative and (x xor x) xor y = y for all
⍝ x and y, only the parity of the number of button pushes matter.
⍝
⍝ So a solution to the problem is also a boolean vector, but with
⍝ length equal to the number of button, indicating which buttons
⍝ are pressed exactly once to get the solution.  The number of 1
⍝ in that solution is the objective to minimize.

⍝ readprob returns a vector
⍝ with each element a nested array for one machine
⍝ (see parseprob)
∇ y ← readprob f
  y ← parseprob¨ (⎕FIO['read_text'] f) 
∇

⍝ parseprob parses a single problem line (for 1 machine)
⍝ and returns a nested vector with two elements:
⍝   (1) indicator light pattern sought
⍝   (2) boolean matrix; row i gives the pattern of lights
⍝       toggled by button i.
∇ y ← parseprob s; d; l; b
  s ← ⊃s
  d ← s ⍳ ']'
  l ← '#'=1↓(d-1)↑s
  s ← d↓s
  d ← s ⍳ '{'
  b ← 1 + ⍪¨⍎ (d-1)↑s
  b ← ⍉(⍳⍴l)∘.∊b
  y ← (⊂l),(⊂b)
∇

⍝ togpat n returns a boolean matrix of shape (2*n), n
⍝ the rows are all distinct boolean vectors of length n,
⍝ and are sorted in order from fewest to most 1s in the row.
∇ y ← togpat n
  y ← ⍉ (n⍴2) ⊤ ⍳2*n
  y ← y[⍋+/y;]
∇

⍝ minpush returns the smallest number of button pushes
⍝ required to achieve the desired pattern of indicator lights
⍝ p is a problem
∇ y ← minpush p; l; b; tp; a
  l ← 1 ⊃ p
  b ← 2 ⊃ p
  tp ← togpat 1↑⍴b
  a ← tp ≠.× b
  y ← +/tp[1↑(a∧.=l)/⍳1↑⍴tp;]
∇

⍝ solution
∇ y ← aoc10a f
  y ← +/minpush ¨ readprob f
∇

⍞←"\r"
⍞←aoc10a 'aoc10_testdata.txt'
⍞←"\n"
⍞←aoc10a 'aoc10_data.txt'
⍞←"\n"

)OFF
