(define (lin-reverse list)
  (aux-reverse '() list))

(define (aux-reverse acc ls)
  (if (null? ls)
      acc
      (aux-reverse (cons (car ls) acc)
		   (cdr ls))))
