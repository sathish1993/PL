(define (iter-fact n)
  (letrec ([aux-fact
	 (lambda (acc n)
	   (if (> n 1)
	       (aux-fact (* acc n) (- n 1))
	       acc))])
    (aux-fact 1 n)))


