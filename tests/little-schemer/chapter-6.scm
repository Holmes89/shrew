(define numbered?
  (lambda (aexp)
    (cond
      ((atom? aexp) (number? aexp))
      (else
        (and (numbered? (car aexp))
             (numbered? (car (cdr (cdr aexp)))))))))

(define value
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      ((eq? (car (cdr nexp)) 'o+)
       (+ (value (car nexp))
          (value (car (cdr (cdr nexp))))))
      ((eq? (car (cdr nexp)) 'o*)
       (* (value (car nexp))
          (value (car (cdr (cdr nexp))))))
      ((eq? (car (cdr nexp)) 'o^)
       (expt (value (car nexp))
             (value (car (cdr (cdr nexp))))))
      (else #f))))

(define value-prefix
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      ((eq? (car nexp) 'o+)
       (+ (value-prefix (car (cdr nexp)))
          (value-prefix (car (cdr (cdr nexp))))))
      ((eq? (car nexp) 'o*)
       (* (value-prefix (car (cdr nexp)))
          (value-prefix (car (cdr (cdr nexp))))))
      ((eq? (car nexp) 'o^)
       (expt (value-prefix (car (cdr nexp)))
             (value-prefix (car (cdr (cdr nexp))))))
      (else #f))))

(define 1st-sub-exp
  (lambda (aexp)
    (car (cdr aexp))))

(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

(define operator
  (lambda (aexp)
    (car aexp)))

(define value-prefix-helper
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      ((eq? (operator nexp) 'o+)
       (+ (value-prefix (1st-sub-exp nexp))
          (value-prefix (2nd-sub-exp nexp))))
      ((eq? (car nexp) 'o*)
       (* (value-prefix (1st-sub-exp nexp))
          (value-prefix (2nd-sub-exp nexp))))
      ((eq? (car nexp) 'o^)
       (expt (value-prefix (1st-sub-exp nexp))
             (value-prefix (2nd-sub-exp nexp))))
      (else #f))))

(define 1st-sub-exp
  (lambda (aexp)
    (car aexp)))

(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

(define operator
  (lambda (aexp)
    (car (cdr aexp))))

(define sero?
  (lambda (n)
    (null? n)))

(define edd1
  (lambda (n)
    (cons '() n)))

(define zub1
  (lambda (n)
    (cdr n)))

(define .+
  (lambda (n m)
    (cond
      ((sero? m) n)
      (else
        (edd1 (.+ n (zub1 m)))))))

(define tat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l))
       (tat? (cdr l)))
      (else #f))))