package main_test

import (
	"testing"

	. "github.com/holmes89/shrew"
)

func TestRepl(t *testing.T) {
	res, err := Repl(`(define foo (lambda (n) (if (= n 0) 0 (bar (- n 1)))))`)
	if err != nil {
		t.Error(err)
	}
	if res == nil {
		t.Error("should not be nil")
	}
}
