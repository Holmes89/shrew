;
; Chapter 2 of The Little Schemer:
; Do It, Do It Again, and Again, and Again ...
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We need to define atom? for Scheme as it's not a primitive, it is in Shrew though              ;
;                                                                            ;
; (define atom?                                                                ;
;  (lambda (x)                                                                 ;
;     (and (not (pair? x)) (not (null? x)))))                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
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
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
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
(zero? 0)       ; true
(zero? 1492)    ; false

; The o+ function adds two numbers
;
(define o+
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (add1 (o+ n (sub1 m)))))))

; Example of o+
;
(o+ 46 12)      ; 58

; The o- function subtracts one number from the other
;
(define o-
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (sub1 (o- n (sub1 m)))))))

; Example of o-
;
(o- 14 3)       ; 11
(o- 17 9)       ; 8

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
      (else (o+ (car tup) (addtup (cdr tup)))))))

; Examples of addtup
;
(addtup '(3 5 2 8))     ; 18
(addtup '(15 6 7 12 3)) ; 43

; The o* function multiplies two numbers
;
(define o*
  (lambda (n m)
    (cond
      ((zero? m) 0)
      (else (o+ n (o* n (sub1 m)))))))

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

; Examples of o*
;
(o* 5 3)                ; 15
(o* 13 4)               ; 52

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fifth commandment                                                      ;
;                                                                            ;
; When building a value with o+, always use 0 for the value of the           ;
; terminating line, for adding 0 does not change the value of an addition.   ;
;                                                                            ;
; When building a value with o*, always use 1 for the value of the           ;
; terminating line, for multiplying by 1 does not change the value of a      ;
; multiplication.                                                            ;
;                                                                            ;
; When building a value with cons, always consider () for the value of the   ;
; terminating line.                                                          ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The tup+ function adds two tups
;
(define tup+
  (lambda (tup1 tup2)
    (cond
      ((null? tup1) tup2)
      ((null? tup2) tup1)
      (else
        (cons (o+ (car tup1) (car tup2))
              (tup+ (cdr tup1) (cdr tup2)))))))

; Examples of tup+
;
(tup+ '(3 6 9 11 4) '(8 5 2 0 7))   ; '(11 11 11 11 11)
(tup+ '(3 7) '(4 6 8 1))            ; '(7 13 8 1)

; The o> function compares n with m and returns true if n>m
;
(define o>
  (lambda (n m)
    (cond
      ((zero? n) #f)
      ((zero? m) #t)
      (else
        (o> (sub1 n) (sub1 m))))))

; Examples of o>
;
(o> 12 133)     ; #f (false)
(o> 120 11)     ; #t (true)
(o> 6 6)        ; #f

; The o< function compares n with m and returns true if n<m
;
(define o<
  (lambda (n m)
    (cond
      ((zero? m) #f)
      ((zero? n) #t)
      (else
        (o< (sub1 n) (sub1 m))))))

; Examples of o<
;
(o< 4 6)        ; #t
(o< 8 3)        ; #f
(o< 6 6)        ; #f

; The o= function compares n with m and returns true if n=m
;
(define o=
  (lambda (n m)
    (cond
      ((o> n m) #f)
      ((o< n m) #f)
      (else #t))))

; Examples of o=
;
(o= 5 5)        ; #t
(o= 1 2)        ; #f

; The o^ function computes n^m
;
(define o^
  (lambda (n m)
    (cond 
      ((zero? m) 1)
      (else (o* n (o^ n (sub1 m)))))))

; Examples of o^
;
(o^ 1 1)        ; 1
(o^ 2 3)        ; 8
(o^ 5 3)        ; 125

; The o/ function computes the integer part of n/m
;
(define o/
  (lambda (n m)
    (cond
      ((o< n m) 0)
      (else (add1 (o/ (o- n m) m))))))

; Example of o/
;
(o/ 15 4)       ; 3

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

; The no-nums function returns a new lat with all numbers removed
;
(define no-nums
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((number? (car lat)) (no-nums (cdr lat)))
      (else
        (cons (car lat) (no-nums (cdr lat)))))))

; Example of no-nums
;
(no-nums '(5 pears 6 prunes 9 dates))       ; '(pears prunes dates)

; The all-nums does the opposite of no-nums - returns a new lat with
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

;
; Chapter 5 of The Little Schemer:
; *Oh My Gawd*: It's Full of Stars
;

; The rember* function removes all matching atoms from an s-expression
;
(define rember*
  (lambda (a l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) a)
          (rember* a (cdr l)))
         (else
           (cons (car l) (rember* a (cdr l))))))
      (else
        (cons (rember* a (car l)) (rember* a (cdr l)))))))

; Examples of rember*
;
(rember*
  'cup
  '((coffee) cup ((tea) cup) (and (hick)) cup))
;==> '((coffee) ((tea)) (and (hick)))

(rember*
  'sauce
  '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce)))
;==> '(((tomato)) ((bean)) (and ((flying))))

; The insertR* function insers new to the right of all olds in l
;
(define insertR*
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) old)
          (cons old (cons new (insertR* new old (cdr l)))))
         (else
           (cons (car l) (insertR* new old (cdr l))))))
      (else
        (cons (insertR* new old (car l)) (insertR* new old (cdr l)))))))

; Example of insertR*
;
(insertR*
  'roast
  'chuck
  '((how much (wood)) could ((a (wood) chuck)) (((chuck)))
    (if (a) ((wood chuck))) could chuck wood))
; ==> ((how much (wood)) could ((a (wood) chuck roast)) (((chuck roast)))
;      (if (a) ((wood chuck roast))) could chuck roast wood)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The first commandment (final version)                                      ;
;                                                                            ;
; When recurring on a list of atoms, lat, ask two questions about it:        ;
; (null? lat) and else.                                                      ;
; When recurring on a number, n, ask two questions about it: (zero? n) and   ;
; else.                                                                      ;
; When recurring on a list of S-expressions, l, ask three questions about    ;
; it: (null? l), (atom? (car l)), and else.                                  ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fourth commandment (final version)                                     ;
;                                                                            ;
; Always change at least one argument while recurring. When recurring on a   ;
; list of atoms, lat, use (cdr l). When recurring on a number, n, use        ;
; (sub1 n). And when recurring on a list of S-expressions, l, use (car l)    ;
; and (cdr l) if neither (null? l) nor (atom? (car l)) are true.             ;
;                                                                            ;
; It must be changed to be closer to termination. The changing argument must ;
; be tested in the termination condition:                                    ;
; * when using cdr, test the termination with null? and                      ;
; * when using sub1, test termination with zero?.                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The occur* function counts the number of occurances of an atom in l
;
(define occur*
  (lambda (a l)
    (cond
      ((null? l) 0)
      ((atom? (car l))
       (cond
         ((eq? (car l) a)
          (add1 (occur* a (cdr l))))
         (else
           (occur* a (cdr l)))))
      (else
        (+ (occur* a (car l))
           (occur* a (cdr l)))))))

