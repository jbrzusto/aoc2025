#!/opt/homebrew/bin/apl -s -f

∇ n ← aoc1b f; x 
x ← ⊃ (⎕FIO['read_text'] f)
n ← +/0=100|50++\(⍎,(0 1↓x),' ')/(¯1+2×('R'=x[;1]))
∇

aoc1b 'aoc1_testdata.txt'
aoc1b 'aoc1_data.txt'

)off

