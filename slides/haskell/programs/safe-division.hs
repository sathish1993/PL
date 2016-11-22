safe_division :: Float -> Float -> Maybe Float
safe_division x y 
  | y == 0 = Nothing
  | otherwise = Just (x/y)
