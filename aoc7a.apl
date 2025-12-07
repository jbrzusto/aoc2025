#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads file f into a character matrix
∇ y ← readprob f
  y ← ⊃ (⎕FIO['read_text'] f)
∇

⍝ starts returns a boolean vector indicating which
⍝ columns a beam starts in, according to the first
⍝ row of the problem matrix, where start positions
⍝ are indicated by an 'S'.
∇ y ← starts x
  y ← x[1;]='S'
∇

⍝ grid returns a boolean matrix giving the position
⍝ of splitters in problem matrix x.
∇ y ← grid x
  y ← x = '^'
∇

⍝ numsplits returns the number of beam splits that
⍝ occur when the beams given by b encounter the splitters
⍝ given by s.
⍝ b is a boolean vector indicating which columns have a beam
⍝ s is a boolean vector indicating which columns have a splitter
∇ y ← b numsplits s
  y ← +/ b ∧ s
∇

⍝ split returns the new beam pattern after the beams
⍝ b encounter the splitters s, with b and s as in `numsplits`
⍝ beams not encountering splitters just propagate through.
∇ y ← b split s
  ⍝ split
  y ← ((1 ↓ b ∧ s), 0) ∨ 0, (¯1 ↓ b ∧ s)
  ⍝ propagate
  y ← y ∨ (b ∧ ~ s)
∇

⍝ runbeams runs the beams b through the grid
⍝ g and returns the number of beam splits
⍝ b is a boolean vector representing which columns
⍝ have beams, and g is a boolean matrix representing
⍝ splitter locations.  (⍴b) = (1↓⍴g)
∇ y ← b runbeams g
  y ← 0
  →(0=1↑⍴g)/0
  y ← (b numsplits g[1;]) + (b split g[1;]) runbeams 1 0 ↓ g
∇

⍝ solution: calculate the number of beam splits
⍝ in the problem given in file f
∇ y ← aoc7a f; x
  x ← readprob f
  y ← (starts x) runbeams grid x
∇

⍞←"\r"
⍞←aoc7a 'aoc7_testdata.txt'
⍞←"\n"
⍞←aoc7a 'aoc7_data.txt'
⍞←"\n"

)OFF

  
