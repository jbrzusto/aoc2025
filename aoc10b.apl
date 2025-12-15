#!/opt/homebrew/bin/apl -s -f

⍝ For this problem, the approach is gaussian reduction to reduce the
⍝ number of search space dimensions to the rank of the button/counter
⍝ matrix.  The free button counts are iterated through the range 0 to
⍝ their max possible (the smallest target value of a counter they
⍝ influence), and then the rest of the button counts are obtained by
⍝ backsolving the row-echelon matrix.
⍝
⍝ Beforehand, some simple reductions in the problem are attempted, one
⍝ of which merges buttons, so that the button/counter matrix is now
⍝ integer-valued, not simply boolean.  As you can see in apl10b.log,
⍝ none of these reductions was able to reduce the search space size by
⍝ much.
⍝
⍝ I'm sure there's a nice way to use the QR factorization provided by
⍝ the ⌹[2] function to do all this, but I didn't spend long trying to
⍝ find it.
⍝
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

⍝ the following reduction functions operate on the t, b, s, and np in
⍝ the caller's environment.  they return 1 if the reduction was
⍝ applied, 0 otherwise.  They all assume that t and b (still) have
⍝ more than one counter and more than one button.

⍝ dedupbuttons tries to find and remove a pair of duplicate buttons
∇ y ← dedupbuttons; nb; e; i
  y ← 0
  nb ← ,1↑⍴b
  e ← (⍳nb) ∘.{(⍺<⍵)∧b[⍺;]≡b[⍵;]} ⍳nb
  →(~1∊e)/0
  i ← 1 + (2 ⍴ nb) ⊤ ¯1+(∊e)⍳1
  ⍝ remove the button with the larger scale
  i ← i[1+0>-/s[i]]
  b ← (i≠⍳nb)⌿b
  s ← (i≠⍳⍴s)/s
  ⎕←'removed duplicate button' i
  y ← 1
∇

⍝ dedupcounters tries to fid and remove a pair of duplicate counters
⍝ (i.e. ones which are affected identically by all buttons)
∇ y ← dedupcounters ;e ;j
  y ← 0
  e ← (⍳⍴t) ∘.{(⍺<⍵)∧b[;⍺]≡b[;⍵]} ⍳⍴t
  →(~1∊e)/0
  ⍝ remove the last counter which duplicates an earlier one
  j ← ⌈/1 + (2⍴⍴t)⊤¯1+(∊e)⍳1
  b ← (j≠⍳⍴t)/b
  t ← (j≠⍳⍴t)/t
  ⎕←'removed duplicate counter' j
  y ← 1
∇

⍝ easycounter tries to find and remove an "easy" counter.
⍝ "easy" means the counter is affected by only one button,
⍝ so that by pressing the button the number of times corresponding
⍝ to the target for that counter, the part of the problem
⍝ can be immediately solved, and the button and counter removed.
⍝ returns 1 if an easycounter was found and removed.
∇ y ← easycounter ;j ;i; n
  y ← 0
  j ← (1=+⌿0≠b)/⍳⍴t
  → (0=⍴j)/0
  ⍝ use the first easycounter found
  j ← ,1↑j
  ⍝ index of button that affects this counter
  i ← (,0≠b[;j])/⍳1↑⍴b
  ⍝ number of presses of button i required to reduce
  ⍝ the target for counter j to 0.  If this is not an
  ⍝ integer, an error is thrown because the original
  ⍝ problem is not feasible.
  n ← t[j]÷b[i; j]
  ⎕ES (∨/n≠⌊n)/'problem has no integer solution'
  ⍝ do the presses
  np ← np + n×s[i]
  t ← t - n×,b[i;]
  ⍝ remove counter j
  t ← (j≠⍳⍴t)/t
  b ← (j≠⍳1↓⍴b)/b
  ⍝ remove button i
  s ← (i≠⍳⍴s)/s
  b ← (i≠⍳1↑⍴b)⌿b
  ⎕←'removed button' i 'and counter' j 'after zeroing'
∇

