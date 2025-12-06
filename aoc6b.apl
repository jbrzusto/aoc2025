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

⍝ delims returns the indexes of the delimiter columns
⍝ in problem x; i.e. those columns which are entirely ' '
∇ y ← delims x
  y ← (∧⌿' '=x)/⍳1↓⍴x
∇

⍝ split breaks the numbers portion of a problem character matrix
⍝ into a nested array where the characters of each number are
⍝ in their own string.
∇ y ← split x; d; n; p
  x ← ¯1 0 ↓ x
  d ← 0, (delims x), 1+1↓⍴x
  n ← ¯1↓,(⍪¯1+(1↓d)-¯1↓d), 1
  p ← ¯1↓,(⍪⍳¯1+⍴d), 0
  y ← (n/p) ⊂ x
∇

⍝ juggle combines each individual problem's numbers into a
⍝ normal representation, given the way Cephalopods read numbers.
⍝ x should be a nested array like the ones returned by split
∇ y ← juggle x
  y ← {⍉⊃x[;⍵]}¨⍳1↓⍴x
∇


⍝ explist computes a nested array of APL expressions that represent
⍝ each column of the original problem, as interpreted by Cephalopods
∇ y ← explist x; op; m
  op ← ops x
  m ← juggle split x
  y ← op,¨,'/',¨,¨' ',¨m
∇

⍝ checksum computes the homework checksum from nested expression array x
⍝ by evaluating each expression then returning their sum
∇ y ← checksum x
  y ← +/,⍎¨x
∇

⍝ solution: calculate the checksum of the homework
⍝ in file f
∇ y ← aoc6b f
  y ← checksum explist readprob f
∇

⍞←"\r"
⍞←aoc6b 'aoc6_testdata.txt'
⍞←"\n"
⍞←aoc6b 'aoc6_data.txt'
⍞←"\n"

)OFF

  
