;
; Chapter 2 of The Little Schemer:
; Do It, Do It Again, and Again, and Again ...
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We need to define atom? for Scheme as it's not a primitive, it is in Shrew though ;
;                                                                                   ;
; (define atom?                                                                     ;
;  (lambda (x)                                                                      ;
;     (and (not (pair? x)) (not (null? x)))))                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; lat? function finds if all the elements in the list are atoms
; (lat stands for list of atoms)
;
(define lat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))
    
; Examples of lats:
;
(lat? '(Jack Sprat could eat no chicken fat))
(lat? '())
(lat? '(bacon and eggs))

; Examples of not-lats:
;
(lat? '((Jack) Sprat could eat no chicken fat)) ; not-lat because (car l) is a list
(lat? '(Jack (Sprat could) eat no chicken fat)) ; not-lat because l contains a list
(lat? '(bacon (and eggs)))                      ; not-lat because '(and eggs) is a list

; Examples of or:
;
(or (null? '()) (atom? '(d e f g)))             ; true
(or (null? '(a b c)) (null? '()))               ; true
(or (null? '(a b c)) (null? '(atom)))           ; false

; member? function determines if an element is in a lat (list of atoms)
;
(define member?
  (lambda (a lat)
    (cond
      ((null? lat) #f)
      (else (or (eq? (car lat) a)
                (member? a (cdr lat)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The first commandment (preliminary)                                        ;
;                                                                            ;
; Always ask /null?/ as the first question in expressing any function.       ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of member? succeeding
;
(member? 'meat '(mashed potatoes and meat gravy))
(member? 'meat '(potatoes and meat gravy))
(member? 'meat '(and meat gravy))
(member? 'meat '(meat gravy))

; Examples of member? failing
(member? 'liver '(bagels and lox))
(member? 'liver '())

;
; Chapter 3 of The Little Schemer:
; Cons the Magnificent
;

; The rember function removes the first occurance of the given atom from the
; given list.
;
(define rember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a) (cdr lat))
      (else (cons (car lat)
                  (rember a (cdr lat)))))))

; Examples of rember function
;
(rember 'mint '(lamb chops and mint flavored mint jelly)) ; '(lamb chops and flavored mint jelly)
(rember 'toast '(bacon lettuce and tomato))               ; '(bacon lettuce and tomato)
(rember 'cup '(coffee cup tea cup and hick cup))          ; '(coffee tea cup and hick cup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The second commandment                                                     ;
;                                                                            ;
; Use /cons/ to build lists.                                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The firsts function builds a list of first s-expressions
;
(define firsts
  (lambda (l)
    (cond
      ((null? l) '())
      (else
        (cons (car (car l)) (firsts (cdr l)))))))

; Examples of firsts
;
(firsts '((apple peach pumpkin)
          (plum pear cherry)
          (grape raisin pea)
          (bean carrot eggplant)))                     ; '(apple plum grape bean)

(firsts '((a b) (c d) (e f)))                          ; '(a c e)
(firsts '((five plums) (four) (eleven green oranges))) ; '(five four eleven)
(firsts '(((five plums) four)
          (eleven green oranges)
          ((no) more)))                                ; '((five plums) eleven (no))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The third commandment                                                      ;
;                                                                            ;
; When building lists, describe the first typical element, and then /cons/   ;
; it onto the natural recursion.                                             ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The insertR function inserts the element new to the right of the first
; occurence of element old in the list lat
;
(define insertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons old (cons new (cdr lat))))
      (else
        (cons (car lat) (insertR new old (cdr lat)))))))

; Examples of insertR
;
(insertR
  'topping 'fudge
  '(ice cream with fudge for dessert)) ; '(ice cream with fudge topping for dessert)

(insertR
  'jalapeno
  'and
  '(tacos tamales and salsa))          ; '(tacos tamales and jalapeno salsa)

(insertR
  'e
  'd
  '(a b c d f g d h))                  ; '(a b c d e f g d h)

; The insertL function inserts the element new to the left of the first
; occurrence of element old in the list lat
;
(define insertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (cons old (cdr lat))))
      (else
        (cons (car lat) (insertL new old (cdr lat)))))))

; Example of insertL
;
(insertL
  'd
  'e
  '(a b c e g d h))                    ; '(a b c d e g d h)

; The subst function substitutes the first occurence of element old with new
; in the list lat
;
(define subst
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (cdr lat)))
      (else
        (cons (car lat) (subst new old (cdr lat)))))))

; Example of subst
;
(subst
  'topping
  'fudge
  '(ice cream with fudge for dessert)) ; '(ice cream with topping for dessert)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                 Go cons a piece of cake onto your mouth.                   ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The subst2 function substitutes the first occurence of elements o1 or o2
; with new in the list lat
;
(define subst2
  (lambda (new o1 o2 lat)
    (cond
      ((null? lat) '())
      ((or (eq? (car lat) o1) (eq? (car lat) o2))
       (cons new (cdr lat)))
      (else
        (cons (car lat) (subst new o1 o2 (cdr lat)))))))

; Example of subst2
;
(subst2
  'vanilla
  'chocolate
  'banana
  '(banana ice cream with chocolate topping))  ; '(vanilla ice cream with chocolate topping)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;       If you got the last function, go and repeat the cake-consing.        ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The multirember function removes all occurances of a from lat
;
(define multirember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a)
       (multirember a (cdr lat)))
      (else
        (cons (car lat) (multirember a (cdr lat)))))))

; Example of multirember
;
(multirember
  'cup
  '(coffee cup tea cup and hick cup))    ; '(coffee tea and hick)

; The multiinsertR function inserts the element new to the right of all
; occurences of element old in the list lat
;
(define multiinsertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons old (cons new (multiinsertR new old (cdr lat)))))
      (else
        (cons (car lat) (multiinsertR new old (cdr lat)))))))

