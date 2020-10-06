package repl

import (
	"fmt"
	"io"
)

const PROMPT = ">> "

func Start(in io.Reader, out io.Writer) {
	for {
		fmt.Fprint(out, PROMPT)
		l := NewLexer(in)
		for tok := l.NextToken(); tok.typ != tokenEOF; tok = l.NextToken() {
			fmt.Fprintf(out, "%+v\n", tok)
			fmt.Fprint(out, PROMPT)
		}
	}
}
