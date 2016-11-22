posInts1  :: [Integer] -> [Bool]
posInts1 xs = map test xs
              where test x = x > 0

posInts2  :: [Integer] -> [Bool]
posInts2 xs = map (> 0) xs

posInts3  :: [Integer] -> [Bool]
posInts3 = map (> 0)


