(define (let-length list)
  (cond ((null? list) 0)
	((pair? list)
	 (let ((cdr-length
		(let-length (cdr list)))) 
	   (if (integer? cdr-length)
	       (+ 1 cdr-length)
	       cdr-length)))
	(else "error")))
