#!/opt/homebrew/bin/apl -s -f

⍝ readprob reads file f into an n x 2 integer matrix
∇ y ← readprob f
  y ← ⊃ ⍎¨ (⎕FIO['read_text'] f)
∇

⍝ maxrect calculates the maximum area of a
⍝ rectangle using any pair of corners from the nx2
⍝ matrix x
∇ y ← maxrect x
  y ← ⌈/∊(1⊂x) ∘.{×/1+|⍺-⍵}1⊂x
∇

⍝ solution
∇ y ← aoc9a f
  y ← maxrect readprob f
∇

⍞←"\r"
⍞←aoc9a 'aoc9_testdata.txt'
⍞←"\n"
⍞←aoc9a 'aoc9_data.txt'
⍞←"\n"

)OFF
