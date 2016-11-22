listSum, listProd :: [Float] -> Float
listSum = foldl (+) 0 
listProd = foldl (*) 1
