(add1 67)       ; 68
(sub1 5)        ; 5
(zero? 0)       ; #t
(zero? 1492)    ; #f
(o+ 46 12)      ; 58
(o- 14 3)       ; 11
(o- 17 9)       ; 8
(addtup '(3 5 2 8))     ; 18
(addtup '(15 6 7 12 3)) ; 43
(o* 5 3)                ; 15
(o* 13 4)               ; 52
(tup+ '(3 6 9 11 4) '(8 5 2 0 7))   ; '(11 11 11 11 11)
(tup+ '(3 7) '(4 6 8 1))            ; '(7 13 8 1)
(o> 12 133)     ; #f
(o> 120 11)     ; #t
(o> 6 6)        ; #f
(o< 4 6)        ; #t
(o< 8 3)        ; #f
(o< 6 6)        ; #f
(o= 5 5)        ; #t
(o= 1 2)        ; #f
(o^ 1 1)        ; 1
(o^ 2 3)        ; 8
(o^ 5 3)        ; 125
(o/ 15 4)       ; 3
(olength '(hotdogs with mustard sauerkraut and pickles))     ; 6
(olength '(ham and cheese on rye))                           ; 5
(pick 4 '(lasagna spaghetti ravioli macaroni meatball))     ; 'macaroni
(rempick 3 '(hotdogs with hot mustard))     ; '(hotdogs with mustard)
(no-nums '(5 pears 6 prunes 9 dates))       ; '(pears prunes dates)
(all-nums '(5 pears 6 prunes 9 dates))       ; '(5 6 9)
(eqan? 3 3)     ; #t
(eqan? 3 4)     ; #f
(eqan? 'a 'a)   ; #t
(eqan? 'a 'b)   ; #f
(occur 'x '(a b x x c d x))     ; 3
(occur 'x '())                  ; 0
(one? 5)        ; #f
(one? 1)        ; #t
(rempick-one 4 '(hotdogs with hot mustard))     ; '(hotdogs with mustard)