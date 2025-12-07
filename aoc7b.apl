#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads file f into a character matrix
∇ y ← readprob f
  y ← ⊃ (⎕FIO['read_text'] f)
∇

⍝ startcol returns the starting column of the beam according to the
⍝ first row of the problem matrix, where start positions are indicated
⍝ by an 'S'.
∇ y ← startcol x
  y ← (x[1;]='S')/⍳1↓⍴x
∇

⍝ grid returns a boolean matrix giving the position
⍝ of splitters in problem matrix x.
∇ y ← grid x
  y ← x = '^'
∇

⍝ runbeam runs the beam in position b through the grid
⍝ starting at row i and returns the number of possible paths taken
⍝ g is assumed to be defined in the caller's environment.
∇ y ← b runbeam i
  y ← 1
  →(i > 1↑⍴g)/0
  →(g[i; b])/split
  y ← b runbeam 1 + i
  →0
  split:
  y ← ((b - 1) runbeam i + 1) + ((b + 1) runbeam i + 1)
∇

⍝ solution: calculate the number of beam splits
⍝ in the problem given in file f
∇ y ← aoc7b f; x
  x ← readprob f
  g ← grid x
  y ← (startcol x) runbeam 1
∇

⍞←"\r"
⍞←aoc7b 'aoc7_testdata.txt'
⍞←"\n"
⍞←aoc7b 'aoc7_data.txt'
⍞←"\n"

)OFF