; Example of multiinsertR
;
(multiinsertR
  'x
  'a
  '(a b c d e a a b))  ; (a x b c d e a x a x b)


; The multiinsertL function inserts the element new to the left of all
; occurences of element old in the list lat
;
(define multiinsertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (cons old (multiinsertL new old (cdr lat)))))
      (else
        (cons (car lat) (multiinsertL new old (cdr lat)))))))

; Example of multiinsertL
;
(multiinsertL
  'x
  'a
  '(a b c d e a a b))  ; (x a b c d e x a x a b)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fourth commandment (preliminary)                                       ;
;                                                                            ;
; Always change at least one argument while recurring. It must be changed to ;
; be closer to termination. The changing argument must be tested in the      ;
; termination condition: when using cdr, test the termination with null?.    ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The multisubst function substitutes all occurence of element old with new
; in the list lat
;
(define multisubst
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (multisubst new old (cdr lat))))
      (else
        (cons (car lat) (multisubst new old (cdr lat)))))))

; Example of multisubst
;
(multisubst
  'x
  'a
  '(a b c d e a a b))  ; (x b c d e x x b)

;
; Chapter 4 of The Little Schemer:
; Numbers Games
;

; Assume add1 is a primitive
;
(define add1
  (lambda (n) (+ n 1)))

; Example of add1
;
(add1 67)       ; 68

; Assume sub1 is a primitive
;
(define sub1
  (lambda (n) (- n 1)))

; Example of sub1
;
(sub1 5)        ; 5

; Example of zero?
;
(define zero?
  (lambda (n) (= 0 n)))
(zero? 0)       ; true
(zero? 1492)    ; false

; The o-plus function adds two numbers
;
(define o-plus
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (add1 (o-plus n (sub1 m)))))))

; Example of o-plus
;
(o-plus 46 12)      ; 58

; The o-minus function subtracts one number from the other
;
(define o-minus
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (sub1 (o-minus n (sub1 m)))))))

; Example of o-minus
;
(o-minus 14 3)       ; 11
(o-minus 17 9)       ; 8

; Examples of tups (tup is short for tuple)
;
'(2 111 3 79 47 6)
'(8 55 5 555)
'()

; Examples of not-tups
;
'(1 2 8 apple 4 3)      ; not-a-tup because apple is not a number
'(3 (7 4) 13 9)         ; not-a-tup because (7 4) is a list of numbers, not a number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The first commandment (first revision)                                     ;
;                                                                            ;
; When recurring on a list of atoms, lat, ask two questions about it:        ;
; (null? lat) and else.                                                      ;
; When recurring on a number, n, ask two questions about it: (zero? n) and   ;
; else.                                                                      ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The addtup function adds all numbers in a tup
;
(define addtup
  (lambda (tup)
    (cond
      ((null? tup) 0)
      (else (o-plus (car tup) (addtup (cdr tup)))))))

