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

⍝ remove returns a boolean matrix with the same shape as m from
⍝ which all accessible 1 cells have been removed (i.e. changed to 0)
∇ y ← remove m
  y ← m ∧ ~ accessible m
∇

⍝ removeall repeatedly applies remove to matrix m until no
⍝ further removals are possible
∇ y ← removeall m
  y ← m
loop:
  m ← remove m
  →(m ≡ y)⍴0
  y ← m
  →loop
∇

⍝ solution:
∇ y ← aoc4b f; g
  g ← '@' readgrid f
  y ← (+/,g) - (+/,removeall g)
∇

⍞←"\r"
⍞←aoc4b 'aoc4_testdata.txt'
⍞←"\n"
⍞←aoc4b 'aoc4_data.txt'
⍞←"\n"

)OFF

  