; Example of occur*
;
(occur*
  'banana
  '((banana)
    (split ((((banana ice)))
            (cream (banana))
            sherbet))
    (banana)
    (bread)
    (banana brandy)))
;==> 5

; The subst* function substitutes all olds for news in l
;
(define subst*
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) old)
          (cons new (subst* new old (cdr l))))
         (else
           (cons (car l) (subst* new old (cdr l))))))
      (else
        (cons (subst* new old (car l)) (subst* new old (cdr l)))))))

; Example of subst*
;
(subst*
  'orange
  'banana
  '((banana)
    (split ((((banana ice)))
            (cream (banana))
            sherbet))
    (banana)
    (bread)
    (banana brandy)))
;==> '((orange)
;      (split ((((orange ice)))
;              (cream (orange))
;              sherbet))
;      (orange)
;      (bread)
;      (orange brandy))

; The insertL* function insers new to the left of all olds in l
;
(define insertL*
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) old)
          (cons new (cons old (insertL* new old (cdr l)))))
         (else
           (cons (car l) (insertL* new old (cdr l))))))
      (else
        (cons (insertL* new old (car l)) (insertL* new old (cdr l)))))))

; Example of insertL*
;
(insertL*
  'pecker
  'chuck
  '((how much (wood)) could ((a (wood) chuck)) (((chuck)))
    (if (a) ((wood chuck))) could chuck wood))
; ==> ((how much (wood)) could ((a (wood) chuck pecker)) (((chuck pecker)))
;      (if (a) ((wood chuck pecker))) could chuck pecker wood)

