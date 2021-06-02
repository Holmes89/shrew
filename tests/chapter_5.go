package repltests

var chapter5 = []chaptertest{
	{
		Command: `(rember*
  'cup
  '((coffee) cup ((tea) cup) (and (hick)) cup))`,
		Result: `'((coffee) ((tea)) (and (hick)))`,
	},
	{
		Command: `(rember*
  'sauce
  '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce)))`,
		Result: `'(((tomato)) ((bean)) (and ((flying))))`,
	},
	{
		Command: `(insertR*
  'roast
  'chuck
  '((how much (wood)) could ((a (wood) chuck)) (((chuck)))
    (if (a) ((wood chuck))) could chuck wood))`,
		Result: `'((how much (wood)) could ((a (wood) chuck roast)) (((chuck roast))) (if (a) ((wood chuck roast))) could chuck roast wood)`,
	},
	{
		Command: `(occur*
  'banana
  '((banana)
    (split ((((banana ice)))
            (cream (banana))
            sherbet))
    (banana)
    (bread)
    (banana brandy)))`,
		Result: `5`,
	},
	{
		Command: `(subst*
  'orange
  'banana
  '((banana)
    (split ((((banana ice)))
            (cream (banana))
            sherbet))
    (banana)
    (bread)
    (banana brandy)))`,
		Result: `'((orange) (split ((((orange ice))) (cream (orange)) sherbet)) (orange) (bread) (orange brandy))`,
	},
	{
		Command: `(insertL*
  'pecker
  'chuck
  '((how much (wood)) could ((a (wood) chuck)) (((chuck)))
    (if (a) ((wood chuck))) could chuck wood))`,
		Result: `'((how much (wood)) could ((a (wood) pecker chuck)) (((pecker chuck))) (if (a) ((wood pecker chuck))) could pecker chuck wood)`,
	},
	{
		Command: `(member*
  'chips
  '((potato) (chips ((with) fish) (chips))))`,
		Result: "true",
	},
	{
		Command: `(leftmost '((potato) (chips ((with) fish) (chips))))`,
		Result:  `'potato`,
	},
	{
		Command: `(leftmost '(((hot) (tuna (and))) cheese))`,
		Result:  `'hot`,
	},
	{
		Command: `(eqlist?
  '(strawberry ice cream)
  '(strawberry ice cream))`,
		Result: "true",
	},
	{
		Command: `(eqlist?
  '(strawberry ice cream)
  '(strawberry cream ice))`,
		Result: "false",
	},
	{
		Command: `(eqlist?
  '(banan ((split)))
  '((banana) split))`,
		Result: "false",
	},
	{
		Command: `(eqlist?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))`,
		Result: "false",
	},
	{
		Command: `(eqlist?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))`,
		Result: "true",
	},
	{
		Command: `(eqlist2?
  '(strawberry ice cream)
  '(strawberry ice cream))`,
		Result: "true",
	},
	{
		Command: `(eqlist2?
  '(strawberry ice cream)
  '(strawberry cream ice))`,
		Result: "false",
	},
	{
		Command: `(eqlist2?
  '(banan ((split)))
  '((banana) split))`,
		Result: "false",
	},
	{
		Command: `(eqlist2?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))`,
		Result: "false",
	},
	{
		Command: `(eqlist2?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))`,
		Result: "true",
	},
	{
		Command: `(equal?? 'a 'a)`,
		Result:  "true",
	},
	{
		Command: `(equal?? 'a 'b)`,
		Result:  "false",
	},
	{
		Command: `(equal?? '(a) 'a)`,
		Result:  "false",
	},
	{
		Command: `(equal?? '(a) '(a))`,
		Result:  "true",
	},
	{
		Command: `(equal?? '(a) '(b))`,
		Result:  "false",
	},
	{
		Command: `(equal?? '(a) '())`,
		Result:  "false",
	},
	{
		Command: `(equal?? '() '(a))`,
		Result:  "false",
	},
	{
		Command: `(equal?? '(a b c) '(a b c))`,
		Result:  "true",
	},
	{
		Command: `(equal?? '(a (b c)) '(a (b c)))`,
		Result:  "true",
	},
	{
		Command: `(equal?? '(a ()) '(a ()))`,
		Result:  "true",
	},
	{
		Command: `(equal2?? 'a 'a)`,
		Result:  "true",
	},
	{
		Command: `(equal2?? 'a 'b)`,
		Result:  "false",
	},
	{
		Command: `(equal2?? '(a) 'a)`,
		Result:  "false",
	},
	{
		Command: `(equal2?? '(a) '(a))`,
		Result:  "true",
	},
	{
		Command: `(equal2?? '(a) '(b))`,
		Result:  "false",
	},
	{
		Command: `(equal2?? '(a) '())`,
		Result:  "false",
	},
	{
		Command: `(equal2?? '() '(a))`,
		Result:  "false",
	},
	{
		Command: `(equal2?? '(a b c) '(a b c))`,
		Result:  "true",
	},
	{
		Command: `(equal2?? '(a (b c)) '(a (b c)))`,
		Result:  "true",
	},
	{
		Command: `(equal2?? '(a ()) '(a ()))`,
		Result:  "true",
	},
	{
		Command: `(eqlist3?
  '(strawberry ice cream)
  '(strawberry ice cream))`,
		Result: "true",
	},
	{
		Command: `(eqlist3?
  '(strawberry ice cream)
  '(strawberry cream ice))`,
		Result: "false",
	},
	{
		Command: `(eqlist3?
  '(banan ((split)))
  '((banana) split))`,
		Result: "false",
	},
	{
		Command: `(eqlist3?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))`,
		Result: "false",
	},
	{
		Command: `(eqlist3?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))`,
		Result: "true",
	},
	{
		Command: `(rember
  '(foo (bar (baz)))
  '(apples (foo (bar (baz))) oranges))`,
		Result: `'(apples oranges)`,
	},
}
