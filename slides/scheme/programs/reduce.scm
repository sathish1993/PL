(define (reduce ls z f)
  (if (null? ls)
      z
      (f (car ls) (reduce (cdr ls) z f))))