⍝ easybutton tries to find and remove an easy button.
⍝ A button is "easy" if there are two counters for which
⍝ it is the only button affecting them differently.
⍝ In that case, the difference in the counters' target
⍝ values is due entirely to presses of this button,
⍝ so we can press it the required number of times and
⍝ remove it from the problem.
∇ y ← easybutton; e; j; i; n
  y ← 0
  e ← (⍳⍴t) ∘.{(⍺<⍵)∧1=+/b[;⍺]≠b[;⍵]} ⍳⍴t
  →(~1∊e)/0
  j ← 1 + (2⍴⍴t)⊤¯1+(∊e)⍳1
  i ← (b[;j[1]]≠b[;j[2]])/⍳1↑⍴b
  ⍝ how many presses of button i will generate the difference
  ⍝ between the target values t[j[1]] and t[j[2]]?
  ⍝ if this value is negative or non-integer, the problem is
  ⍝ infeasible
  n ← (-/t[j]) ÷ -/b[i; j]
  ⎕ES (n < 0)/'problem does not have a positive-valued solution'
  ⎕ES (n≠⌊n)/'problem does not have an integer-valued solution'
  np ← np + n×s[i]
  t ← t - ,n × b[i;]
  b ← (i≠⍳1↑⍴b)⌿b
  s ← (i≠⍳⍴s)/s
  ⎕←'removed button' i 'due to it being the only difference between counters' j
  y ← 1
∇

⍝ easybuttonpair tries to find and remove an easy pair of buttons A
⍝ pair of buttons is "easy" if there is a pair of counters for which
⍝ those two buttons are the only ones having different effects on the
⍝ two counters, and the two buttons each increment precisely one
⍝ of the two counters, and by the same amount.

⍝ In that case, we can do a number of presses of one button to achieve
⍝ the difference in target values (if the other counter targets permit
⍝ it, otherwise the problem is infeasible) and then, because the
⍝ number of presses of the two buttons in any solution for the reduced
⍝ target value must be equal, we can merge the two buttons into one,
⍝ making the appropriate change in the scaling factor.

⍝ Returns 1 if an easy button pair was found.
∇ y ← easybuttonpair ;e ;jj ;j ;i ;dt ;u ;n
  y ← 0
  e ← (⍳⍴t) ∘.{(⍺<⍵)∧2=+/b[;⍺]≠b[;⍵]} ⍳⍴t
  ⍝ we need to loop over all pairs of these counters, because
  ⍝ not all of them necessarily lead to a reduction.  We use
  ⍝ the first pair that does, if there is one.
  jj ← (1=,e)/⍳⍴,e
loop:
  → (0=⍴jj)/0
  j ← ,1 + (2⍴⍴t)⊤¯1+1↑jj
  jj ← 1↓jj
  ⍝ the two buttons which affect these counters differently
  i ← (b[;j[1]]≠b[;j[2]])/⍳1↑⍴b
  → (0≠b[i[1];j[1]])/noswap
  ⍝ swap the i values so i[1] is the counter affected by
  ⍝ j[1]
  i ← ⌽i
  noswap:
  ⍝ the 2x2 matrix for these buttons and counters has to look
  ⍝ like  x 0    or   0  x
  ⍝       0 x         x  0
  ⍝ and x must divide evenly into difference in the target
  ⍝ values for the two counters.
  →(b[i[1];j[1]]≠b[i[2];j[2]])/loop
  →(b[i[2];j[1]]≠b[i[1];j[2]])/loop
  →(0≠×/b[i[1];j])/loop
  ⍝⎕←'found feasible easypair'
  ⍝ sort so that j[2] has the larger target value
  → (t[j[2]] ≥ t[j[1]]) / noswap2
  i←⌽i
  j←⌽j
noswap2:
  ⍝ difference in target values
  dt ← |-/t[j]
  ⍝ unit: change in target value per push of either button
  u ← ⌈/b[i; j[1]]
  ⍝ if the target difference is not divisible by
  ⍝ the unit, the problem is infeasible.
  ⎕ES(0≠u|dt)/'problem is infeasible (1)'
  n ← dt ÷ u
  ⍝ if trying to absorb the target value difference would
  ⍝ cause any of the other counter targets to be exceeded,
  ⍝ the problem isn't feasible
  ⍝⎕ES(∨/t<+n×b[i[2];])/'problem is infeasible (2)'
  → (~∨/t<+n×b[i[2];])/ok
  problem_infeasible
  ok:
  ⍝ absorb the difference in target values by pressing the
  ⍝ button for the larger target n times
  np ← np + n × s[i[2]]
  t ← t - n × b[i[2];]
  ⍝ any solution of the reduced problem requires equal numbers of
  ⍝ pushes of buttons i[1] and i[2], so merge them into a single button.
  b[i[1];] ← +⌿b[i;]
  b ← (i[2]≠⍳1↑⍴b)⌿b
  s[i[1]] ← +/s[i] 
  s ← (i[2]≠⍳⍴s)/s
  y ← 1
  ⎕←'merged buttons' i 'due to being the only differences between counters' j
