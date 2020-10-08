package repl

import (
	"bufio"
	"fmt"
	"io"
	"strings"
)

const PROMPT = ">> "

func Start(in io.Reader, out io.Writer) {
	scanner := bufio.NewScanner(in)

	for {
		fmt.Print(PROMPT)
		scanned := scanner.Scan()
		if !scanned {
			return
		}

		line := scanner.Text()
		p := NewParser(NewLexer(strings.NewReader(line)))
		exp, err := p.Parse()
		if err != nil {
			fmt.Fprintf(out, "%+v\n", err)
			continue
		}
		fmt.Fprintf(out, "%+v\n", exp)
	}
}
