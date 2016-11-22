(define (my-map f ls) 
  (if (null? ls)
      ls
      (cons (f (car ls)) (my-map f (cdr ls)))))
