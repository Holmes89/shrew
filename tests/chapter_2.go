package repltests

var chapter2 = []chaptertest{
	{
		Command: `(lat? '(Jack Sprat could eat no chicken fat))`,
		Result:  "true",
	},
	{
		Command: `(lat? '())`,
		Result:  "true",
	},
	{
		Command: `(lat? '(bacon and eggs))`,
		Result:  "true",
	},
	{
		Command: `(lat? '((Jack) Sprat could eat no chicken fat))`,
		Result:  "false",
	},
	{
		Command: `(lat? '(Jack (Sprat could) eat no chicken fat))`,
		Result:  "false",
	},
	{
		Command: `(lat? '(bacon (and eggs)))`,
		Result:  "false",
	},
	{
		Command: `(or (null? '()) (atom? '(d e f g)))`,
		Result:  "true",
	},
	{
		Command: `(or (null? '(a b c)) (null? '()))`,
		Result:  "true",
	},
	{
		Command: `(or (null? '(a b c)) (null? '(atom)))`,
		Result:  "false",
	},
	{
		Command: `(member? 'meat '(mashed potatoes and meat gravy))`,
		Result:  "true",
	},
	{
		Command: `(member? 'meat '(potatoes and meat gravy))`,
		Result:  "true",
	},
	{
		Command: `(member? 'meat '(and meat gravy))`,
		Result:  "true",
	},
	{
		Command: `(member? 'meat '(meat gravy))`,
		Result:  "true",
	},
	{
		Command: `(member? 'liver '(bagels and lox))`,
		Result:  "false",
	},
	{
		Command: `(member? 'liver '())`,
		Result:  "false",
	},
}
