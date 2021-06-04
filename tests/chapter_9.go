package repltests

var chapter9 = []chaptertest{
	{
		Command: `(looking 'caviar '(6 2 4 caviar 5 7 3))`,
		Result:  `true`,
	},
	{
		Command: `(looking 'caviar '(6 2 grits caviar 5 7 3))`,
		Result:  `false`,
	},
	{
		Command: `(shift '((a b) c))`,
		Result:  `'(a (b c))`,
	},
	{
		Command: `(shift '((a b) (c d)))`,
		Result:  `'(a (b (c d)))`,
	},
	{
		Command: `(weight* '((a b) c))`,
		Result:  `7`,
	},
	{
		Command: `(weight* '(a (b c)))`,
		Result:  `5`,
	},
	{
		Command: `(shuffle '(a (b c)))`,
		Result:  `'(a (b c))`,
	},
	{
		Command: `(shuffle '(a b))`,
		Result:  `'(a b)`,
	},
	{
		Command: `(A 1 0)`,
		Result:  `2`,
	},
	{
		Command: `(A 1 1)`,
		Result:  `3`,
	},
	{
		Command: `(A 2 2)`,
		Result:  `7`,
	},
	{
		Command: `(((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else
         (add1
           ((mk-length mk-length) (cdr l))))))))
 '(1 2 3 4 5))`,
		Result: `5`,
	},
}
