--selections :: [a] -> [(a, [a])]
selections [] = []
selections (x:xs) = 
  (x, xs) : 
  [ (z, x:zs) | (z, zs) <- selections(xs) ]

permutations [] = [[]]
permutations xs = 
  [ y:zs | 
   (y, ys) <- selections xs, 
   zs <- permutations ys ]