; Examples of addtup
;
(addtup '(3 5 2 8))     ; 18
(addtup '(15 6 7 12 3)) ; 43

; The o-mul function multiplies two numbers
;
(define o-mul
  (lambda (n m)
    (cond
      ((zero? m) 0)
      (else (o-plus n (o-mul n (sub1 m)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fourth commandment (first revision)                                    ;
;                                                                            ;
; Always change at least one argument while recurring. It must be changed to ;
; be closer to termination. The changing argument must be tested in the      ;
; termination condition:                                                     ;
; when using cdr, test the termination with null? and                        ;
; when using sub1, test termination with zero?.                              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of o-mul
;
(o-mul 5 3)                ; 15
(o-mul 13 4)               ; 52

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fifth commandment                                                      ;
;                                                                            ;
; When building a value with o-plus, always use 0 for the value of the           ;
; terminating line, for adding 0 does not change the value of an addition.   ;
;                                                                            ;
; When building a value with o-mul, always use 1 for the value of the           ;
; terminating line, for multiplying by 1 does not change the value of a      ;
; multiplication.                                                            ;
;                                                                            ;
; When building a value with cons, always consider () for the value of the   ;
; terminating line.                                                          ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The tup-plus function adds two tups
;
(define tup-plus
  (lambda (tup1 tup2)
    (cond
      ((null? tup1) tup2)
      ((null? tup2) tup1)
      (else
        (cons (o-plus (car tup1) (car tup2))
              (tup-plus (cdr tup1) (cdr tup2)))))))

; Examples of tup-plus
;
(tup-plus '(3 6 9 11 4) '(8 5 2 0 7))   ; '(11 11 11 11 11)
(tup-plus '(3 7) '(4 6 8 1))            ; '(7 13 8 1)

; The o-greater function compares n with m and returns true if n>m
;
(define o-greater
  (lambda (n m)
    (cond
      ((zero? n) #f)
      ((zero? m) #t)
      (else
        (o-greater (sub1 n) (sub1 m))))))

; Examples of o-greater
;
(o-greater 12 133)     ; #f (false)
(o-greater 120 11)     ; #t (true)
(o-greater 6 6)        ; #f

; The o-less function compares n with m and returns true if n<m
;
(define o-less
  (lambda (n m)
    (cond
      ((zero? m) #f)
      ((zero? n) #t)
      (else
        (o-less (sub1 n) (sub1 m))))))

; Examples of o-less
;
(o-less 4 6)        ; #t
(o-less 8 3)        ; #f
(o-less 6 6)        ; #f

; The o-eq function compares n with m and returns true if n=m
;
(define o-eq
  (lambda (n m)
    (cond
      ((o-greater n m) #f)
      ((o-less n m) #f)
      (else #t))))

; Examples of o-eq
;
(o-eq 5 5)        ; #t
(o-eq 1 2)        ; #f

; The o-pow function computes n^m
;
(define o-pow
  (lambda (n m)
    (cond 
      ((zero? m) 1)
      (else (o-mul n (o-pow n (sub1 m)))))))

; Examples of o-pow
;
(o-pow 1 1)        ; 1
(o-pow 2 3)        ; 8
(o-pow 5 3)        ; 125

; The o-div function computes the integer part of n/m
;
(define o-div
  (lambda (n m)
    (cond
      ((o-less n m) 0)
      (else (add1 (o-div (o-minus n m) m))))))

; Example of o-div
;
(o-div 15 4)       ; 3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;         Wouldn't a '(ham and cheese on rye) be good right now?             ;
;                                                                            ;
;                    Don't forget the 'mustard!                              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The olength function finds the length of a lat
;
(define olength
  (lambda (lat)
    (cond
      ((null? lat) 0)
      (else (add1 (olength (cdr lat)))))))

; Examples of length
;
(olength '(hotdogs with mustard sauerkraut and pickles))     ; 6
(olength '(ham and cheese on rye))                           ; 5

; The pick function returns the n-th element in a lat
;
(define pick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (car lat))
      (else
        (pick (sub1 n) (cdr lat))))))

; Example of pick
;
(pick 4 '(lasagna spaghetti ravioli macaroni meatball))     ; 'macaroni

; The rempick function removes the n-th element and returns the new lat
;
(define rempick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (cdr lat))
      (else
        (cons (car lat) (rempick (sub1 n) (cdr lat)))))))

; Example of rempick
;
(rempick 3 '(hotdogs with hot mustard))     ; '(hotdogs with mustard)

; The no-minusnums function returns a new lat with all numbers removed
;
(define no-minusnums
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((number? (car lat)) (no-minusnums (cdr lat)))
      (else
        (cons (car lat) (no-minusnums (cdr lat)))))))

; Example of no-minusnums
;
(no-minusnums '(5 pears 6 prunes 9 dates))       ; '(pears prunes dates)

; The all-nums does the opposite of no-minusnums - returns a new lat with
; only numbers
;
(define all-nums
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((number? (car lat)) (cons (car lat) (all-nums (cdr lat))))
      (else
        (all-nums (cdr lat))))))

; Example of all-nums
;
(all-nums '(5 pears 6 prunes 9 dates))       ; '(5 6 9)


; The eqan? function determines whether two arguments are te same
; It uses eq? for atoms and = for numbers
;
(define eqan?
  (lambda (a1 a2)
    (cond
      ((and (number? a1) (number? a2)) (= a1 a2))
      ((or  (number? a1) (number? a2)) #f)
      (else
        (eq? a1 a2)))))

; Examples of eqan?
;
(eqan? 3 3)     ; #t
(eqan? 3 4)     ; #f
(eqan? 'a 'a)   ; #t
(eqan? 'a 'b)   ; #f

; The occur function counts the number of times an atom appears
; in a list
;
(define occur
  (lambda (a lat)
    (cond
      ((null? lat) 0)
      ((eq? (car lat) a)
       (add1 (occur a (cdr lat))))
      (else
        (occur a (cdr lat))))))

; Example of occur
;
(occur 'x '(a b x x c d x))     ; 3
(occur 'x '())                  ; 0

; The one? function is true when n=1
;
(define one?
  (lambda (n) (= n 1)))

; Example of one?
;
(one? 5)        ; #f
(one? 1)        ; #t

; We can rewrite rempick using one?
;
(define rempick-one
  (lambda (n lat)
    (cond
      ((one? n) (cdr lat))
      (else
        (cons (car lat) (rempick-one (sub1 n) (cdr lat)))))))

; Example of rempick-one
;
(rempick-one 4 '(hotdogs with hot mustard))     ; '(hotdogs with mustard)
