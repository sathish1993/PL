fib1 :: [Int]
fib1 = 
  1 : 1 : [x+y | (x,y) <- zip fib1 (tail fib1)]

fib2 :: [Int]
fib2 = 
  1 : 1 : map (\(x,y) -> x+y) (zip fib2 (tail fib2))

fib3 :: [Int]
fib3 = 1 : 1 : zipWith (+) fib3 (tail fib3)
