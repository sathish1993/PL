numsFrom :: Int -> [Int]
numsFrom n = n : numsFrom (n+1)

squares :: [Int]
squares = map (^2) (numsFrom 0)
