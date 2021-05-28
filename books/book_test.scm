(define add1
  (lambda (n) (+ n 1)))
(define sub1
  (lambda (n) (- n 1)))
(define o+
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (add1 (o+ n (sub1 m)))))))