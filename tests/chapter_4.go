package repltests

var chapter4 = []chaptertest{
	{
		Command: `(add1 67)`,
		Result:  `68`,
	},

	{
		Command: `(sub1 5)`,
		Result:  `4`,
	},

	{
		Command: `(zero? 0)`,
		Result:  `true`,
	},

	{
		Command: `(zero? 1492)`,
		Result:  `false`,
	},

	{
		Command: `(o+ 46 12)`,
		Result:  `58`,
	},

	{
		Command: `(o- 14 3)`,
		Result:  `11`,
	},

	{
		Command: `(o- 17 9)`,
		Result:  `8`,
	},

	{
		Command: `(addtup '(3 5 2 8))`,
		Result:  `18`,
	},

	{
		Command: `(addtup '(15 6 7 12 3))`,
		Result:  `43`,
	},

	{
		Command: `(o* 5 3)`,
		Result:  `15`,
	},

	{
		Command: `(o* 13 4)`,
		Result:  `52`,
	},

	{
		Command: `(tup+ '(3 6 9 11 4) '(8 5 2 0 7))`,
		Result:  `'(11 11 11 11 11)`,
	},

	{
		Command: `(tup+ '(3 7) '(4 6 8 1))`,
		Result:  `'(7 13 8 1)`,
	},

	{
		Command: `(o> 12 133)`,
		Result:  `false`,
	},

	{
		Command: `(o> 120 11)`,
		Result:  `true`,
	},

	{
		Command: `(o> 6 6)`,
		Result:  `false`,
	},

	{
		Command: `(o< 4 6)`,
		Result:  `true`,
	},

	{
		Command: `(o< 8 3)`,
		Result:  `false`,
	},

	{
		Command: `(o< 6 6)`,
		Result:  `false`,
	},

	{
		Command: `(o= 5 5)`,
		Result:  `true`,
	},

	{
		Command: `(o= 1 2)`,
		Result:  `false`,
	},

	{
		Command: `(o^ 1 1)`,
		Result:  `1`,
	},

	{
		Command: `(o^ 2 3)`,
		Result:  `8`,
	},

	{
		Command: `(o^ 5 3)`,
		Result:  `125`,
	},

	{
		Command: `(o/ 15 4)`,
		Result:  `3`,
	},

	{
		Command: `(olength '(hotdogs with mustard sauerkraut and pickles))`,
		Result:  `6`,
	},

	{
		Command: `(olength '(ham and cheese on rye))`,
		Result:  `5`,
	},

	{
		Command: `(pick 4 '(lasagna spaghetti ravioli macaroni meatball))`,
		Result:  `'macaroni`,
	},

	{
		Command: `(rempick 3 '(hotdogs with hot mustard))`,
		Result:  `'(hotdogs with mustard)`,
	},

	{
		Command: `(no-nums '(5 pears 6 prunes 9 dates))`,
		Result:  `'(pears prunes dates)`,
	},

	{
		Command: `(all-nums '(5 pears 6 prunes 9 dates))`,
		Result:  `'(5 6 9)`,
	},

	{
		Command: `(eqan? 3 3)`,
		Result:  `true`,
	},

	{
		Command: `(eqan? 3 4)`,
		Result:  `false`,
	},

	{
		Command: `(eqan? 'a 'a)`,
		Result:  `true`,
	},

	{
		Command: `(eqan? 'a 'b)`,
		Result:  `false`,
	},

	{
		Command: `(occur 'x '(a b x x c d x))`,
		Result:  `3`,
	},

	{
		Command: `(occur 'x '())`,
		Result:  `0`,
	},

	{
		Command: `(one? 5)`,
		Result:  `false`,
	},

	{
		Command: `(one? 1)`,
		Result:  `true`,
	},

	{
		Command: `(rempick-one 3 '(hotdogs with hot mustard))`,
		Result:  `'(hotdogs with mustard)`,
	},
}
