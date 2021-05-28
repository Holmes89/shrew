package main

import (
	"bufio"
	"bytes"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/holmes89/shrew/core"
	. "github.com/holmes89/shrew/env"
	"github.com/holmes89/shrew/lexer"
	. "github.com/holmes89/shrew/repl"
	. "github.com/holmes89/shrew/types"
)

var repl_env = DefaultEnv()

func init() {
	for k, v := range core.NS {
		repl_env.Set(k, Func{Fn: v})
	}
	repl_env.Set(Symbol{Val: "eval"}, Func{
		Fn: func(a []Expression) (Expression, error) {
			return Eval(a, repl_env)
		},
	})
	repl_env.Set(Symbol{Val: "load-file"}, Func{
		Fn: func(a []Expression) (Expression, error) {
			if len(a) != 1 {
				return nil, errors.New("load-file arity mismatch expected: 1")
			}
			b, err := ioutil.ReadFile(a[0].(string))
			if err != nil {
				return nil, errors.New("unable to read file")
			}
			buf := bytes.NewBuffer(b)
			scanner := bufio.NewScanner(buf)
			var exp Expression
			for scanner.Scan() {
				exp, err = lexer.Read(bytes.NewBuffer(scanner.Bytes()))
				if err != nil {
					return nil, err
				}
				exp, err = Eval(exp, repl_env)
				if err != nil {
					return nil, err
				}
			}
			return exp, err
		},
	})
	repl_env.Set(Symbol{Val: "*ARGV*"}, List{})
	// tODO extract
	_, err := Repl("(define not (lambda (a) (if a false true)))", repl_env)
	if err != nil {
		panic(err)
	}

}

var (
	defaultPrompt  = "shrew=> "
	continuePrompt = "... "
)

func main() {

	in := os.Stdin
	out := os.Stdout

	scanner := bufio.NewScanner(in)

	if len(os.Args) > 1 {
		args := make([]Expression, 0, len(os.Args)-2)
		for _, a := range os.Args[2:] {
			args = append(args, a)
		}
		repl_env.Set(Symbol{Val: "*ARGV*"}, List{Val: args})
		if _, e := Repl("(load-file \""+os.Args[1]+"\")", repl_env); e != nil {
			fmt.Printf("Error: %v\n", e)
			os.Exit(1)
		}
	}

	var commandBuf string
	prompt := defaultPrompt
	for {
		fmt.Print(prompt)
		scanned := scanner.Scan()
		if !scanned {
			return
		}
		commandBuf += strings.TrimRight(scanner.Text(), "\n")

		lparenCount := strings.Count(commandBuf, "(")
		rparenCount := strings.Count(commandBuf, ")")

		if lparenCount > rparenCount {
			commandBuf += " "
			prompt = continuePrompt
			continue
		}
		if rparenCount > lparenCount {
			commandBuf += ""
			prompt = defaultPrompt
			fmt.Printf("Error: mismatch paren\n")
			continue
		}

		res, err := Repl(commandBuf, repl_env)
		if err != nil {
			if err.Error() == "<empty line>" {
				continue
			}
			fmt.Printf("Error: %v\n", err)
			commandBuf = ""
			prompt = defaultPrompt
			continue
		}
		fmt.Fprintf(out, "%v\n", res)
		commandBuf = ""
		prompt = defaultPrompt
	}

}
