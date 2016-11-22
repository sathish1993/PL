rev1 :: [a] -> [a]
rev1 [] = []
rev1 (x:xs) = rev1 xs ++ [x]

rev2 :: [a] -> [a]
rev2 xs = rev2Aux [] xs
   where rev2Aux acc [] = acc
         rev2Aux acc (x:xs) = rev2Aux (x:acc) xs
