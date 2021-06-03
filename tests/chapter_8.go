package repltests

var chapter8 = []chaptertest{
	{
		Command: `((rember-f eq?) 2 '(1 2 3 4 5))`,
		Result:  `'(1 3 4 5)`,
	},
	{
		Command: `((eq?-c 'tuna) 'tuna)`,
		Result:  `true`,
	},
	{
		Command: `((eq?-c 'tuna) 'salad)`,
		Result:  `false`,
	},
	{
		Command: `(eq?-salad 'salad)`,
		Result:  `true`,
	},
	{
		Command: `(eq?-salad 'tuna)`,
		Result:  `false`,
	},
	{
		Command: `((rember-f eq?) 2 '(1 2 3 4 5))`,
		Result:  `'(1 3 4 5)`,
	},
	{
		Command: `(rember-eq? 2 '(1 2 3 4 5))`,
		Result:  `'(1 3 4 5)`,
	},
	{
		Command: `(rember-eq? 'tuna '(tuna salad is good))`,
		Result:  `'(salad is good)`,
	},
	{
		Command: `(rember-eq? 'tuna '(shrimp salad and tuna salad))`,
		Result:  `'(shrimp salad and salad)`,
	},
	{
		Command: `(rember-eq? 'eq? '(equal? eq? eqan? eqlist? eqpair?))`,
		Result:  `'(equal? eqan? eqlist? eqpair?)`,
	},
	{
		Command: `((insertL-f eq?)
  'd
  'e
  '(a b c e f g d h))`,
		Result: `'(a b c d e f g d h)`,
	},
	{
		Command: `((insertR-f eq?)
  'e
  'd
  '(a b c d f g d h))`,
		Result: `'(a b c d e f g d h)`,
	},
	{
		Command: `(insertL
  'd
  'e
  '(a b c e f g d h))`,
		Result: `'(a b c d e f g d h)`,
	},
	{
		Command: `(insertR
  'e
  'd
  '(a b c d f g d h))`,
		Result: `'(a b c d e f g d h)`,
	},
	{
		Command: `(insertL
  'd
  'e
  '(a b c e f g d h))`,
		Result: `'(a b c d e f g d h)`,
	},
	{
		Command: `(yyy
  'sausage
  '(pizza with sausage and bacon))`,
		Result: `'(pizza with and bacon)`,
	},
	// {
	// 	Command: `(atom-to-function (operator '(o+ 5 3)))`,
	// 	Result:  `+ (function plus)`,
	// }, Not sure how to test this one
	{
		Command: `(value 13)`,
		Result:  `13`,
	},
	{
		Command: `(value '(o+ 1 3))`,
		Result:  `4`,
	},
	{
		Command: `(value '(o+ 1 (o^ 3 4)))`,
		Result:  `82`,
	},
	{
		Command: `((multirember-f eq?) 'tuna '(shrimp salad tuna salad and tuna))`,
		Result:  `'(shrimp salad salad and)`,
	},
	{
		Command: `(multiremberT
  eq?-tuna
  '(shrimp salad tuna salad and tuna))`,
		Result: `'(shrimp salad salad and)`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  a-friend)`,
		Result: `false`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '()
  a-friend)`,
		Result: `true`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '(tuna)
  a-friend)`,
		Result: `false`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  new-friend)`,
		Result: `false`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '()
  new-friend)`,
		Result: `false`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '(tuna)
  new-friend)`,
		Result: `false`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  last-friend)`,
		Result: `3`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '()
  last-friend)`,
		Result: `0`,
	},
	{
		Command: `(multiremember&co
  'tuna
  '(tuna)
  last-friend)`,
		Result: "0",
	},
	{
		Command: `(multiinsertLR
  'x
  'a
  'b
  '(a o a o b o b b a b o))`,
		Result: `'(x a o x a o b x o b x b x x a b x o)`,
	},
	{
		Command: `(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col1)`,
		Result: `'(chips salty and salty fish or salty fish and chips salty)`,
	},
	{
		Command: `(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col2)`,
		Result: `2`,
	},
	{
		Command: `(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col3)`,
		Result: `2`,
	},
	{
		Command: `(evens-only*
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2))`,
		Result: `'((2 8) 10 (() 6) 2)`,
	},
	{
		Command: `(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-friend)`,
		Result: `'((2 8) 10 (() 6) 2)`,
	},
	{
		Command: `(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-product-friend)`,
		Result: `1920`,
	},
	{
		Command: `(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-sum-friend)`,
		Result: `38`,
	},
	{
		Command: `(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  the-last-friend)`,
		Result: `'(38 1920 (2 8) 10 (() 6) 2)`,
	},
}
