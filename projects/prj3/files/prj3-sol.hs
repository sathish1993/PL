import Data.List
import Debug.Trace

-- Problem 1
-- Return pair containing roots of quadratic equation a*x**2 + b*x + c.
-- The first element in the returned pair should use the positive 
-- square-root of the discriminant, the second element should use the 
-- negative square-root of the discriminant.  Need not handle complex
-- roots.
quadraticRoots :: Floating t => t -> t -> t -> (t, t)
quadraticRoots a b c = ( ((- b + sqrt (b * b - 4 * a * c)) / (2 * a) ), ( (- b - sqrt (b * b - 4 * a * c)) / (2 * a) ))

-- Problem 2
-- Return infinite list containing [z, f(z), f(f(z)), f(f(f(z))), ...]
-- May use recursion.
iterateFunction :: (a -> a) -> a -> [a]
iterateFunction f z = z : iterateFunction f (f z)

-- Problem 3
-- Using iterateFunction return infinite list containing 
-- multiples of n by all the non-negative integers.
-- May NOT use recursion.
multiples n = map (n *) (iterateFunction (\i-> i + 1 ) 0)  

-- Problem 4
-- Use iterateFunction to return an infinite list containing list 
-- of hailstone numbers starting with n.
-- Specifically, if i is a hailstone number, and i is even, then
-- the next hailstone number is i divided by 2; if i is a hailstone
-- number and i is odd, then the next hailstone number is 3*i + 1.
-- May NOT use recursion.
hailstones :: Integral a => a -> [a]
hailstones n = iterateFunction (\n -> if n `mod` 2 == 0
                                  then n `div` 2
                                   else 3 * n + 1) n 
  

-- Problem 5
-- Return length of hailstone sequence starting with n terminating
-- at the first 1.
-- May NOT use recursion.  Can use elemIndex from Data.List
hailstonesLen :: Integral a => a -> Int
hailstonesLen n = case elemIndex 1 (iterate (\n -> if n `mod` 2 == 0
                                     then n `div` 2
                                      else 3 * n + 1) n) of
                         Nothing -> 0
                         Just x -> x + 1

-- Problem 6
-- Given a list of numbers, return sum of the absolute difference
-- between consecutive elements of the list.
-- May NOT use recursion.
sumAbsDiffs :: Num a => [a] -> a
sumAbsDiffs numberList 
           | null numberList = 0
           | otherwise = foldl (+) 0 (map abs (zipWith (-) (tail numberList) numberList))

-- Problem 7
-- The x-y coordinate of a point is represented using the pair (x, y).
-- Return the list containing the distance of each point in list
-- points from point pt.
-- May NOT use recursion.
distances :: Floating b => (b, b) -> [(b, b)] -> [b]
distances pt points 
         | null points = []
         | otherwise =  [sqrt((fst pt - x1) ^ 2 + (snd pt - y1) ^ 2) | (x1,y1) <- points]   

-- Problem 8
-- Given a list of coordinate pairs representing points, return the
-- sum of the lengths of all line segments between successive 
-- adjacent points.
-- May NOT use recursion.
sumLengths :: Floating a => [(a, a)] -> a
sumLengths pointsList = sum [ sqrt((x2-x1) ^ 2 + (y2-y1) ^ 2) | ((x1,y1):(x2,y2):_) <- tails pointsList]

-- Problem 9
-- Given a string s and char c, return list of indexes in s where c
-- occurs
occurrences s c =  findIndices (==c) s

-- A tree of some type t is either a Leaf containing a value of type t,
-- or it is an internal node (with constructor Tree) with some left
-- sub-tree, a value of type t and a right sub-tree.
data Tree t = Leaf t
            | Tree (Tree t) t (Tree t)

-- Problem 10
-- Fold tree to a single value.  If tree is a Tree node, then it's
-- folded value is the result of applying ternary treeFn to the result
-- of folding the left sub-tree, the value stored in the Tree node and
-- the result of folding the right sub-tree; if it is a Leaf node,
-- then the result of the fold is the result of applying the unary
-- leafFn to the value stored within the Leaf node.
-- May use recursion.
foldTree :: (t1 -> t -> t1 -> t1) -> (t -> t1) -> Tree t -> t1
foldTree treeFn leafFn (Leaf t) = leafFn t
foldTree treeFn leafFn (Tree left x right) = treeFn (foldTree treeFn leafFn left) x (foldTree treeFn leafFn right)


-- Problem 11
-- Return list containing flattening of tree.  The elements of the
-- list correspond to the elements stored in the tree ordered as per 
-- an in-order traversal of the tree. Must be implemented using foldTree.
-- May NOT use recursion.
flattenTree :: Tree a -> [a]
flattenTree t  =  foldTree(\t1 t t2-> t1++[t]++t2) (\t->[t]) t

-- Problem 12
-- Given tree of type (Tree [t]) return list which is concatenation
-- of all lists in tree.
-- Must be implemented using flattenTree.
-- May NOT use recursion.
catenateTreeLists :: Tree [a] -> [a]
catenateTreeLists t = concat (flattenTree t)

