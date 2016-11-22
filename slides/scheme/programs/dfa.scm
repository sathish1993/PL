(define (simulate dfa input)	     ;@1@
  (cons (car dfa)		     ;start state
	(if (null? input)
	    (if (infinal? dfa) '(accept) 
		'(reject))
	    (simulate (move dfa (car input)) 
		      (cdr input)))))

(define (infinal? dfa)
    (memq (car dfa) (caddr dfa)))
;@2@

(define (move dfa symbol)		;@3@
  (let ((curstate (car dfa)) 
	(trans (cadr dfa)) 
	(finals (caddr dfa)))
    (list
     (if (eq? curstate 'error)
	 'error
	 (let 
             ((pair (assoc (list curstate symbol) 
			   trans)))
	   (if pair (cadr pair) 'error)))
     trans
     finals)))
;@4@

(simulate
 '(q0                           ;start state
   (((q0 0) q2) ((q0 1) q1)     ;transitions 
    ((q1 0) q3) ((q1 1) q0)  
    ((q2 0) q0) ((q2 1) q3)
    ((q3 0) q1) ((q3 1) q2))
   (q0))                        ;final state
 '(0 1 1 0 1))

