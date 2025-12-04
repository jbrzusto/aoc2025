#!/opt/homebrew/bin/apl -s -f

⍝ read file into an nx2 matrix of ranges, sorted by start, end values
∇ y ← readseq f; x; n 
  x ← ⍎(2 2⍴', - ')⎕MAP(⎕FIO['read_file'] f)
  n ← 0.5 × ⍴x
  y ← (n, 2)⍴x
  y ← y[⍋y;]
∇

⍝ merge overlaps in sorted nx2 matrix of ranges
∇ y ← overlaps x; n; m; f; t
  m←(1↓,x[;1])∘.< (¯1↓,x[;2])
  n←1↑⍴x
  f←x[((⍳n)=1,2++⌿m)/⍳n;1]
  t←x[((⍳n)=(1++⌿m),n)/⍳n;2]
  n←⍴f
  y←((n, 1)⍴f),(n,1)⍴t
∇

⍝ nd is the number of digits in integer x
∇ y ← nd x
  y←1+⌊10⍟x
∇

⍝ ndt is the number of digits in the largest twin
⍝ number ≤ x
∇ y ← ndt x
  y←nd x
  y←y-x < +/10*¯1+(y,y÷2)
∇

⍝ twingen returns a generator for the twin numbers
⍝ with 2x digits where x ≥ 1 (any lower x is taken as 1)
⍝ This is a vector of three numbers:
⍝ y[1]: the first twin number with n digits
⍝ y[2]: the increment between twin numbers with n digits
⍝ y[3]: the number of n-digit twin numbers
⍝ In other words, the twin numbers with x digits
⍝ are given by y[1], y[1]+y[2], y[1]+2y[2], ..., y[1]+(y[3]-1)y[2]
∇ y ← twingen x; a; b; c
  x←1⌈x
  b←1+10*⌈x
  a←b×10*¯1+⌊x
  c←9×10*¯1+⌊x
  y←a,b,c
∇

⍝ twinceil is the smallest twin number ≥ x
∇ y←twinceil x
  g←twingen ⌈.5 × nd x
  y←g,g[1] + g[2] × (g[3]-1) ⌊ 0 ⌈ ⌈ (x-g[1])÷g[2]
∇

⍝ twinceilgen is a twin generator concatenated with the
⍝ index of the smallest twin number ≥ x
∇ y←twinceilgen x; g
  g←twingen ⌈.5 × nd x
  y←g,(g[3]-1) ⌊ 0 ⌈ ⌈ (x-g[1])÷g[2]
∇

⍝ twinfloor is the largest twin number ≤ x
∇ y←twinfloor x; g
  g←twingen ⌊.5× nd x
  y←g,g[1] + g[2] × (g[3]-1) ⌊ 0 ⌈ ⌊ (x-g[1])÷g[2]
∇

⍝ twinfloorgen is a generator concatenated with the index
⍝ for the largest twin number ≤ x
∇ y←twinfloorgen x; g
  g←twingen ⌊.5× ndt x
  y←g,(g[3]-1) ⌊ 0 ⌈ ⌊ (x-g[1])÷g[2]
∇

⍝ twinsum gives the sum of the twin numbers t
⍝ in the range x[1]...x[2], where x[1] ≤ x[2]
⍝ it can handle the case where x[1] and x[2]
⍝ don't have the same number of digits.
⍝ if x[1] > x[2], 0 is returned
∇ y←twinsum x; g1; g2; sum
  g1←twinceilgen x[1]
  g2←twinfloorgen x[2]
  sum←0
loop:
  →(g1[1]≥g2[1])⍴last
  sum←sum+(1+g1[3]-g1[4])×.5×(g1[1]+g1[2]×g1[4])+(g1[1]+g1[2]×g1[3]-1)
  ⎕←sum
  g1←twinceilgen 1+g1[1]+g1[2]*(g1[3]-1)
  →loop
last:
  sum←sum+(g2[1]=g1[1])×(g2[4]≥g1[4])×(1+g2[4]-g1[4])×g1[1]+g1[2]×.5×(g2[4]+g1[4])
  y←sum
∇

∇ y←aoc2a f
  y←+/,twinsum ¨1 1 ⊂ overlaps readseq f
∇

⎕pp←15

⍞←"\r"
⍞←aoc2a 'aoc2_testdata.txt'
⍞←"\n"
⍞←aoc2a 'aoc2_data.txt'
⍞←"\n"

)OFF

