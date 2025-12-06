#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads file f into a character matrix
∇ y ← readprob f
  y ← ⊃ (⎕FIO['read_text'] f)
∇

⍝ ops returns the row of operators from the problem
⍝ character matrix x, with spaces removed and operators
⍝ translated from Cephalopod to APL
∇ y ← ops x
  y ← , x[1↑⍴x;]
  y ← (y ≠ ' ') / y
  y ← ('*×') ⎕MAP y
∇

⍝ torows returns the number lists from the problem, but
⍝ with columns converted to rows
∇ y ← torows x
  y ← ⍎,(¯1 0 ↓x), ' '
  n ← ¯1 + 1↑⍴x
  y ← (⍕ ⍉ (n, ((⍴y)÷n))⍴y), ' '
∇

⍝ explist computes a nested array of APL expressions that represent
⍝ each column of the original problem
∇ y ← explist x; op; m
  op ← ⍪ops x
  m ← torows x
  y ← (1↑⍴m) ⊂ op, '/', m
∇

⍝ checksum computes the homework checksum from nested expression array x
⍝ by evaluating each expression then returning their sum
∇ y ← checksum x
  y ← +/,⍎¨x
∇

⍝ solution: calculate the checksum of the homework
⍝ in file f
∇ y ← aoc6a f
  y ← checksum explist readprob f
∇

⍞←"\r"
⍞←aoc6a 'aoc6_testdata.txt'
⍞←"\n"
⍞←aoc6a 'aoc6_data.txt'
⍞←"\n"

)OFF

  
