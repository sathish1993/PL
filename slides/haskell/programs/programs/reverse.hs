rev1 :: [a] -> [a]
rev1 [] = []
rev1 (x:xs) = rev1 xs ++ [x]

rev2 :: [a] -> [a]
rev2 xs = rev2Aux [] xs
          where rev2Aux acc [] = acc
                rev2Aux acc (x:xs) = rev2Aux (x:acc) xs

rev3:: [a] -> [a]
rev3 xs = foldl revOp [] xs
     	  where revOp acc x = x:acc

-- Using flip f x y = f y x defined in Prelude.
-- revOp acc x = flip (:) acc x
-- 2 applications of currying simplification: 
-- revOp = flip (:)
rev4 :: [a] -> [a]
rev4 = foldl (flip (:)) []