∇
  
⍝ reduce simplifies the problem given by the variables
⍝ t and b in the caller's environment by repeatedly
⍝ applying a simplification rule until no further change is possible.
⍝ It returns the number of button pushes which must
⍝ be added to a solution of the reduced problem to
⍝ get the number of button pushes of a solution to the
⍝ original problem.
⍝ It also modifies the button scaler, because buttons in the reduced
⍝ problem can represent multiple buttons in the original problem.
⍝ So pressing button i in the reduced problem actually increases the
⍝ press count in the original problem by s[i].
⍝ The caller should set s←(1↑⍴b)⍴1
∇ np ← reduce ;ib
  np ← 0
loop:
  → (∨/1=⍴b)/done
  ⍝⎕←t b
  → dedupbuttons/loop
  → dedupcounters/loop
  → easycounter/loop
  → easybutton/loop
  → easybuttonpair/loop
done:
  → (0=+/t)/0
  → (1=1↑⍴b)/onebutton
  → (1=1↓⍴b)/onecounter
  → 0
onecounter:
  ⍝ only one counter left
  ⍝⎕←'one counter left with s=' s 'and t=' t 'and b=' b
  ⍝ which buttons which can drop the counter to zero?
  ib ← (0=t[1]|,b)/⍳,b
  ⍝ press the button with the lowest total cost
  np ← np + ⌊/(t[1]÷(ib/b))×ib/s
  t ← 0×t
  → 0
onebutton:
  ⎕ES (∨/0≠b[1;]|t)/'problem is infeasible (3)'
  ⎕ES (1≠⍴∪(t≠0)/t÷b[1;])/'problem is infeasible (4)'
  ⍝⎕←'one button left with s=' s 'and t=' t 'and b=' b
  np ← np + s[1]×t[1]÷b[1;1]
  t ← 0×t
∇

⍝ diag gets the diagonal elements of matrix m as a vector
∇ y ← diag m; n; j
  n ← ⌊/⍴m
  j ← 1+1↓⍴m
  y ← (,m)[1 + j×¯1+⍳n]
∇

⍝ gs does gaussian elimination on the system (⍉b)∘x = t to return the
⍝ augmented matrix in row-reduced echelon format. This is used by
⍝ function bs to backsolve for remaining variables when given values for the
⍝ free variables. This function sets varperm to a permutation vector which must
⍝ be applied to the original button count vector so that it corresponds
⍝ to the returned matrix m.
∇ m ← t gs b ;i ;ii ;imx ;j ;fv; rb
  m ← (⍉b),t
  i ← 1
  ii ← 1
  varperm ← ⍳¯1+1↓⍴m
loop:
  → (∨/(i,ii)>⍴m)/done
  imx ← ¯1+i+1↑⍒,|m[(i-1)↓⍳1↑⍴m; ii]
  → (imx=i)/noswap
  m[i, imx;] ← m[imx, i;]
  noswap:
  → (0≠m[i;ii])/ok
  ii ← ii + 1
  → loop
ok:
  m[i;] ← m[i;]÷m[i;ii]
  ⍝ zero out column ii of rows i+1
  j ← i
loop2:
  j ← j + 1
  → (∨/j>⍴m)/endloop2
  → (m[j; ii]=0)/loop2
  m[j;] ← m[j;] - (m[j;ii]÷m[i; ii]) × m[i;]
  ⍝ round to zero for values with small magnitudes
  ((1E¯7 > |m[j;])/m[j;])←0
  → loop2
endloop2:
  i ← i + 1
  ii ← ii + 1
  → loop
done:
  ⍝ re-order variables so the diagonals is all ones
  i ← 2
loop3:
  → (∨/i>⍴m)/0
  → (m[i; i] ≠ 0)/endloop3
  ii ← i + m[i; i↓⍳1↓⍴m]⍳1
  → (ii≥1↓⍴m)/endloop3
  m[; i, ii] ← m[; ii, i]
  varperm[i, ii] ← varperm[ii, i]
endloop3:
  i ← i + 1
  → loop3
  → 0
∇

⍝ bs backsolves for the first (1↑⍴b)-fv button push counts when given
⍝ counts for the rest.  bp is a vector of length 1↑⍴b whose entries
⍝ are zero except for the last fv of them.  m is the matrix returned by t gs b.
⍝ fv is the number of free variables, and must be set in the caller's
⍝ environment
∇ bp ← ibp bs m ;i ;n
  bp ← ibp
  n ← 1↓⍴m
  i ← (⍴bp) - fv
