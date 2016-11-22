lambda_length = 
  \ ls -> if null ls 
     then 0
      else 1 + lambda_length(tail ls)
