package repltests

var chapter7 = []chaptertest{
	{
		Command: `(set? '(apples peaches pears plums))`,
		Result:  `true`,
	},
	{
		Command: `(set? '(apple peaches apple plum))`,
		Result:  `false`,
	},
	{
		Command: `(set? '(apple 3 pear 4 9 apple 3 4))`,
		Result:  `false`,
	},
	{
		Command: `(makeset '(apple peach pear peach plum apple lemon peach))`,
		Result:  `'(apple peach pear plum lemon)`,
	},
	{
		Command: `(makeset '(apple 3 pear 4 9 apple 3 4))`,
		Result:  `'(apple 3 pear 4 9)`,
	},
	{
		Command: `(subset? '(5 chicken wings)
         '(5 hamburgers 2 pieces fried chicken and light duckling wings))`,
		Result: `true`,
	},
	{
		Command: `(subset? '(4 pounds of horseradish)
         '(four pounds of chicken and 5 ounces of horseradish))`,
		Result: `false`,
	},
	{
		Command: `(eqset? '(a b c) '(c b a))`,
		Result:  `true`,
	},
	{
		Command: `(eqset? '() '())`,
		Result:  `true`,
	},
	{
		Command: `(eqset? '(a b c) '(a b))`,
		Result:  `false`,
	},
	{
		Command: `(intersect?
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))`,
		Result: `true`,
	},
	{
		Command: `(intersect?
  '(a b c)
  '(d e f))`,
		Result: `false`,
	},
	{
		Command: `(intersect
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))`,
		Result: `'(and macaroni)`,
	},
	{
		Command: `(union
  '(stewed tomatoes and macaroni casserole)
  '(macaroni and cheese))`,
		Result: `'(stewed tomatoes casserole macaroni and cheese)`,
	},
	{
		Command: `(xxx '(a b c) '(a b d e f))`,
		Result:  `'(c)`,
	},
	{
		Command: `(intersectall '((a b c) (c a d e) (e f g h a b)))`,
		Result:  `'(a)`,
	},
	{
		Command: `(intersectall
  '((6 pears and)
    (3 peaches and 6 peppers)
    (8 pears and 6 plums)
    (and 6 prunes with some apples)))`,
		Result: `'(6 and)`,
	},
	{
		Command: `(a-pair? '(pear pear))`,
		Result:  `true`,
	},
	{
		Command: `(a-pair? '(3 7))`,
		Result:  `true`,
	},
	{
		Command: `(a-pair? '((2) (pair)))`,
		Result:  `true`,
	},
	{
		Command: `(a-pair? '(full (house)))`,
		Result:  `true`,
	},
	{
		Command: `(a-pair? '())`,
		Result:  `false`,
	},
	{
		Command: `(a-pair? '(a b c))`,
		Result:  `false`,
	},
	{
		Command: `(fun? '((4 3) (4 2) (7 6) (6 2) (3 4)))`,
		Result:  `false`,
	},
	{
		Command: `(fun? '((8 3) (4 2) (7 6) (6 2) (3 4)))`,
		Result:  `true`,
	},
	{
		Command: `(fun? '((d 4) (b 0) (b 9) (e 5) (g 4)))`,
		Result:  `false`,
	},
	{
		Command: `(revrel '((8 a) (pumpkin pie) (got sick)))`,
		Result:  `'((a 8) (pie pumpkin) (sick got))`,
	},
	{
		Command: `(fullfun? '((8 3) (4 2) (7 6) (6 2) (3 4)))`,
		Result:  `false`,
	},
	{
		Command: `(fullfun? '((8 3) (4 8) (7 6) (6 2) (3 4)))`,
		Result:  `true`,
	},
	{
		Command: `(fullfun? '((grape raisin)
            (plum prune)
            (stewed prune)))`,
		Result: `false`,
	},
	{
		Command: `(one-to-one? '((8 3) (4 2) (7 6) (6 2) (3 4)))`,
		Result:  `false`,
	},
	{
		Command: `(one-to-one? '((8 3) (4 8) (7 6) (6 2) (3 4)))`,
		Result:  `true`,
	},
	{
		Command: `(one-to-one? '((grape raisin)
               (plum prune)
               (stewed prune)))`,
		Result: `false`,
	},
	{
		Command: `(one-to-one? '((chocolate chip) (doughy cookie)))`,
		Result:  `true`,
	},
}
