(define (fib n)
  (display "(fib ") (display n) (display ")\n")
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(define (memoize proc)
  (let ((memo '()))
    (lambda (arg) 
      (let ((v (lookup arg memo)))
	(if (null? v)
	    (let ((result (proc arg)))
	      (set! memo (cons (cons arg result) memo))
	      result
	      )
	    v)))))

(define (lookup key ls) 
  (let ((a (assoc key ls)))
    (if a (cdr a) '())))


(define fib-m (memoize fib))

(define fib-memo
  (memoize (lambda (n) 
	     (display "(fib-memo ") (display n) (display ")\n")
	     (if (< n 2)
		 n
		 (+ (fib-memo (- n 1)) (fib-memo (- n 2)))))))
