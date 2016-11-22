(define (iter-fib n)
  (letrec
    ([iter-fib-aux
      (lambda (acc0 acc1 i n)
	(if (> i n) 
	    acc1
	    (iter-fib-aux acc1 (+ acc0 acc1)
			  (+ i 1) n)))])
    (if (< n 2)
        n
        (iter-fib-aux 0 1 2 n))))
        
