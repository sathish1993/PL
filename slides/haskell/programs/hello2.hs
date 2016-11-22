nameToGreet name =
  "Hello " ++ name ++ "!"

hello2 =
  do 
    putStrLn "Hello, what's your name?"
    name <- getLine
    putStrLn $ nameToGreet name
