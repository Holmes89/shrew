package repl_test

import (
	"strings"
	"testing"

	"github.com/holmes89/shrew/repl"
)

func TestEval(t *testing.T) {
	context := repl.NewContext(-1)

	line := `(define foo (lambda (a b c) (+ a b c)))`
	l := repl.NewLexer(strings.NewReader(line))
	p := repl.NewParser(l)

	exp, err := p.Parse()
	if err != nil {
		t.Error("should have parsed")
		t.FailNow()
	}
	res := context.Eval(exp)
	if res.String() != "(foo)" {
		t.Errorf("should equal (foo) got %s", res.String())
	}

	line = `(foo 10 2 3)`
	l = repl.NewLexer(strings.NewReader(line))
	p = repl.NewParser(l)

	exp, err = p.Parse()
	if err != nil {
		t.Error("should have parsed")
		t.FailNow()
	}
	res = context.Eval(exp)
	if res.String() != "6" {
		t.Errorf("should equal 6 got %s", res.String())
	}
}
