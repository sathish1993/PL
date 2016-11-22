;;-*- mode: scheme; -*-
;; :set filetype=scheme

;;Return a 2-element list containing the 2 roots of the quadratic
;;equation a*x^2 + b*x + c = 0 using the classical formula for the
;;roots of a quadratic equation.  The first element in the returned list
;;should use the positive square-root of the discriminant, the second
;;element should use the negative square-root of the discriminant.
(define (quadratic-roots a b c)
 (list (/ (+ (- b) (sqrt (- (* b b) (* a c 4)))) (* a 2))
       (/ (- (- b) (sqrt (- (* b b) (* a c 4)))) (* a 2))))
	

;;Return the list resulting by multiplying each element of `list` by `x`.
(define (mul-list l x)
(if (null? l)
	'()
	(cons ( * x (car l))
		(mul-list (cdr l) x))))


;;Given a proper-list list of proper-lists, return the sum of the
;;lengths of all the contained lists.

(define (sum-lengths ls)
  (if (pair? ls)
      (cond
        [(list? (car ls))(+ (length (car ls)) (sum-lengths (cdr ls)))]
        [else 0])0))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x.  The computation should reflect the traditional
;;representation of the polynomial.
(define (poly-eval coeffs x)
  (if(null? coeffs)
     0
     (let ((n  (length coeffs)))
     (+ (* (car coeffs) (expt x (- n 1) )) (poly-eval (cdr coeffs) x)))
    ))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x using Horner's method.
(define (poly-eval-horner  coeffs x)
  (letrec ((poly-horner (lambda (coeffs n)
                          (if (null? coeffs)
                              n
                              (begin 
                              	(let ((n (+ (* n x) (car coeffs))))
                              	(+ (poly-horner (cdr coeffs) n)))
                              )))))
    (poly-horner coeffs 0)))

;;Return count of occurrences equal? to x in exp
(define (count-occurrences exp x)
(if (symbol? x)
  (begin
    (if (empty? exp) 0
        (begin
          (if(not (pair? exp))
             (begin
               (if (equal? x exp)
                   1 0))
          (+ (count-occurrences (car exp) x) (count-occurrences (cdr exp) x))
   ))))
  (begin
    (if (empty? exp) 0
        (begin
          (if (not(pair? exp)) 0
              (begin
                (if (equal? (car exp) x)
                    (begin
                      (+ 1
                         (count-occurrences (cdr exp) x)))
                    (+ (count-occurrences (car exp) x)
                       (count-occurrences (cdr exp) x))
        		))))))))

;;Return result of evaluating arith expression over Scheme numbers
;;with fully parenthesized prefix binary operators 'add, 'sub, 'mul
;;and 'div.
(define (eval-arith exp)
  (if(list? exp)
     (begin
     (cond [(equal? (car exp) 'add)
              (if (integer? (cadr exp))
                  (if (integer? (caddr exp))
                      (+ (cadr exp) (caddr exp))
                      (+ (cadr exp) (eval-arith (caddr exp))))
              (begin
                   (if (integer? (caddr exp))
                       (+ (eval-arith (cadr exp)) (caddr exp))
                       (+ (eval-arith (cadr exp)) (eval-arith (caddr exp)))))
              )]
           [(equal? (car exp) 'sub)
              (if (integer? (cadr exp))
                  (if (integer? (caddr exp))
                      (- (cadr exp) (caddr exp))
                      (- (cadr exp) (eval-arith (caddr exp))))
              (begin
                   (if (integer? (caddr exp))
                       (- (eval-arith (cadr exp)) (caddr exp))
                       (- (eval-arith (cadr exp)) (eval-arith (caddr exp)))))
              )]
           [(equal? (car exp) 'mul)
              (if (integer? (cadr exp))
                  (if (integer? (caddr exp))
                      (* (cadr exp) (caddr exp))
                      (* (cadr exp) (eval-arith (caddr exp))))
              (begin
                   (if (integer? (caddr exp))
                       (* (eval-arith (cadr exp)) (caddr exp))
                       (* (eval-arith (cadr exp)) (eval-arith (caddr exp)))))
              )]
           [(equal? (car exp) 'div)
              (if (integer? (cadr exp))
                  (if (integer? (caddr exp))
                      (/ (cadr exp) (caddr exp))
                      (/ (cadr exp) (eval-arith (caddr exp))))
              (begin
                   (if (integer? (caddr exp))
                       (/ (eval-arith (cadr exp)) (caddr exp))
                       (/ (eval-arith (cadr exp)) (eval-arith (caddr exp)))))
              )]
           ))
     0))

;;Given a proper-list list of proper-lists, return sum of lengths of
;;all the contained lists.  Must be tail-recursive.
(define (sum-lengths-tr ls)
  (letrec ((sum-tr (lambda (ls len)
                     (if (pair? ls)
                         (if(list? (car ls))
                            (sum-tr (cdr ls) (+ len (length (car ls))))
                            len)
                         len))))(sum-tr ls 0)))

;;Evaluate polynomial with list of coefficients coeffs (highest-order
;;first) at x.  Must be tail-recursive.
 (define (poly-eval-tr coeffs x)
  (letrec ((poly-tr (lambda (coeffs sum)
                      (cond ((null? coeffs)
                            sum)
                            (else
                             (poly-tr (cdr coeffs)
                                  (+ sum (* (car coeffs)
                                            (expt x (- (length coeffs) 1))))
                                  )))
           )))(poly-tr coeffs 0))) 

;;Return the list resulting by multiplying each element of `list` by `x`.
;;Cannot use recursion, can use one or more of `map`, `foldl`, or `foldr`.
(define (mul-list-2 ls x)
    (map (lambda (n) (* n x)) ls))

;;Given a proper-list list of proper-lists, return the sum of the
;;lengths of all the contained lists.  Cannot use recursion, can use
;;one or more of `map`, `foldl`, or `foldr`.
(define (sum-lengths-2 ls)
  (foldl (lambda (x sum)
                (+ sum (length x))
              )0 ls)) 
