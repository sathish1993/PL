(define (account init-balance)
  (let ((balance init-balance))
    (let ((deposit 
	   (lambda (amount) 
	     (set! balance (+ amount balance))
	     balance))
	  (withdraw
	   (lambda (amount)
	     (when (>= balance amount) 
		   (set! balance
			 (- balance amount)))
	     balance)))
      (list deposit withdraw))))


(define (deposit account)  ;@1@
  (car account))

(define (withdraw account)
  (cadr account))

