;;Return length of a list.  
(define (my-length list)
  (if (pair? list) 
      (+ 1 (my-length (cdr list)))
      0))
