package repl

import (
	"bufio"
	"fmt"
	"io"
	"strings"
)

const (
	PROMPT          = ">> "
	CONTINUE_PROMPT = ">  "
)

func Start(in io.Reader, out io.Writer) {
	scanner := bufio.NewScanner(in)
	context := NewContext(-1)
	var line string
	for {

		if len(line) > 0 {
			fmt.Fprint(out, CONTINUE_PROMPT)
			line += " "
		} else {
			fmt.Fprint(out, PROMPT)
		}

		scanned := scanner.Scan()
		if !scanned {
			return
		}

		line += scanner.Text()
		p := NewParser(NewLexer(strings.NewReader(line)))

		exp, err := p.Parse()
		if err == ErrMissingRightParen {
			continue
		}
		if err != nil {
			fmt.Fprintf(out, "%+v\n", err)
			line = ""
			continue
		}
		res := context.Eval(exp)
		fmt.Fprintf(out, "%+v\n", res)
		line = ""
	}
}
