#!/opt/homebrew/bin/apl -s -f

⍝ read battery file into a nested array of strings
∇ y ← readbat f
  y ← ⎕FIO['read_text'] f
∇

⍝ calulate the joltage from one battery bank
∇ y ← bankjoltage b; i; j
  i ← 1↑⍒¯1↓b
  j ← i + 1↑⍒i↓b
  y ← ⍎b[i,j]
∇

⍝ calculate the total joltage from the battery
∇ y ← joltage b
  y ← +/⊃bankjoltage ¨ b
∇

⍝ the solution
∇ y ← aoc3a f
  y ← joltage readbat f
∇

⍞←"\r"
⍞←aoc3a 'aoc3_testdata.txt'
⍞←"\n"
⍞←aoc3a 'aoc3_data.txt'
⍞←"\n"

)OFF

  
