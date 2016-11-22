;;List length with error checking.
(define (err-length list) 
  (cond ((null? list) 0)
	((pair? list)
	 (if (integer? (err-length (cdr list)))
	     (+ 1 (err-length (cdr list)))
	     (err-length (cdr list))))
	(else "error")))
