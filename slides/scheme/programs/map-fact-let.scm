(define (map-fact-let ls)
  (let ([fact1
	 (lambda (n)
	   (if (< n 1)
	       1
	       (* n (fact1 (- n 1)))))])
    (map fact1 ls)))
