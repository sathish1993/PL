data Edit
  = Change Char
  | Copy
  | Delete
  | Insert Char
  | Kill
  deriving (Eq, Show)

transform :: String -> String -> [Edit]

transform [] [] = []
transform string [] = [Kill]
transform [] string = map Insert string
transform (a:x) (b:y)
  | a == b =    Copy : transform x y
  | otherwise = 
     best [ Delete : transform x (b:y),
            Insert b : transform (a:x) y,
            Change b : transform x y ]

best :: [[Edit]] -> [Edit]
best [a] = a
best (a:x)
  | cost a <= cost b = a
  | otherwise        = b
    where b = best x

cost :: [Edit] -> Int
cost = length . filter (/=Copy)
