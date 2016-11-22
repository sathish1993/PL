;;-*- mode: scheme; -*-
;; :set filetype=scheme

;;Return a 2-element list containing the 2 roots of the quadratic
;;equation a*x^2 + b*x + c = 0 using the classical formula for the
;;roots of a quadratic equation.  The first element in the returned list
;;should use the positive square-root of the discriminant, the second
;;element should use the negative square-root of the discriminant.
(define (quadratic-roots a b c)
  (let ([sqrt-discr (sqrt (- (* b b) (* 4 a c)))]
	[twice-a (* 2 a)]
	[minus-b (- b)])
    (list (/ (+ minus-b sqrt-discr) twice-a)
	  (/ (- minus-b sqrt-discr) twice-a))))

;;Return the list resulting by multiplying each element of `list` by `x`.
(define (mul-list list x)
  (if (null? list)
      '()
      (cons (* x (car list)) (mul-list (cdr list) x))))


;;Given a proper-list list of proper-lists, return the sum of the
;;lengths of all the contained lists.
(define (sum-lengths list)
  (if (null? list)
      0
      (+ (length (car list)) (sum-lengths (cdr list)))))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x.  The computation should reflect the traditional
;;representation of the polynomial.
(define (poly-eval coeffs x)
  (if (null? coeffs)
      0
      (+ (* (car coeffs) (expt x (- (length coeffs) 1))) 
	 (poly-eval (cdr coeffs) x))))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x using Horner's method.
(define (poly-eval-horner coeffs x)
  (letrec ([aux-horner (lambda (coeffs x)
			 (if (null? coeffs)
			     0
			     (+ (car coeffs) 
				(* x (aux-horner (cdr coeffs) x)))))])
    (aux-horner (reverse coeffs) x)))

;;Return count of occurrences equal? to x in exp
(define (count-occurrences exp x)
  (letrec ([aux-count (lambda (exp x acc)
			(cond
			  [(equal? exp x) (+ acc 1)]
			  [(pair? exp) 
			   (aux-count (cdr exp) x 
				      (aux-count (car exp) x acc))]
			   [else acc]))])
    (aux-count exp x 0)))

;;Return result of evaluating arith expression over Scheme numbers
;;with fully parenthesized prefix binary operators 'add, 'sub, 'mul
;;and 'div.
(define (eval-arith exp)
  (if (number? exp)
      exp
      (let ([op (car exp)]
	    [left (eval-arith (cadr exp))]
	    [right (eval-arith (caddr exp))])
	(cond [(equal? 'add op) (+ left right)]
	      [(equal? 'sub op) (- left right)]
	      [(equal? 'mul op) (* left right)]
	      [(equal? 'div op) (/ left right)]))))

;;Given a proper-list list of proper-lists, return sum of lengths of
;;all the contained lists.  Must be tail-recursive.
(define (sum-lengths-tr list)
  (letrec ([aux-len (lambda (list acc)
		      (if (null? list)
			  acc
			  (aux-len (cdr list) (+ acc (length (car list))))))])
    (aux-len list 0)))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x.  Must be tail-recursive.
(define (poly-eval-tr coeffs x)
  (letrec ([aux-eval (lambda (coeffs x pow-acc acc)
		       (if (null? coeffs)
			   acc
			   (aux-eval (cdr coeffs) x (* x pow-acc) 
				     (+ (* pow-acc (car coeffs)) acc))))])
    (if (equal? (length coeffs) 0)
	0
	(let ([rev-coeffs (reverse coeffs)])
	  (aux-eval (cdr rev-coeffs) x x (car rev-coeffs))))))

;;Return the list resulting by multiplying each element of `list` by `x`.
;;Cannot use recursion, can use one or more of `map`, `foldl`, or `foldr`.
(define (mul-list-2 list x)
  (map (lambda (l) (* l x)) list))

;;Given a proper-list list of proper-lists, return the sum of the
;;lengths of all the contained lists.  Cannot use recursion, can use
;;one or more of `map`, `foldl`, or `foldr`.
(define (sum-lengths-2 list)
  (foldl + 0 (map length list)))

		     
