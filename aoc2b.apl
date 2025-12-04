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

⍝ istuplet checks whether x is a 'tuplet' i.e. whether its digits are
⍝ the concatenation of at least two copies of another (shorter)
⍝ sequence of digits, y.  A single number n is a tuplet if (and only
⍝ if) it belongs to one of several finite arithmetic sequences,
⍝ generated from a base, a multiplier and a maximum index (i.e. number
⍝ of multipliers added to the base)

⍝ Because we are working with numbers having at most 12 digits,
⍝ we simplify the code by pre-computing a matrix m with these three columns:
⍝ - column 1 is a base
⍝ - column 2 is a multiplier
⍝ - column 3 is 1 + the max index
⍝ Each row of this matrix represents a finite arithmetic sequence of
⍝ tuplets having the same number of digits repeated.
⍝ A number x is a tuplet if for some row i,
⍝ x ≥ m[i;1] ∧ 0=m[i;2]|(x-m[i;1]) ∧ (x-m[i;1])÷m[i;2]<m[i;3]
⍝ i.e. x is at least as large as the first row element, differs from
⍝ it by an integer multiple of the second element, but that multiple
⍝ must be smaller than the third element.

seqmat ← """
          11           11      9
         111          111      9
        1111         1111      9
       11111        11111      9
      111111       111111      9
     1111111      1111111      9
    11111111     11111111      9
   111111111    111111111      9
  1111111111   1111111111      9
 11111111111  11111111111      9
111111111111 111111111111      9
        1010          101     90
      101010        10101     90
    10101010      1010101     90
  1010101010    101010101     90
101010101010  10101010101     90
      100100         1001    900
   100100100      1001001    900
100100100100   1001001001    900
    10001000        10001   9000
100010001000    100010001   9000
  1000010000       100001  90000
100000100000      1000001 900000
"""

⍝ parse and reshape the above text literal as an n×3 matrix
seqmat ← ⊃⍎¨seqmat

⍝ istuplet checks whether each number in x is a tuplet.
⍝ It is very inefficient, since it checks the number
⍝ against *every* row of seqmat.
∇ y ← istuplet x
  y←∨/(x∘.≥seqmat[;1]) ∧ (0=(⍉seqmat[;(⍴x)⍴2])|x∘.-seqmat[;1]) ∧ ((⍉seqmat[;(⍴x)⍴3])>(x∘.-seqmat[;1])÷(⍉seqmat[;(⍴x)⍴2]))
∇
⍝ x tupletsum y computes the sum of tuplet numbers
⍝ in the range x...y inclusive
∇ z ← x tupletsum y; r
  r ← (x - 1) + ⍳1 + y - x
  z ← +/(istuplet r)/r
∇

⍝ x tuplets y lists the tuplet numbers in the range
⍝ x...y inclusive.  This is used for testing.
∇ z ← x tuplets y; r
  r ← (x - 1) + ⍳1 + y - x
  z ← (istuplet r)/r
∇

⍝ the solution function reads a file of ranges and
⍝ computes the sum of the tuplet numbers that lie in
⍝ at least one of those ranges.
∇ y←aoc2b f; x
  x←overlaps readseq f
  y←+/x[;1] tupletsum¨ x[;2] 
∇
      
⍞←"\r"
⍞←aoc2b 'aoc2_testdata.txt'
⍞←"\n"
⍞←aoc2b 'aoc2_data.txt'
⍞←"\n"

)OFF

