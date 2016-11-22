(define (rec-fib n)
  (if (< n 2) 
      n
      (+ (rec-fib (- n 1))
	 (rec-fib (- n 2)))))
