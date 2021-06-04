package repltests

var chapter10 = []chaptertest{
	{
		Command: `(build '(appetizer entree bevarage)
       '(pate boeuf vin))`,
		Result: "'((appetizer entree bevarage) (pate boeuf vin))",
	},
	{
		Command: `(build '(appetizer entree bevarage)
       '(beer beer beer))`,
		Result: "'((appetizer entree bevarage) (beer beer beer))",
	},
	{
		Command: `(build '(bevarage dessert)
       '((food is) (number one with us)))`,
		Result: "'((bevarage dessert) ((food is) (number one with us)))",
	},
	{
		Command: `(lookup-in-entry
                'entree
                '((appetizer entree bevarage) (pate boeuf vin))
                (lambda (n) '()))`,
		Result: `'boeuf`,
	},
	{
		Command: `(lookup-in-entry
                'no-such-item
                '((appetizer entree bevarage) (pate boeuf vin))
                (lambda (n) '()))`,
		Result: `'()`,
	},
	{
		Command: `(lookup-in-table
                'beverage
                '(((entree dessert) (spaghetti spumoni))
                    ((appetizer entree beverage) (food tastes good)))
                (lambda (n) '()))`,
		Result: `'good`,
	},
	{
		Command: `(value '(quote (a b c)))`,
		Result:  `'(a b c)`,
	},
	{
		Command: `(value '(car (quote (a b c))))`,
		Result:  `'a`,
	},
	{
		Command: `(value '(cdr (quote (a b c))))`,
		Result:  `'(b c)`,
	},
	{
		Command: `(value
                '((lambda (x)
                    (cons x (quote ())))
                    (quote (foo bar baz))))`,
		Result: `'((foo bar baz))`,
	},
	{
		Command: `(value
                '((lambda (x)
                    (cond
                        (x (quote true))
                        (else
                        (quote false))))
                    #t))`,
		Result: `true`,
	},
}
