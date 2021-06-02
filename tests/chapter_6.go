package repltests

var chapter6 = []chaptertest{
	{
		Command: `(numbered? '5)`,
		Result:  `true`,
	},
	{
		Command: `(numbered? '(5 o+ 5))`,
		Result:  `true`,
	},
	{
		Command: `(numbered? '(5 o+ a))`,
		Result:  `false`,
	},
	{
		Command: `(numbered? '(5 ox (3 o^ 2)))`,
		Result:  `true`,
	},
	{
		Command: `(numbered? '(5 ox (3 'foo 2)))`,
		Result:  `true`,
	},
	{
		Command: `(numbered? '((5 o+ 2) ox (3 o^ 2)))`,
		Result:  `true`,
	},
	{
		Command: `(value 13)`,
		Result:  `13`,
	},
	{
		Command: `(value '(1 o+ 3))`,
		Result:  `4`,
	},
	{
		Command: `(value '(1 o+ (3 o^ 4)))`,
		Result:  `82`,
	},
	{
		Command: `(value-prefix 13)`,
		Result:  `13`,
	},
	{
		Command: `(value-prefix '(o+ 3 4))`,
		Result:  `7`,
	},
	{
		Command: `(value-prefix '(o+ 1 (o^ 3 4)))`,
		Result:  `82`,
	},
	{
		Command: `(value-prefix-helper 13)`,
		Result:  `13`,
	},
	{
		Command: `(value-prefix-helper '(o+ 3 4))`,
		Result:  `false`,
	},
	{
		Command: `(value-prefix-helper '(o+ 1 (o^ 3 4)))`,
		Result:  `false`,
	},
	{
		Command: `(value-prefix 13)`,
		Result:  `13`,
	},
	{
		Command: `(value-prefix '(o+ 3 4))`,
		Result:  `7`,
	},
	{
		Command: `(value-prefix '(o+ 1 (o^ 3 4)))`,
		Result:  `82`,
	},
	{
		Command: `(.+ '(()) '(() ()))`,
		Result:  `'(() () ())`,
	},
	{
		Command: `(tat? '((()) (()()) (()()())))`,
		Result:  `false`,
	},
}