; The member* function determines if element is in a list l of s-exps
;
(define member*
  (lambda (a l)
    (cond
      ((null? l) #f)
      ((atom? (car l))
       (or (eq? (car l) a)
           (member* a (cdr l))))
      (else
        (or (member* a (car l))
            (member* a (cdr l)))))))

; Example of member*
;
(member
  'chips
  '((potato) (chips ((with) fish) (chips))))    ; #t

; The leftmost function finds the leftmost atom in a non-empty list
; of S-expressions that doesn't contain the empty list
;
(define leftmost
  (lambda (l)
    (cond
      ((atom? (car l)) (car l))
      (else (leftmost (car l))))))

; Examples of leftmost
;
(leftmost '((potato) (chips ((with) fish) (chips))))    ; 'potato
(leftmost '(((hot) (tuna (and))) cheese))               ; 'hot

; Examples of not-applicable leftmost
;
; (leftmost '(((() four)) 17 (seventeen))) ; leftmost s-expression is empty
; (leftmost '())                           ; empty list

; Or expressed via cond
;
; (or a b) = (cond (a #t) (else b))

; And expressed via cond
;
; (and a b) = (cond (a b) (else #f))

; The eqlist? function determines if two lists are equal
;
(define eqlist?
  (lambda (l1 l2)
    (cond
      ; case 1: l1 is empty, l2 is empty, atom, list
      ((and (null? l1) (null? l2)) #t)
      ((and (null? l1) (atom? (car l2))) #f)
      ((null? l1) #f)
      ; case 2: l1 is atom, l2 is empty, atom, list
      ((and (atom? (car l1)) (null? l2)) #f)
      ((and (atom? (car l1)) (atom? (car l2)))
       (and (eq? (car l1) (car l2))
            (eqlist? (cdr l1) (cdr l2))))
      ((atom? (car l1)) #f)
      ; case 3: l1 is a list, l2 is empty, atom, list
      ((null? l2) #f)
      ((atom? (car l2)) #f)
      (else
        (and (eqlist? (car l1) (car l2))
             (eqlist? (cdr l1) (cdr l2)))))))
      

; Example of eqlist?
;
(eqlist?
  '(strawberry ice cream)
  '(strawberry ice cream))                  ; #t

(eqlist?
  '(strawberry ice cream)
  '(strawberry cream ice))                  ; #f

(eqlist?
  '(banan ((split)))
  '((banana) split))                        ; #f

(eqlist?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))          ; #f

(eqlist?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))         ; #t

; eqlist? rewritten
;
(define eqlist2?
  (lambda (l1 l2)
    (cond
      ((and (null? l1) (null? l2)) #t)
      ((or (null? l1) (null? l2)) #f)
      ((and (atom? (car l1)) (atom? (car l2)))
       (and (eq? (car l1) (car l2))
            (eqlist2? (cdr l1) (cdr l2))))
      ((or (atom? (car l1)) (atom? (car l2)))
       #f)
      (else
        (and (eqlist2? (car l1) (car l2))
             (eqlist2? (cdr l1) (cdr l2)))))))

; Tests of eqlist2?
;
(eqlist2?
  '(strawberry ice cream)
  '(strawberry ice cream))                  ; #t

(eqlist2?
  '(strawberry ice cream)
  '(strawberry cream ice))                  ; #f

(eqlist2?
  '(banan ((split)))
  '((banana) split))                        ; #f

(eqlist2?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))          ; #f

(eqlist2?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))         ; #t

; The equal? function determines if two s-expressions are equal
;
(define equal??
  (lambda (s1 s2)
    (cond
      ((and (atom? s1) (atom? s2))
       (eq? s1 s2))
      ((atom? s1) #f)
      ((atom? s2) #f)
      (else (eqlist? s1 s2)))))

; Examples of equal??
;
(equal?? 'a 'a)                              ; #t
(equal?? 'a 'b)                              ; #f
(equal?? '(a) 'a)                            ; #f
(equal?? '(a) '(a))                          ; #t
(equal?? '(a) '(b))                          ; #f
(equal?? '(a) '())                           ; #f
(equal?? '() '(a))                           ; #f
(equal?? '(a b c) '(a b c))                  ; #t
(equal?? '(a (b c)) '(a (b c)))              ; #t
(equal?? '(a ()) '(a ()))                    ; #t

; equal? simplified
;
(define equal2??
  (lambda (s1 s2)
    (cond
      ((and (atom? s1) (atom? s2))
       (eq? s1 s2))
      ((or (atom? s1) (atom? s2)) #f)
      (else (eqlist? s1 s2)))))

; Tests of equal2??
;
(equal2?? 'a 'a)                              ; #t
(equal2?? 'a 'b)                              ; #f
(equal2?? '(a) 'a)                            ; #f
(equal2?? '(a) '(a))                          ; #t
(equal2?? '(a) '(b))                          ; #f
(equal2?? '(a) '())                           ; #f
(equal2?? '() '(a))                           ; #f
(equal2?? '(a b c) '(a b c))                  ; #t
(equal2?? '(a (b c)) '(a (b c)))              ; #t
(equal2?? '(a ()) '(a ()))                    ; #t

; eqlist? rewritten using equal2??
;
(define eqlist3?
  (lambda (l1 l2)
    (cond
      ((and (null? l1) (null? l2)) #t)
      ((or (null? l1) (null? l2)) #f)
      (else
        (and (equal2?? (car l1) (car l2))
             (equal2?? (cdr l1) (cdr l2)))))))

; Tests of eqlist3?
;
(eqlist3?
  '(strawberry ice cream)
  '(strawberry ice cream))                  ; #t

(eqlist3?
  '(strawberry ice cream)
  '(strawberry cream ice))                  ; #f

(eqlist3?
  '(banan ((split)))
  '((banana) split))                        ; #f

(eqlist3?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))          ; #f

(eqlist3?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))         ; #t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The sixth commandment                                                      ;
;                                                                            ;
; Simplify only after the function is correct.                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; rember simplified, it now also works on s-expressions, not just atoms
;
(define rember
  (lambda (s l)
    (cond
      ((null? l) '())
      ((equal2?? (car l) s) (cdr l))
      (else (cons (car l) (rember s (cdr l)))))))

; Example of rember
;
(rember
  '(foo (bar (baz)))
  '(apples (foo (bar (baz))) oranges))
;==> '(apples oranges)

;
; Chapter 6 of The Little Schemer:
; Shadows
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; The atom? primitive
;
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

; The numbered? function determines whether a representation of an arithmetic
; expression contains only numbers besides the o+, ox and o^ (for +, * and exp).
;
(define numbered?
  (lambda (aexp)
    (cond
      ((atom? aexp) (number? aexp))
      ((eq? (car (cdr aexp)) 'o+)
       (and (numbered? (car aexp))
            (numbered? (car (cdr (cdr aexp))))))
      ((eq? (car (cdr aexp)) 'ox)
       (and (numbered? (car aexp))
            (numbered? (car (cdr (cdr aexp))))))
      ((eq? (car (cdr aexp)) 'o^)
       (and (numbered? (car aexp))
            (numbered? (car (cdr (cdr aexp))))))
      (else #f))))

; Examples of numbered?
;
(numbered? '5)                               ; #t
(numbered? '(5 o+ 5))                        ; #t
(numbered? '(5 o+ a))                        ; #f
(numbered? '(5 ox (3 o^ 2)))                 ; #t
(numbered? '(5 ox (3 'foo 2)))               ; #f
(numbered? '((5 o+ 2) ox (3 o^ 2)))          ; #t

; Assuming aexp is a numeric expression, numbered? can be simplified
;
(define numbered?
  (lambda (aexp)
    (cond
      ((atom? aexp) (number? aexp))
      (else
        (and (numbered? (car aexp))
             (numbered? (car (cdr (cdr aexp)))))))))

; Tests of numbered?
;
(numbered? '5)                               ; #t
(numbered? '(5 o+ 5))                        ; #t
(numbered? '(5 ox (3 o^ 2)))                 ; #t
(numbered? '((5 o+ 2) ox (3 o^ 2)))          ; #t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The seventh commandment                                                    ;
;                                                                            ;
; Recur on the subparts that are of the same nature:                         ;
; * On the sublists of a list.                                               ;
; * On the subexpressions of an arithmetic expression.                       ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The value function determines the value of an arithmetic expression
;
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

; Examples of value
;
(value 13)                                   ; 13
(value '(1 o+ 3))                            ; 4
(value '(1 o+ (3 o^ 4)))                     ; 82

; The value function for prefix notation
;
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

; Examples of value-prefix
;
(value-prefix 13)                            ; 13
(value-prefix '(o+ 3 4))                     ; 7
(value-prefix '(o+ 1 (o^ 3 4)))              ; 82

; It's best to invent 1st-sub-exp and 2nd-sub-exp functions
; instead of writing (car (cdr (cdr nexp))), etc.
; These are for prefix notation.
;
(define 1st-sub-exp
  (lambda (aexp)
    (car (cdr aexp))))

(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

; It's also best to invent operator function,
; instead of writing (car nexp), etc.
; This is for prefix notation
;
(define operator
  (lambda (aexp)
    (car aexp)))

; The new value function that uses helper functions
;
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

; Examples of value-prefix-helper
;
(value-prefix-helper 13)                            ; 13
(value-prefix-helper '(o+ 3 4))                     ; 7
(value-prefix-helper '(o+ 1 (o^ 3 4)))              ; 82

; Redefine helper functions for infix notation
;
(define 1st-sub-exp
  (lambda (aexp)
    (car aexp)))

(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

(define operator
  (lambda (aexp)
    (car (cdr aexp))))

; Examples of value-prefix-helper of infix notation expressions
;
(value-prefix 13)                            ; 13
(value-prefix '(o+ 3 4))                     ; 7
(value-prefix '(o+ 1 (o^ 3 4)))              ; 82

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The eighth commandment                                                     ;
;                                                                            ;
; Use help functions to abstract from representations.                       ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A different number representation:
; () for zero, (()) for one, (() ()) for two, (() () ()) for three, etc.
;

; sero? just like zero?
;
(define sero?
  (lambda (n)
    (null? n)))

; edd1 just like add1
;
(define edd1
  (lambda (n)
    (cons '() n)))

; zub1 just like sub1
;
(define zub1
  (lambda (n)
    (cdr n)))

; .+ just like o+
;
(define .+
  (lambda (n m)
    (cond
      ((sero? m) n)
      (else
        (edd1 (.+ n (zub1 m)))))))
    
; Example of .+
;
(.+ '(()) '(() ()))     ; (+ 1 2)
;==> '(() () ())

; tat? just like lat?
;
(define tat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l))
       (tat? (cdr l)))
      (else #f))))

; But does tat? work

(tat? '((()) (()()) (()()())))  ; (lat? '(1 2 3))
; ==> #f

; Beware of shadows.

;
; Chapter 7 of The Little Schemer:
; Friends and Relations
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; member function from Chapter 2 (02-do-it-again.ss)
;
(define member?
  (lambda (a lat)
    (cond
      ((null? lat) #f)
      (else (or (eq? (car lat) a)
                (member? a (cdr lat)))))))

; atom? function from Chapter 1 (01-toys.ss)
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

; Example of a set
;
'(apples peaches pears plums)

; Example of not a set
;
'(apple peaches apple plum)             ; because 'apple appears twice

; The set? function determines if a given lat is a set
;
(define set?
  (lambda (lat)
    (cond
      ((null? lat) #t)
      ((member? (car lat) (cdr lat)) #f)
      (else
        (set? (cdr lat))))))

; Examples of set?
;
(set? '(apples peaches pears plums))            ; #t
(set? '(apple peaches apple plum))              ; #f
(set? '(apple 3 pear 4 9 apple 3 4))            ; #f

; The makeset funciton takes a lat and produces a set
;
(define makeset
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((member? (car lat) (cdr lat)) (makeset (cdr lat)))
      (else
        (cons (car lat) (makeset (cdr lat)))))))

; Example of makeset
;
(makeset '(apple peach pear peach plum apple lemon peach))
; ==> '(pear plum apple lemon peach)

; makeset via multirember from Chapter 3 (03-cons-the-magnificent.ss)
;
(define multirember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a)
       (multirember a (cdr lat)))
      (else
        (cons (car lat) (multirember a (cdr lat)))))))

(define makeset
  (lambda (lat)
    (cond
      ((null? lat) '())
      (else
        (cons (car lat)
              (makeset (multirember (car lat) (cdr lat))))))))

; Test makeset
;
(makeset '(apple peach pear peach plum apple lemon peach))
; ==> '(apple peach pear plum lemon)

(makeset '(apple 3 pear 4 9 apple 3 4))
; ==> '(apple 3 pear 4 9)

; The subset? function determines if set1 is a subset of set2
;
(define subset?
  (lambda (set1 set2)
    (cond
      ((null? set1) #t)
      ((member? (car set1) set2)
       (subset? (cdr set1) set2))
      (else #f))))

; Examples of subset?
;
(subset? '(5 chicken wings)
         '(5 hamburgers 2 pieces fried chicken and light duckling wings))
; ==> #t

(subset? '(4 pounds of horseradish)
         '(four pounds of chicken and 5 ounces of horseradish))
; ==> #f

; A shorter version of subset?
;
(define subset?
  (lambda (set1 set2)
    (cond
      ((null? set1) #t)
      (else (and (member? (car set1) set2)
                 (subset? (cdr set1) set2))))))

; Tests of the new subset?
;
(subset? '(5 chicken wings)
         '(5 hamburgers 2 pieces fried chicken and light duckling wings))
; ==> #t

(subset? '(4 pounds of horseradish)
         '(four pounds of chicken and 5 ounces of horseradish))
; ==> #f

; The eqset? function determines if two sets are equal
;
(define eqset?
  (lambda (set1 set2)
    (and (subset? set1 set2)
         (subset? set2 set1))))

; Examples of eqset?
;
(eqset? '(a b c) '(c b a))          ; #t
(eqset? '() '())                    ; #t
(eqset? '(a b c) '(a b))            ; #f

; The intersect? function finds if two sets intersect
;
(define intersect?
  (lambda (set1 set2)
    (cond
      ((null? set1) #f)
      ((member? (car set1) set2) #t)
      (else
        (intersect? (cdr set1) set2)))))

; Examples of intersect?
;
(intersect?
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))
; ==> #t

(intersect?
  '(a b c)
  '(d e f))
; ==> #f

; A shorter version of intersect?
;
(define intersect?
  (lambda (set1 set2)
    (cond
      ((null? set1) #f)
      (else (or (member? (car set1) set2)
                (intersect? (cdr set1) set2))))))

; Tests of intersect?
;
(intersect?
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))
; ==> #t

(intersect?
  '(a b c)
  '(d e f))
; ==> #f

; The intersect function finds the intersect between two sets
;
(define intersect
  (lambda (set1 set2)
    (cond
      ((null? set1) '())
      ((member? (car set1) set2)
       (cons (car set1) (intersect (cdr set1) set2)))
      (else
        (intersect (cdr set1) set2)))))

; Example of intersect
;
(intersect
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))
; ==> '(and macaroni)

; The union function finds union of two sets
;
(define union
  (lambda (set1 set2)
    (cond
      ((null? set1) set2)
      ((member? (car set1) set2)
       (union (cdr set1) set2))
      (else (cons (car set1) (union (cdr set1) set2))))))

; Example of union
;
(union
  '(stewed tomatoes and macaroni casserole)
  '(macaroni and cheese))
; ==> '(stewed tomatoes casserole macaroni and cheese)

; The xxx function is the set difference function
;
(define xxx
  (lambda (set1 set2)
    (cond
      ((null? set1) '())
      ((member? (car set1) set2)
       (xxx (cdr set1) set2))
      (else
        (cons (car set1) (xxx (cdr set1) set2))))))

; Example of set difference
;
(xxx '(a b c) '(a b d e f))     ; '(c)

; The intersectall function finds intersect between multitude of sets
;
(define intersectall
  (lambda (l-set)
    (cond
      ((null? (cdr l-set)) (car l-set))
      (else
        (intersect (car l-set) (intersectall (cdr l-set)))))))

; Examples of intersectall
;
(intersectall '((a b c) (c a d e) (e f g h a b)))       ; '(a)
(intersectall
  '((6 pears and)
    (3 peaches and 6 peppers)
    (8 pears and 6 plums)
    (and 6 prunes with some apples)))                   ; '(6 and)

; The a-pair? function determines if it's a pair
;
(define a-pair?
  (lambda (x)
    (cond
      ((atom? x) #f)
      ((null? x) #f)
      ((null? (cdr x)) #f)
      ((null? (cdr (cdr x))) #t)
      (else #f))))

; Examples of pairs
;
(a-pair? '(pear pear))          ; #t
(a-pair? '(3 7))                ; #t
(a-pair? '((2) (pair)))         ; #t
(a-pair? '(full (house)))       ; #t

; Examples of not-pairs
(a-pair? '())                   ; #f
(a-pair? '(a b c))              ; #f

; Helper functions for working with pairs
;
(define first
  (lambda (p)
    (car p)))

(define second
  (lambda (p)
    (car (cdr p))))

(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 '()))))

; Just an example of how you'd write third
;
(define third
  (lambda (l)
    (car (cdr (cdr l)))))

; Example of a not-relations
;
'(apples peaches pumpkins pie)
'((apples peaches) (pumpkin pie) (apples peaches))

; Examples of relations
;
'((apples peaches) (pumpkin pie))
'((4 3) (4 2) (7 6) (6 2) (3 4))

; The fun? function determines if rel is a function
;
(define fun?
  (lambda (rel)
    (set? (firsts rel))))

; It uses firsts function from Chapter 3 (03-cons-the-magnificent.ss)
(define firsts
  (lambda (l)
    (cond
      ((null? l) '())
      (else
        (cons (car (car l)) (firsts (cdr l)))))))

; Examples of fun?
;
(fun? '((4 3) (4 2) (7 6) (6 2) (3 4)))     ; #f
(fun? '((8 3) (4 2) (7 6) (6 2) (3 4)))     ; #t
(fun? '((d 4) (b 0) (b 9) (e 5) (g 4)))     ; #f

; The revrel function reverses a relation
;
(define revrel
  (lambda (rel)
    (cond
      ((null? rel) '())
      (else (cons (build (second (car rel))
                         (first (car rel)))
                  (revrel (cdr rel)))))))

; Example of revrel
;
(revrel '((8 a) (pumpkin pie) (got sick)))
; ==> '((a 8) (pie pumpkin) (sick got))

; Let's simplify revrel by using inventing revpair that reverses a pair
;
(define revpair
  (lambda (p)
    (build (second p) (first p))))

; Simplified revrel
;
(define revrel
  (lambda (rel)
    (cond
      ((null? rel) '())
      (else (cons (revpair (car rel)) (revrel (cdr rel)))))))

; Test of simplified revrel
; 
(revrel '((8 a) (pumpkin pie) (got sick)))
; ==> '((a 8) (pie pumpkin) (sick got))

; The fullfun? function determines if the given function is full
;
(define fullfun?
  (lambda (fun)
    (set? (seconds fun))))

; It uses seconds helper function
;
(define seconds
  (lambda (l)
    (cond
      ((null? l) '())
      (else
        (cons (second (car l)) (seconds (cdr l)))))))

; Examples of fullfun?
;
(fullfun? '((8 3) (4 2) (7 6) (6 2) (3 4)))     ; #f
(fullfun? '((8 3) (4 8) (7 6) (6 2) (3 4)))     ; #t
(fullfun? '((grape raisin)
            (plum prune)
            (stewed prune)))                    ; #f

; one-to-one? is the same fullfun?
;
(define one-to-one?
  (lambda (fun)
    (fun? (revrel fun))))

(one-to-one? '((8 3) (4 2) (7 6) (6 2) (3 4)))     ; #f
(one-to-one? '((8 3) (4 8) (7 6) (6 2) (3 4)))     ; #t
(one-to-one? '((grape raisin)
               (plum prune)
               (stewed prune)))                    ; #f

(one-to-one? '((chocolate chip) (doughy cookie)))
; ==> #t and you deserve one now!

;
; Chapter 8 of The Little Schemer:
; Lambda the Ultimate
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; The atom? primitive
;
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

; The rember-f function takes the test function, element, and a list
; and removes the element that test true
;
(define rember-f
  (lambda (test? a l)
    (cond
      ((null? l) '())
      ((test? (car l) a) (cdr l))
      (else
        (cons (car l) (rember-f test? a (cdr l)))))))

; Examples of rember-f
;
(rember-f eq? 2 '(1 2 3 4 5))
; ==> '(1 3 4 5)

; The eq?-c function takes an atom and returns a function that
; takes an atom and tests if they are the same
;
(define eq?-c
  (lambda (a)
    (lambda (x)
      (eq? a x))))

; Example of eq?-c
;
((eq?-c 'tuna) 'tuna)       ; #t
((eq?-c 'tuna) 'salad)      ; #f

(define eq?-salad (eq?-c 'salad))

; Examples of eq?-salad
;
(eq?-salad 'salad)          ; #t
(eq?-salad 'tuna)           ; #f

; Another version of rember-f that takes test as an argument
; and returns a function that takes an element and a list
; and removes the element from the list
;
(define rember-f
  (lambda (test?)
    (lambda (a l)
      (cond
        ((null? l) '())
        ((test? (car l) a) (cdr l))
        (else
          (cons (car l) ((rember-f test?) a (cdr l))))))))

; Test of rember-f
;
((rember-f eq?) 2 '(1 2 3 4 5))
; ==> '(1 3 4 5)

; Curry (rember-f eq?)
;
(define rember-eq? (rember-f eq?))

; Test curried function
;
(rember-eq? 2 '(1 2 3 4 5))
; ==> '(1 3 4 5)
(rember-eq? 'tuna '(tuna salad is good))
; ==> '(salad is good)
(rember-eq? 'tuna '(shrimp salad and tuna salad))
; ==> '(shrimp salad and salad)
(rember-eq? 'eq? '(equal? eq? eqan? eqlist? eqpair?))
; ==> '(equal? eqan? eqlist? eqpair?)

; The insertL function from Chapter 3 (03-cons-the-magnificent.ss)
; This time curried
;
(define insertL-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((test? (car l) old)
         (cons new (cons old (cdr l))))
        (else
          (cons (car l) ((insertL-f test?) new old (cdr l))))))))

; Test insertL-f
;
((insertL-f eq?)
  'd
  'e
  '(a b c e f g d h))                  ; '(a b c d e f g d h)

; The insertR function, curried
;
(define insertR-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((test? (car l) old)
         (cons old (cons new (cdr l))))
        (else
          (cons (car l) ((insertR-f test?) new old (cdr l))))))))

; Test insertR-f
((insertR-f eq?)
  'e
  'd
  '(a b c d f g d h))                  ; '(a b c d e f g d h)

; The seqL function is what insertL does that insertR doesn't
;
(define seqL
  (lambda (new old l)
    (cons new (cons old l))))

; The seqR function is what insertR does that insertL doesn't
;
(define seqR
  (lambda (new old l)
    (cons old (cons new l))))

; insert-g acts as insertL or insertR depending on the helper
; function passed to it
;
(define insert-g
  (lambda (seq)
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((eq? (car l) old)
         (seq new old (cdr l)))
        (else
          (cons (car l) ((insert-g seq) new old (cdr l))))))))

; insertL is now just (insert-g seqL)
;
(define insertL (insert-g seqL))

; insertR is now just (insert-g seqR)
;
(define insertR (insert-g seqR))

; Test insertL
;
(insertL
  'd
  'e
  '(a b c e f g d h))                  ; '(a b c d e f g d h)

; Test insertR
(insertR
  'e
  'd
  '(a b c d f g d h))                  ; '(a b c d e f g d h)

; insertL can also be defined by passing it a lambda
;
(define insertL
  (insert-g
    (lambda (new old l)
      (cons new (cons old l)))))

; Test insertL
;
(insertL
  'd
  'e
  '(a b c e f g d h))                  ; '(a b c d e f g d h)

; The subst function from Chapter 3 (03-cons-the-magnificent.ss)
;
(define subst-f
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((eq? (car l) old)
       (cons new (cdr l)))
      (else
        (cons (car l) (subst new old (cdr l)))))))

; The seqS function is what subst does that neither insertL nor insertR do
;
(define seqS
  (lambda (new old l)
    (cons new l)))

; subst is now just (insret-g seqS)
;
(define subst (insert-g seqS))

; Test subst
;
(subst
  'topping
  'fudge
  '(ice cream with fudge for dessert)) ; '(ice cream with topping for dessert)

; Guess what yyy is
;
(define yyy
  (lambda (a l)
    ((insert-g seqrem) #f a l)))

; yyy uses seqrem
(define seqrem
  (lambda (new old l)
    l))

; It's rember! Let's test it.
;
(yyy
  'sausage
  '(pizza with sausage and bacon))      ; '(pizza with and bacon)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The ninth commandment                                                      ;
;                                                                            ;
; Abstract common patterns with a new function.                              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Remember the value function from Chapter 6 (06-shadows.ss)?
;
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

; Let's abstract it
;
(define atom-to-function
  (lambda (atom)
    (cond
      ((eq? atom 'o+) +)
      ((eq? atom 'o*) *)
      ((eq? atom 'o^) expt)
      (else #f))))

; atom-to-function uses operator
;
(define operator
  (lambda (aexp)
    (car aexp)))

; Example of atom-to-function
;
(atom-to-function (operator '(o+ 5 3)))     ; + (function plus)

; The value function rewritten to use abstraction
;
(define value
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      (else
        ((atom-to-function (operator nexp))
         (value (1st-sub-exp nexp))
         (value (2nd-sub-exp nexp)))))))

; value uses 1st-sub-exp
;
(define 1st-sub-exp
  (lambda (aexp)
    (car (cdr aexp))))

; value uses 2nd-sub-exp
(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

; Test value
;
(value 13)                                   ; 13
(value '(o+ 1 3))                            ; 4
(value '(o+ 1 (o^ 3 4)))                     ; 82

; The multirember function from Chapter 3 (03-cons-the-magnificent.ss)
;
(define multirember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a)
       (multirember a (cdr lat)))
      (else
        (cons (car lat) (multirember a (cdr lat)))))))

; The multirember-f is multirember with a possibility to curry f
;
(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
        ((null? lat) '())
        ((test? (car lat) a)
         ((multirember-f test?) a (cdr lat)))
        (else
          (cons (car lat) ((multirember-f test?) a (cdr lat))))))))

; Test multirember-f
;
((multirember-f eq?) 'tuna '(shrimp salad tuna salad and tuna))
; ==> '(shrimp salad salad and)

; Curry multirember-f with eq?
;
(define multirember-eq? (multirember-f eq?))

; The multiremberT changes the way test works
;
(define multiremberT
  (lambda (test? lat)
    (cond
      ((null? lat) '())
      ((test? (car lat))
       (multiremberT test? (cdr lat)))
      (else
        (cons (car lat)
              (multiremberT test? (cdr lat)))))))

; eq?-tuna tests if element is equal to 'tuna
;
(define eq?-tuna
  (eq?-c 'tuna))

; Example of multiremberT
;
(multiremberT
  eq?-tuna
  '(shrimp salad tuna salad and tuna))
; ==> '(shrimp salad salad and)

; The multiremember&co uses a collector
;
(define multiremember&co
  (lambda (a lat col)
    (cond
      ((null? lat)
       (col '() '()))
      ((eq? (car lat) a)
       (multiremember&co a (cdr lat)
       (lambda (newlat seen)
         (col newlat (cons (car lat) seen)))))
      (else
        (multiremember&co a (cdr lat)
                          (lambda (newlat seen)
                            (col (cons (car lat) newlat) seen)))))))

; The friendly function
;
(define a-friend
  (lambda (x y)
    (null? y)))

; Examples of multiremember&co with friendly function
;
(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  a-friend)
; ==> #f
(multiremember&co
  'tuna
  '()
  a-friend)
; ==> #t
(multiremember&co
  'tuna
  '(tuna)
  a-friend)
; ==> #f

; The new friend function
;
(define new-friend
  (lambda (newlat seen)
    (a-friend newlat (cons 'tuna seen))))

; Examples of multiremember&co with the new friend function
;
(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  new-friend)
; ==> #f
(multiremember&co
  'tuna
  '()
  new-friend)
; ==> #f
(multiremember&co
  'tuna
  '(tuna)
  new-friend)
; ==> #f

; The last friend function
;
(define last-friend
  (lambda (x y)
    (length x)))

; Examples of multiremember&co with the last friend function
;
(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  last-friend)
; ==> 3
(multiremember&co
  'tuna
  '()
  last-friend)
; ==> 0
(multiremember&co
  'tuna
  '(tuna)
  last-friend)
; ==> 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The tenth commandment                                                      ;
;                                                                            ;
; Build functions to collect more than one value at a time.                  ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The multiinsertLR inserts to the left and to the right of elements
;
(define multiinsertLR
  (lambda (new oldL oldR lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) oldL)
       (cons new
             (cons oldL
                   (multiinsertLR new oldL oldR (cdr lat)))))
      ((eq? (car lat) oldR)
       (cons oldR
             (cons new
                   (multiinsertLR new oldL oldR (cdr lat)))))
      (else
        (cons
          (car lat)
          (multiinsertLR new oldL oldR (cdr lat)))))))

; Example of multiinsertLR
;
(multiinsertLR
  'x
  'a
  'b
  '(a o a o b o b b a b o))
; ==> '(x a o x a o b x o b x b x x a b x o)

; The multiinsertLR&co is to multiinsertLR what multirember is to
; multiremember&co
;
(define multiinsertLR&co
  (lambda (new oldL oldR lat col)
    (cond
      ((null? lat)
       (col '() 0 0))
      ((eq? (car lat) oldL)
       (multiinsertLR&co new oldL oldR (cdr lat)
                         (lambda (newlat L R)
                           (col (cons new (cons oldL newlat))
                                (+ 1 L) R))))
      ((eq? (car lat) oldR)
       (multiinsertLR&co new oldL oldR (cdr lat)
                         (lambda (newlat L R)
                           (col (cons oldR (cons new newlat))
                                L (+ 1 R)))))
      (else
        (multiinsertLR&co new oldL oldR (cdr lat)
                          (lambda (newlat L R)
                            (col (cons (car lat) newlat)
                                 L R)))))))

; Some collectors
;
(define col1
  (lambda (lat L R)
    lat))
(define col2
  (lambda (lat L R)
    L))
(define col3
  (lambda (lat L R)
    R))

; Examples of multiinsertLR&co
;
(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col1)
; ==> '(chips salty and salty fish or salty fish and chips salty)
(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col2)
; ==> 2
(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col3)
; ==> 2

; The evens-only* function leaves all even numbers in an sexpression
; (removes odd numbers)
;
(define evens-only*
  (lambda (l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((even? (car l))
          (cons (car l)
                (evens-only* (cdr l))))
         (else
           (evens-only* (cdr l)))))
      (else
        (cons (evens-only* (car l))
              (evens-only* (cdr l)))))))

; Example of evens-only*
;
(evens-only*
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2))  ; '((2 8) 10 (() 6) 2)

; Evens only function with a collector, collects evens, their product,
; and sum of odd numbers
;
(define evens-only*&co
  (lambda (l col)
    (cond
      ((null? l)
       (col '() 1 0))
      ((atom? (car l))
       (cond
         ((even? (car l))
          (evens-only*&co (cdr l)
                          (lambda (newl p s)
                            (col (cons (car l) newl) (* (car l) p) s))))
         (else
           (evens-only*&co (cdr l)
                           (lambda (newl p s)
                             (col newl p (+ (car l) s)))))))
      (else
        (evens-only*&co (car l)
                        (lambda (al ap as)
                          (evens-only*&co (cdr l)
                                          (lambda (dl dp ds)
                                            (col (cons al dl)
                                                 (* ap dp)
                                                 (+ as ds))))))))))

; evens-friend returns collected evens
;
(define evens-friend
  (lambda (e p s)
    e))

; Example of evens-friend used
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-friend)
; ==> '((2 8) 10 (() 6) 2)

; evens-product-friend returns the product of evens
;
(define evens-product-friend
  (lambda (e p s)
    p))

; Example of evens-product-friend used
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-product-friend)
; ==> 1920

; evens-sum-friend returns the sum of odds
;
(define evens-sum-friend
  (lambda (e p s)
    s))

; Example of evens-sum-friend used
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-sum-friend)
; ==> 38

; the-last-friend returns sum, product and the list of evens consed together
;
(define the-last-friend
  (lambda (e p s)
    (cons s (cons p e))))

; Example of the-last-friend
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  the-last-friend)
; ==> '(38 1920 (2 8) 10 (() 6) 2)

;
; Chapter 8 of The Little Schemer:
; ...and Again, and Again, and Again, ...
;
; Code examples assemled by Jinpu Hu (hujinpu@gmail.com).
; His blog is at http://hujinpu.com  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;


; The pick function returns the n-th element in a lat
;
(define pick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (car lat))
      (else
        (pick (sub1 n) (cdr lat))))))

; Functions like looking are called partial functions.
;
(define looking
  (lambda (a lat)
    (keep-looking a (pick 1 lat) lat)))

; Example of looking
;
(looking 'caviar '(6 2 4 caviar 5 7 3))         ; #t
(looking 'caviar '(6 2 grits caviar 5 7 3))     ; #f

; It does not recur on a part of lat.
; It is truly unnatural.
;
(define keep-looking
  (lambda (a sorn lat)
    (cond
      ((number? sorn)
       (keep-looking a (pick sorn lat) lat))
      (else (eq? sorn a )))))

; It is the most partial function.
;
(define eternity
  (lambda (x)
    (eternity x)))

; Helper functions for working with pairs
;
(define first
  (lambda (p)
    (car p)))

(define second
  (lambda (p)
    (car (cdr p))))

(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 '()))))

; The function shift takes a pair whose first component is a pair 
; and builds a pair by shifting the second part of the first component
; into the second component
;
(define shift
  (lambda (pair)
    (build (first (first pair))
      (build (second (first pair))
        (second pair)))))

; Example of shift
;
(shift '((a b) c))                            ; '(a (b c))
(shift '((a b) (c d)))                        ; '(a (b (c d)))

; The a-pair? function determines if it's a pair
;
(define a-pair?
  (lambda (x)
    (cond
      ((atom? x) #f)
      ((null? x) #f)
      ((null? (cdr x)) #f)
      ((null? (cdr (cdr x))) #t)
      (else #f))))

; We first need to define atom? for Scheme as it's not a primitive
;
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x))))) 

; align is not a partial function, because it yields a value for every argument.
;
(define align
  (lambda (pora)
    (cond
      ((atom? pora) pora)
      ((a-pair? (first pora))
       (align (shift pora)))
      (else (build (first pora)
              (align (second pora)))))))

; counts the number of atoms in align's arguments
;
(define length*
  (lambda (pora)
    (cond
      ((atom? pora) 1)
      (else
        (+ (length* (first pora))
           (length* (second pora)))))))

(define weight*
  (lambda (pora)
    (cond
      ((atom? pora) 1)
      (else
        (+ (* (weight* (first pora)) 2)
           (weight* (second pora)))))))

; Example of weight*
;
(weight* '((a b) c))                          ; 7
(weight* '(a (b c))                           ; 5

; Let's simplify revrel by using inventing revpair that reverses a pair
;
(define revpair
  (lambda (p)
    (build (second p) (first p))))  

(define shuffle
  (lambda (pora)
    (cond
      ((atom? pora) pora)
      ((a-pair? (first pora))
       (shuffle (revpair pora)))
      (else
        (build (first pora)
          (shuffle (second pora)))))))

; Example of shuffle
;
(shuffle '(a (b c)))                          ; '(a (b c))
(shuffle '(a b))                              ; '(a b)
(shuffle '((a b) (c d)))                      ; infinite swap pora  Ctrl + c  to break and input q to exit

; The one? function is true when n=1
;
(define one?
  (lambda (n) (= n 1)))

; not total function
(define C
  (lambda (n)
    (cond
      ((one? n) 1)
      (else
        (cond
          ((even? n) (C (/ n 2)))
          (else
            (C (add1 (* 3 n)))))))))

(define A
  (lambda (n m)
    (cond
      ((zero? n) (add1 m))
      ((zero? m) (A (sub1 n) 1))
      (else
        (A (sub1 n)
           (A n (sub1 m)))))))

; Example of A
(A 1 0)                                       ; 2
(A 1 1)                                       ; 3
(A 2 2)                                       ; 7

; length0
;
(lambda (l)
  (cond
    ((null? l) 0)
    (else
      (add1 (eternity (cdr l))))))

; length<=1
;
(lambda (l)
  (cond
    ((null? l) 0)
    (else
      (add1
        ((lambda(l)
           (cond
             ((null? l) 0)
             (else
               (add1 (eternity (cdr l))))))
         (cdr l))))))

; All these programs contain a function that looks like length.
; Perhaps we should abstract out this function.

; rewrite length0
;
((lambda (length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))
 eternity)

; rewrite length<=1
;
((lambda (f)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1 (f (cdr l)))))))
 ((lambda (g)
    (lambda (l)
      (cond
        ((null? l) 0)
        (else (add1 (g (cdr l)))))))
  eternity))

; make length
;
(lambda (mk-length)
  (mk-length eternity))

; rewrite length<=1
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else
         (add1
           ((mk-length eternity) (cdr l))))))))

; It's (length '(1 2 3 4 5))
;
(((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else
         (add1
           ((mk-length mk-length) (cdr l))))))))
 '(1 2 3 4 5))

; 5


((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   ((lambda (length)
      (lambda (l)
        (cond
          ((null? l) 0)
          (else
            (add1 (length (cdr l)))))))
    (lambda (x)
      ((mk-length mk-length) x)))))

; move out length function
;
((lambda (le)
   ((lambda (mk-length)
      (mk-length mk-length))
    (lambda (mk-length)
      (le (lambda (x)
            ((mk-length mk-length) x))))))
 (lambda (length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1 (length (cdr l))))))))

; Y
;
(lambda (le)
  ((lambda (mk-length)
     (mk-length mk-length))
   (lambda (mk-length)
     (le (lambda (x)
           ((mk-length mk-length) x))))))

; it is called the applicative-order Y combinator.
;
(define Y
  (lambda (le)
    ((lambda (f) (f f))
     (lambda (f)
       (le (lambda (x) ((f f) x)))))))

;
; Chapter 10 of The Little Schemer:
; What Is the Value of All This?
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; We'll need atom?
;
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))  
  
; An entry is a pair of lists whose first list is a set. The two lists must be
; of equal length.
; Here are some entry examples.
;
'((appetizer entree bevarage)
  (pate boeuf vin))
'((appetizer entree bevarage)
  (beer beer beer))
'((bevarage dessert)
  ((food is) (number one with us)))

; Let's build entries with build from chapter 7 (07-friends-and-relations.ss)
;
(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 '()))))

(define new-entry build)

; Test it out and build the example entries above
;
(build '(appetizer entree bevarage)
       '(pate boeuf vin))
(build '(appetizer entree bevarage)
       '(beer beer beer))
(build '(bevarage dessert)
       '((food is) (number one with us)))

; We'll need first and second functions from chapter 7
;
(define first
  (lambda (p)
    (car p)))

(define second
  (lambda (p)
    (car (cdr p))))

; And also third, later.
;
(define third
  (lambda (l)
    (car (cdr (cdr l)))))

; The lookup-in-entry function looks in an entry to find the value by name
;
(define lookup-in-entry
  (lambda (name entry entry-f)
    (lookup-in-entry-help
      name
      (first entry)
      (second entry)
      entry-f)))

; lookup-in-entry uses lookup-in-entry-help helper function
;
(define lookup-in-entry-help
  (lambda (name names values entry-f)
    (cond
      ((null? names) (entry-f name))
      ((eq? (car names) name) (car values))
      (else
        (lookup-in-entry-help
          name
          (cdr names)
          (cdr values)
          entry-f)))))

; Let's try out lookup-in-entry
;
(lookup-in-entry
  'entree
  '((appetizer entree bevarage) (pate boeuf vin))
  (lambda (n) '()))
; ==> 'boeuf

(lookup-in-entry
  'no-such-item
  '((appetizer entree bevarage) (pate boeuf vin))
  (lambda (n) '()))
; ==> '()

; A table (also called an environment) is a list of entries. Here are some
; examples.
;
'()
'(((appetizer entree beverage) (pate boeuf vin))
  ((beverage dessert) ((food is) (number one with us))))

; The extend-table function takes an entry and a table and adds entry to the
; table
;
(define extend-table cons)

; lookup-in-table finds an entry in a table
;
(define lookup-in-table
  (lambda (name table table-f)
    (cond
      ((null? table) (table-f name))
      (else
        (lookup-in-entry
          name
          (car table)
          (lambda (name)
            (lookup-in-table
              name
              (cdr table)
              table-f)))))))

; Let's try lookup-in-table
;
(lookup-in-table
  'beverage
  '(((entree dessert) (spaghetti spumoni))
    ((appetizer entree beverage) (food tastes good)))
  (lambda (n) '()))
; ==> 'good

; Expressions to actions
;
(define expression-to-action
  (lambda (e)
    (cond
      ((atom? e) (atom-to-action e))
      (else
        (list-to-action e)))))

; Atom to action
;
(define atom-to-action
  (lambda (e)
    (cond
      ((number? e) *const)
      ((eq? e #t) *const)
      ((eq? e #f) *const)
      ((eq? e 'cons) *const)
      ((eq? e 'car) *const)
      ((eq? e 'cdr) *const)
      ((eq? e 'null?) *const)
      ((eq? e 'eq?) *const)
      ((eq? e 'atom?) *const)
      ((eq? e 'zero?) *const)
      ((eq? e 'add1) *const)
      ((eq? e 'sub1) *const)
      ((eq? e 'number?) *const)
      (else *identifier))))

; List to action
;
(define list-to-action
  (lambda (e)
    (cond
      ((atom? (car e))
       (cond
         ((eq? (car e) 'quote) *quote)
         ((eq? (car e) 'lambda) *lambda)
         ((eq? (car e) 'cond) *cond)
         (else *application)))
      (else *application))))

; The value function takes an expression and evaulates it
;
(define value
  (lambda (e)
    (meaning e '())))

; The meaning function translates an expression to its meaning
;
(define meaning
  (lambda (e table)
    ((expression-to-action e) e table)))

; Now the various actions. Let's start with *const
;
(define *const
  (lambda (e table)
    (cond
      ((number? e) e)
      ((eq? e #t) #t)
      ((eq? e #f) #f)
      (else
        (build 'primitive e)))))

; *quote: (quote text)
;
(define *quote
  (lambda (e table)
    (text-of e)))

; text-of
;
(define text-of second)

; *identifier
;
(define *identifier
  (lambda (e table)
    (lookup-in-table e table initial-table)))

; initial-table
;
(define initial-table
  (lambda (name)
    (car '())))    ; let's hope we don't take this path

; *lambda
;
(define *lambda
  (lambda (e table)
    (build 'non-primitive
           (cons table (cdr e)))))

; Let's add helper functions
;
(define table-of first)
(define formals-of second)
(define body-of third)

; cond takes lines, and returns the value for the first true line
;
(define evcon
  (lambda (lines table)
    (cond
      ((else? (question-of (car lines)))
       (meaning (answer-of (car lines)) table))
      ((meaning (question-of (car lines)) table)
       (meaning (answer-of (car lines)) table))
      (else
        (evcon (cdr lines) table)))))    ; we don't ask null?, better one of cond lines be true!

; evcon needs else?, question-of and answer-of
;
(define else?
  (lambda (x)
    (cond
      ((atom? x) (eq? x 'else))
      (else #f))))

(define question-of first)
(define answer-of second)

; Now we can write the real *cond
;
(define *cond
  (lambda (e table)
    (evcon (cond-lines-of e) table)))

(define cond-lines-of cdr)

; evlis finds meaning of arguments
;
(define evlis
  (lambda (args table)
    (cond
      ((null? args) '())
      (else
        (cons (meaning (car args) table)
              (evlis (cdr args) table))))))

; Finally the *application
;
(define *application
  (lambda (e table)
    (applyz
      (meaning (function-of e) table)
      (evlis (arguments-of e) table))))

(define function-of car)
(define arguments-of cdr)

; Is the function a primitive?
;
(define primitive?
  (lambda (l)
    (eq? (first l) 'primitive)))

; Is the function a non-primitive?
;
(define non-primitive?
  (lambda (l)
    (eq? (first l) 'non-primitive)))

; Apply!
;
(define applyz
  (lambda (fun vals)
    (cond
      ((primitive? fun)
       (apply-primitive (second fun) vals))
      ((non-primitive? fun)
       (apply-closure (second fun) vals)))))

; apply-primitive
;
(define apply-primitive
  (lambda (name vals)
    (cond
      ((eq? name 'cons)
       (cons (first vals) (second vals)))
      ((eq? name 'car)
       (car (first vals)))
      ((eq? name 'cdr)
       (cdr (first vals)))
      ((eq? name 'null?)
       (null? (first vals)))
      ((eq? name 'eq?)
       (eq? (first vals) (second vals)))
      ((eq? name 'atom?)
       (:atom? (first vals)))
      ((eq? name 'zero?)
       (zero? (first vals)))
      ((eq? name 'add1)
       (+ 1 (first vals)))
      ((eq? name 'sub1)
       (- 1 (first vals)))
      ((eq? name 'number?)
       (number? (first vals))))))

; :atom?
;
(define :atom?
  (lambda (x)
    (cond
      ((atom? x) #t)
      ((null? x) #f)
      ((eq? (car x) 'primitive) #t)
      ((eq? (car x) 'non-primitive) #t)
      (else #f))))

; apply-closure
;
(define apply-closure
  (lambda (closure vals)
    (meaning
      (body-of closure)
      (extend-table (new-entry
                      (formals-of closure)
                      vals)
                    (table-of closure)))))

;
; Let's try out our brand new Scheme interpreter!
;

(value '(add1 6))                           ; 7
(value '(quote (a b c)))                    ; '(a b c)
(value '(car (quote (a b c))))              ; 'a
(value '(cdr (quote (a b c))))              ; '(b c)
(value
  '((lambda (x)
      (cons x (quote ())))
    (quote (foo bar baz))))                 ; '((foo bar baz))
(value
  '((lambda (x)
      (cond
        (x (quote true))
        (else
          (quote false))))
    #t))                                    ; 'true

