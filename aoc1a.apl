#!/opt/homebrew/bin/apl -s -f

∇ n ← aoc1a f; x 
x ← ⊃ (⎕FIO['read_text'] f)
n ← +/0=100|50++\(¯1+2×('R'=x[;1]))×⍎,(0 1↓x),' '
∇

aoc1a 'aoc1_testdata.txt'
aoc1a 'aoc1_data.txt'

)off

