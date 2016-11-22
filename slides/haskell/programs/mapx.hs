mapx f ls = 
  if (null ls) 
  then [] 
  else (f (head ls)) : map f (tail ls)
