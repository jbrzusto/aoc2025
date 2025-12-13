#!/opt/homebrew/bin/apl -s -f

⍝ readprob returns a vector
⍝ with each element a nested array for one machine
⍝ (see parseprob)
∇ y ← readprob f
  y ← parseprob¨ (⎕FIO['read_text'] f) 
∇

⍝ parseprob parses a single problem line (for 1 machine)
⍝ and returns a nested vector with two elements:
⍝   (1) integer vector; gives the target values for each of the
⍝       counters
⍝   (2) boolean matrix; row i gives the pattern of counters
⍝       incremented by button i.

∇ y ← parseprob s; d; l; b; c
  s ← ⊃s
  d ← s ⍳ ']'
  l ← '#'=1↓(d-1)↑s
  s ← d↓s
  d ← s ⍳ '{'
  b ← 1 + ⍪¨⍎ (d-1)↑s
  b ← ⍉(⍳⍴l)∘.∊b
  c ← ⍎(d-1)↓s
  y ← (⊂c),(⊂b)
∇

⍝ greedy tries a greedy approach, working downward
⍝ from the target count by as large jumps as it can make.
⍝ At each stage, it examines the buttons which can
⍝ achieve the largest reduction in counter totals for a single
⍝ press.  It tries pressing each in turn and recursing,
⍝ to see whether a solution is possible.
⍝ We track the button count in
⍝ array btc, assumed defined in the initial caller's
⍝ environment.
⍝ b is the problem matrix, defined in the caller's environment.
⍝ c is the count of presses per button, defined in the caller's environment.
⍝ It should be 0, initially.
⍝ Quit as soon as a solution is found.
⍝ returns a number ≥ 10000 if no solution is found.
∇ y ← t greedy b; c
  c ← (1↑⍴b)⍴0
  ⍝ button weights
  bw ← +/b
  memox ← 1000000 ⍝ number of memoized values
  memo ← memox ⍴ ⊂'' ⍝ memoized keys; includes first one "0 0 ... 0"
  memo[1] ← ⊂(⍕ (1↓⍴b)⍴0) 
  memov ← memox ⍴ ¯1 ⍝ memoized values
  memov[1] ← 0 ⍝ optimum button presses for all-zero t
  memos ← 1 ⍝ number of memoized values so far
  ch ← 0 ⍝ number of cache hits
  y ← rgreedy t
  0⍴⎕EX 'memo'
  ⎕ ← y ' :' c 'memos:' memos 'hits:' ch 
∇

⍝ rgreedy is the recursive worker for greedy.  it accesses b (the
⍝ matrix), bw (the button weights) and c (the button push count) from
⍝ greedy's environment.
∇ y ← rgreedy t; key; i; j
skip:
  key ← ⍕t
  i ← memo⍳⊂key
  → (i>⍴memo)/nomem
  y ← memov[i]
  ch ← ch + 1
  →0
nomem:
  ⍝ which buttons can be "pressed" (i.e. have their press undone)?
  i ← (∧/((⍴b)⍴t)≥b)/⍳1↑⍴b
  y ← 10000
  → (0=⍴i)/0
  ⍝ sort in decreasing order of weight
  i ← i[⍒bw[i]]
  ⍝ loop over each of the feasible buttons
  j←1
loop:
  y ← 1 + rgreedy t - b[i[j];]
  → (y < 10000)/found
  j ← j + 1
  → (j ≤ ⍴i)/loop
  → done
found:
  c[i[j]] ← c[i[j]] + 1
done:
  → (memos≥memox)/0
  memos ← memos + 1
  memo[memos] ← ⊂key
  memov[memos] ← y
∇

⍝ solution
∇ y ← aoc10b f
  y ← +/{(1⊃⍵) greedy (2⊃⍵)} ¨ readprob f
∇

⍞←"\r"
⍞←aoc10b 'aoc10_testdata.txt'
⍞←"\n"
⍞←aoc10b 'aoc10_data.txt'
⍞←"\n"

)OFF
