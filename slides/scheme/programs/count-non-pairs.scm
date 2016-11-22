(define (count-non-pairs ls)
  (if (not (pair? ls))
      1
      (+ (count-non-pairs (car ls))
	    (count-non-pairs (cdr ls)))))
