(define (map-fact-letrec ls)
  (letrec
      ((fact
	(lambda (n)
	  (if (< n 1)
	      1
	      (* n (fact (- n 1)))))))
    (map fact ls)))
