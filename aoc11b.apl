#!/opt/homebrew/bin/apl -s -f

⍝ readprob returns a nested array
⍝ - the first element is a nested character vector
⍝   with each device name.
⍝ - the second element is a nested array where the n'th
⍝   element is a vector of integers giving the numbers
⍝   of the devices to which device n's outputs are attached
∇ y ← readprob f; n; m; a; b
  x ← ⎕FIO['read_text'] f
  n ← ({(¯1+⍵⍳':')↑⍵}¨x),⊂'out'
  m ← {a←' '=(⍵⍳':')↓⍵ ◊ b←+\a ◊ b[a/⍳⍴a] ← 0 ◊ n ⍳ b⊂(⍵⍳':')↓⍵}¨x
  y ← n (m,⊂0⍴0)
∇

⍝ npath is the number of paths from src to dst
⍝ n is assumed to be defined in the caller's environment
∇ y←src npath dst
  y ← ((⍴n)⍴0) rnpath (src, dst)
∇

⍝ rnpath is the recursive worker to find the number of paths from device d[1] to device d[2]
⍝ it assumes the edge map is in the variable e defined in the
⍝ caller's environment.  v is a boolean vector indicating which nodes
⍝ have been visited so far on the current search,
⍝ and is used to avoid cycles.  It is initially all zeroes.
⍝ memo is also assumed defined in the caller's environment, and memoizes
⍝ path counts.  It is initially all ¯1.
∇ y ← v rnpath d; nxt
  y ← memo[d[1];d[2]]
  →(y ≥ 0)/0
  y ← 1
  →(d[1]=d[2])/0
  v[d[1]] ← 1
  nxt ← d[1] ⊃ e
  nxt ← (~v[nxt])/nxt
  y ← +/{v rnpath ⍵,(d[2])} ¨ nxt
  memo[d[1];d[2]] ← y
∇

⍝ i maps a device name to an index
⍝ it assumes the name list n is defined
⍝ in the caller's environment
∇ y ← i x
  y ← n⍳⊂x
∇

⍝ the solution
∇ y ← aoc11b f; p; n; e; memo; m
  p ← readprob f
  n ← 1⊃p
  e ← 2⊃p
  y ← 0
  memo ← (2⍴⍴n)⍴¯1
  m ← ((i 'fft') npath i 'dac')
  →(m=0)/skip
  y ← y + ((i 'svr') npath i 'fft') × m × (i 'dac') npath i 'out'
skip:
  m ← ((i 'dac') npath i 'fft')
  →(m=0)/0
  y ← y + ((i 'svr') npath i 'dac') × m × (i 'fft') npath i 'out' 
∇



⍞←"\r"
⍞←aoc11b 'aoc11b_testdata.txt'
⍞←"\n"
⍞←aoc11b 'aoc11_data.txt'
⍞←"\n"

)OFF
