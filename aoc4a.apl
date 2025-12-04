#!/opt/homebrew/bin/apl -s -f

⍝ read grid file into a boolean matrix with
⍝ 1 wherever the grid has character c, 0 elsewhere.
∇ y ← c readgrid f
  y ← c = ⊃ (⎕FIO['read_text'] f)
∇

⍝ neighbours calculates the number of neighbouring cells containing 1
⍝ for each cell in boolean matrix m
∇ y ← neighbours m
  m ← (m, 0)⍪0
  y← ¯1 ¯1 ↓ (-m) + ⊃ +/ , ¯1 0 1 ∘.⌽ ¯1 0 1 ∘.⊖ ⊂ m
∇

⍝ accessible returns a boolean matrix with the same shape as m which
⍝ is 1 only for cells which contain 1 and which also have fewer than 4
⍝ 1s in their (up to 8) neighbouring cells
∇ y ← accessible m
  y ← m ∧ 4 > neighbours m
∇

⍝ solution: # of accessible cells in the grid
⍝ found in file f
∇ y ← aoc4a f
  y ← +/,accessible '@' readgrid f
∇

⍞←"\r"
⍞←aoc4a 'aoc4_testdata.txt'
⍞←"\n"
⍞←aoc4a 'aoc4_data.txt'
⍞←"\n"

)OFF

  
