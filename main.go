package main

import (
	"bufio"
	"fmt"
	"os"
	"reflect"
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

func read(str string) (Expression, error) {
	return lexer.Read(strings.NewReader(str))
}

func eval(ast Expression, env string) (Expression, error) {
	return ast, nil
}

func print(exp Expression) (string, error) {
	return fmt.Sprintf("%s %v", reflect.TypeOf(exp), exp), nil
}

func repl(str string) (Expression, error) {
	var exp Expression
	var res string
	var e error
	if exp, e = read(str); e != nil {
		return nil, e
	}
	if exp, e = eval(exp, ""); e != nil {
		return nil, e
	}
	if res, e = print(exp); e != nil {
		return nil, e
	}
	return res, nil
}
