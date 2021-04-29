package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"strings"

	. "github.com/holmes89/shrew/env"
	"github.com/holmes89/shrew/lexer"
	. "github.com/holmes89/shrew/types"
)

var repl_env = DefaultEnv()

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
func eval(ast Expression, env EnvType) (Expression, error) {
	list, ok := ast.(List)
	if !ok {
		return eval_ast(ast, env)
	}

	listLen := len(list.Val)
	if listLen == 0 {
		return ast, nil
	}

	// apply list
	a0 := list.Val[0]
	var a1 Expression = nil
	var a2 Expression = nil

	if listLen > 1 {
		a1 = list.Val[1]
	}

	if listLen > 2 {
		a2 = ast.(List).Val[2]
	}

	a0sym := "__<*fn*>__"
	if Symbol_Q(a0) {
		a0sym = a0.(Symbol).Val
	}

	switch a0sym {
	case "define":
		res, e := eval(a2, env)
		if e != nil {
			return nil, e
		}
		return env.Set(a1.(Symbol), res), nil
	case "let*":
		let_env, e := NewEnv(env, nil, nil)
		if e != nil {
			return nil, e
		}
		arr1, e := GetSlice(a1)
		if e != nil {
			return nil, e
		}
		for i := 0; i < len(arr1); i += 2 {
			if !Symbol_Q(arr1[i]) {
				return nil, errors.New("non-symbol bind value")
			}
			exp, e := eval(arr1[i+1], let_env)
			if e != nil {
				return nil, e
			}
			let_env.Set(arr1[i].(Symbol), exp)
		}
		return eval(a2, let_env)
	default:
		el, e := eval_ast(ast, env)
		if e != nil {
			return nil, e
		}
		f, ok := el.(List).Val[0].(EnvFunc)
		if !ok {
			return nil, errors.New("attempt to call non-function")
		}
		return f(el.(List).Val[1:])
	}
}

func eval_ast(ast Expression, env EnvType) (Expression, error) {
	switch {
	case Symbol_Q(ast):
		return env.Get(ast.(Symbol))
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
