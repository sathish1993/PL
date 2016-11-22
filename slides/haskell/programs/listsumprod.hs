listSum, listProd :: [Float] -> Float
listSum xs = foldl (+) 0 xs
listProd xs = foldl (*) 1 xs
