(define (my-append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1)
	    (my-append (cdr list1) list2))))
