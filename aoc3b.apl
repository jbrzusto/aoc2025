#!/opt/homebrew/bin/apl -s -f

⍝ read battery file into a nested array of strings
∇ y ← readbat f
  y ← ⎕FIO['read_text'] f
∇

⍝ calulate the joltage from one battery bank; i.e. the largest n-digit
⍝ number formed from the string of digits in b, where those n digits
⍝ have to be selected in order from left to right, and from distinct
⍝ slots in b.  The number is returned as a string, giving its digits
⍝ from left to right.
⍝ bankjoltage selects the digits from left to right, recursively.
∇ y ← n bankjoltage b; i
  y←''
  →(n=0)↑0
  i ← 1↑⍒(-n-1)↓b
  y←b[i], (n-1) bankjoltage i↓b
∇

⍝ calculate the total joltage from the battery
⍝ when n cells per bank are turned on
∇ y ← n joltage b
  y ← +/⊃⍎¨ n bankjoltage ¨ b
∇

⍝ the solution: read a battery file and find the
⍝ 12-cell joltage.
∇ y ← aoc3b f
  y ← 12 joltage readbat f
∇

⍞←"\r"
⍞←aoc3b 'aoc3_testdata.txt'
⍞←"\n"
⍞←aoc3b 'aoc3_data.txt'
⍞←"\n"

)OFF

  
