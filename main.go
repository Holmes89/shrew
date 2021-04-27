package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"strings"

	"github.com/holmes89/shrew/lexer"
	. "github.com/holmes89/shrew/types"
)

func main() {

	in := os.Stdin
	out := os.Stdout

	for {
		fmt.Print("shrew=> ")
		scanner := bufio.NewScanner(in)
		scanned := scanner.Scan()
		if !scanned {
			return
		}
		text := strings.TrimRight(scanner.Text(), "\n")

		res, err := repl(text)
		if err != nil {
			if err.Error() == "<empty line>" {
				continue
			}
			fmt.Printf("Error: %v\n", err)
			continue
		}
		fmt.Fprintf(out, "%v\n", res)
	}

}

// read
func read(str string) (Expression, error) {
	return lexer.Read(strings.NewReader(str))
}

// eval
func eval(ast Expression, env map[string]Expression) (Expression, error) {
	switch ast.(type) {
	case List: // continue
	default:
		return eval_ast(ast, env)
	}

	if len(ast.(List).Val) == 0 {
		return ast, nil
	}

	// apply list
	el, e := eval_ast(ast, env)
	if e != nil {
		return nil, e
	}
	f, ok := el.(List).Val[0].(func([]Expression) (Expression, error))
	if !ok {
		return nil, errors.New("attempt to call non-function")
	}
	return f(el.(List).Val[1:])
}

func eval_ast(ast Expression, env map[string]Expression) (Expression, error) {
	switch {
	case Symbol_Q(ast):
		k := ast.(Symbol).Val
		exp, ok := env[k]
		if !ok {
			return nil, fmt.Errorf(`'%s' not found`, k)
		}
		return exp, nil
	case List_Q(ast):
		var lst []Expression
		l := ast.(List).Val
		for _, a := range l {
			exp, err := eval(a, env)
			if err != nil {
				return nil, err
			}
			lst = append(lst, exp)
		}
		return List{Val: lst}, nil
	case Vector_Q(ast):
		var lst []Expression
		l := ast.(Vector).Val
		for _, a := range l {
			exp, err := eval(a, env)
			if err != nil {
				return nil, err
			}
			lst = append(lst, exp)
		}
		return Vector{Val: lst}, nil
	case HashMap_Q(ast):
		m := ast.(HashMap)
		new_hm := HashMap{Val: map[Keyword]Expression{}}
		for k, v := range m.Val {
			ke, e1 := eval(k, env)
			if e1 != nil {
				return nil, e1
			}
			if _, ok := ke.(Keyword); !ok {
				return nil, errors.New("non Keyword hash-map key")
			}
			kv, e2 := eval(v, env)
			if e2 != nil {
				return nil, e2
			}
			new_hm.Val[ke.(Keyword)] = kv
		}
		return new_hm, nil
	default:
		return ast, nil
	}
}

func print(exp Expression) (string, error) {
	return fmt.Sprintf("%v", exp), nil
}

func repl(str string) (Expression, error) {
	var exp Expression
	var res string
	var e error
	if exp, e = read(str); e != nil {
		return nil, e
	}
	if exp, e = eval(exp, repl_env); e != nil {
		return nil, e
	}
	if res, e = print(exp); e != nil {
		return nil, e
	}
	return res, nil
}

// env

var repl_env = map[string]Expression{
	"+": func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) + a[1].(int), nil
	},
	"-": func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) - a[1].(int), nil
	},
	"*": func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) * a[1].(int), nil
	},
	"/": func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) / a[1].(int), nil
	},
}

func assertArgNum(a []Expression, n int) error {
	if len(a) != n {
		return errors.New("wrong number of arguments")
	}
	return nil
}
