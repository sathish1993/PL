(define (my-flatten ls)
  (cond
   ((null? ls) '())
   ((pair? (car ls)) 
    (append (my-flatten (car ls))
	    (my-flatten (cdr ls))))
   (else (cons (car ls)
	       (my-flatten (cdr ls))))))
