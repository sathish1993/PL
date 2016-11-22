-- Use with the -98 switch to hugs
-- By using a module, we get an ADT.  We cannot see inside the Stack at all.
-- All we can observe are the results of the operations.  So for example,
-- Stack> topOf (pop (push 1 (push 2 emptyStack)))
-- 2
-- Stack> (pop (push 1 (push 2 emptyStack))) == (push 2 emptyStack)
-- True
-- Stack> ((push 1 (push 2 emptyStack))) == (push 2 emptyStack)
-- False
-- Stack> 

module Stack where

type Stack a =
  [a] in emptyStack, push, pop, topOf, isEmpty

emptyStack:: Stack a
emptyStack = []

push:: a -> Stack a -> Stack a
push = (:)

pop:: Stack a -> Stack a
pop [] = error "pop: empty stack"
pop (a:as) = as

topOf:: Stack a -> a
topOp [] = error "topOf: empty stack"
topOf (a:as) = a

isEmpty:: Stack a -> Bool
isEmpty = null

instance Eq a => Eq (Stack a) where
  s1 == s2 | isEmpty s1 = isEmpty s2
           | isEmpty s2 = isEmpty s1
           | otherwise = topOf s1 == topOf s2 && pop s1 == pop s2

