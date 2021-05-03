package main_test

import (
	"testing"

	. "github.com/holmes89/shrew"
)

func TestRepl(t *testing.T) {
	res, err := Repl(`(define foo (lambda (n) (if (= n 0) 0 (bar (- n 1)))))`)
	if err != nil {
		t.Error(err)
		t.FailNow()
	}
	if res == nil {
		t.Error("should not be nil")
		t.FailNow()
	}

	res, err = Repl(`(apply + [ 2 3 4])`)
	if err != nil {
		t.Error(err)
		t.FailNow()
	}
	if res == nil {
		t.Error("should not be nil")
		t.FailNow()
	}

	if res.(int) != 9 {
		t.Errorf("should be 9 not %v", res)
		t.FailNow()
	}
}
