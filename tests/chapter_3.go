package repltests

var chapter3 = []chaptertest{
	{
		Command: `(rember 'mint '(lamb chops and mint flavored mint jelly))`,
		Result:  `'(lamb chops and flavored mint jelly)`,
	},
	{
		Command: `(rember 'toast '(bacon lettuce and tomato))`,
		Result:  `'(bacon lettuce and tomato)`,
	},
	{
		Command: `(rember 'cup '(coffee cup tea cup and hick cup))`,
		Result:  `'(coffee tea cup and hick cup)`,
	},
	{
		Command: `(firsts '((apple peach pumpkin)
					(plum pear cherry)
					(grape raisin pea)
					(bean carrot eggplant)))`,
		Result: `'(apple plum grape bean)`,
	},
	{
		Command: `(firsts '((a b) (c d) (e f)))`,
		Result:  `'(a c e)`,
	},
	{
		Command: `(firsts '((five plums) (four) (eleven green oranges)))`,
		Result:  `'(five four eleven)`,
	},
	{
		Command: `(firsts '(((five plums) four)
					(eleven green oranges)
					((no) more)))`,
		Result: `'((five plums) eleven (no))`,
	},
	{
		Command: `(insertR
		  'topping 'fudge
		  '(ice cream with fudge for dessert))`,
		Result: `'(ice cream with fudge topping for dessert)`,
	},
	{
		Command: `(insertR
		  'jalapeno
		  'and
		  '(tacos tamales and salsa))`,
		Result: `'(tacos tamales and jalapeno salsa)`,
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
		  '(a b c e g d h))`,
		Result: `'(a b c d e g d h)`,
	},
	{
		Command: `(subst
		  'topping
		  'fudge
		  '(ice cream with fudge for dessert))`,
		Result: `'(ice cream with topping for dessert)`,
	},
	{
		Command: `(subst2
		  'vanilla
		  'chocolate
		  'banana
		  '(banana ice cream with chocolate topping)) `,
		Result: `'(vanilla ice cream with chocolate topping)`,
	},
	{
		Command: `(multirember
		  'cup
		  '(coffee cup tea cup and hick cup))`,
		Result: `'(coffee tea and hick)`,
	},
	{
		Command: `(multiinsertR
		  'x
		  'a
		  '(a b c d e a a b)) `,
		Result: `'(a x b c d e a x a x b)`,
	},
	{
		Command: `(multiinsertL
		  'x
		  'a
		  '(a b c d e a a b)) `,
		Result: `'(x a b c d e x a x a b)`,
	},
	{
		Command: `(multisubst
		  'x
		  'a
		  '(a b c d e a a b)) `,
		Result: `'(x b c d e x x b)`,
	},
}