loop:
  → (i<1)/0
  bp[i] ← ((,m[i;n]) - +/(,m[i;i↓⍳¯1+n])×i↓bp)÷m[i;i]
  i ← i - 1
  → loop
∇

⍝ btnmax returns the maximum possible presses for each button, given
⍝ which counter targets they affect.
∇ y ← t btnmax b
  y ← {⌊/⌊((0≠b[⍵;])/t)÷(0≠b[⍵;])/b[⍵;]}¨⍳1↑⍴b
∇

⍝ iterbs uses iteration over the possible reduced solution space and
⍝ backsolving to get the best answer
⍝ We've hardcoded 0.00001 as the threshold below which a magnitude is treated
⍝ as zero.
∇ y ← iterbs m; nb; fv; rb; ps; lim; mx; i; soln; v 
  ⍝ number of buttons
  nb ← ¯1+1↓⍴m
  ⍝ number of free variables
  fv ← (nb-+/1=diag m)
  ⍝ rows of b corresponding to the free variables
  rb ← ((-fv),1↓⍴b)↑b
  ⎕←'==> freevars: ' fv
  y ← 1E6
  lim ← 1 + (-fv) ↑ (t btnmax b)[⍋varperm]
  mx ← ×/lim
  ⎕←'problem size' mx
  i ← 0
loop:
  → (i ≥ mx)/0
  bp ← nb⍴0
⍝  ⎕←'using ' (lim ⊤ i)
  ((-fv)↑bp) ← lim ⊤ i
  soln ← (bp bs m)[⍋varperm]
  ⎕ES (t≢,soln∘b)/'backsolved solution incorrect'
  → ((∨/soln < ¯.00001)∨(∨/.00001<|soln-⌊soln))/cont
  v ← soln +.× s
  → (v ≥ y)/cont
  y ← v
  bsoln ← soln
cont:
  i ← i + 1
  →loop
∇  

⍝ solve first looks for a unique or least-squares solution to the problem t=b∘x;
⍝ if it exists, it is the answer for the problem, because we can assume each
⍝ problem has an exact (not just least-squares) solution.
⍝ If not, the problem is under-determined, and solve attempts to first reduce
⍝ it to a simpler problem; if that alone doesn't yield a solution,
⍝ then it uses gs reduction and iteration with back-solving.
⍝ For all cases, it returns the total number of button pushes required.
∇ y ← solve p; t; b; s; x
  spc ← 1 + spc
  t ← 1⊃p
  b ← 2⊃p
  ⍝⎕←'==> subproblem' spc 'is ' t b
  'x←0⍴0' ⎕EA 'x←(⌹⍉b)∘t'
  → (0=⍴x)/notfound
  y ← ,+/,x
  → done
notfound:
  ⍝ scale factor for each button, needed as we
  ⍝ merge buttons
  s ← (1↑⍴b)⍴1
  y ← 0
  m ← t gs b
  unred ← iterbs m
  ⍝ reduce the problem, keeping track of button pushes and merging
  y ← , reduce
  ⍝ ⎕←'==> subproblem' spc 'result after reduce is ' y
  ⍝ we're done if the total of all remaining counter targets (if any) is 0
  →(0=+/t)/done

  ⍝ restore the problem
  ⍝ t ← 1⊃p
  ⍝ b ← 2⊃p
  ⍝ s ← (1↑⍴b)⍴1
  m ← t gs b
  y ← ∊y + iterbs m
  ⎕ES(y≠unred)/'gs and gs on reduce differ'
  ⍝ ⎕←'==> subproblem' spc 'running greedy on ' t b ' with s ' s
  ⍝ ⍝ run the greedy backtracker, which uses the button scaling vector s
  ⍝ y ← y + t greedy b
  ⍝ ⎕←'==> subproblem' spc 'result after greedy is ' y
done:
  ⎕←'DONE ' spc
∇

⍝ solution
∇ y ← aoc10b f
  ⍝ subproblem counter
  spc ← 0
  y ← + / ∊ solve ¨ readprob f
∇

⍞←"\r"
⍞←'===> grand total: ' (aoc10b 'aoc10_testdata.txt')
⍞←"\n"
gt ← (aoc10b 'aoc10_data.txt')
⍞←'===> grand total: ' gt
⍞←"\n"

)OFF
