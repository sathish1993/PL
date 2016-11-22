data Tree a
  = Leaf a
  | InternalNode (Tree a) a (Tree a)

sumTree :: Tree Int -> Int
sumTree (Leaf value) = value
sumTree (InternalNode left v right) = 
  sumTree left + v + sumTree right
