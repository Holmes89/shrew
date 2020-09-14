package lexer

import (
	"testing"

	"github.com/holmes89/shrew/token"
)

func TestNextToken(t *testing.T) {
	input := `(define foo 
				(lambda (x y) 
					(cond
						((= 1 x) y)
						((< 2 x) (if (= (* 2 x) 10) #t (/ (- x 1) (+ y 2))))
						((and (< 3 x) (> 3 y) #f))
						((or (< 2 x) (< 3 y) 'thing))
						((= nil x) '()
						(else 
							(cons 
								(car (quote (x y)) 
								(cdr ((list 'a 'b 'c)))))))))`

	tests := []struct {
		expectedType    token.TokenType
		expectedLiteral string
	}{
		{token.LPAREN, "("},
		{token.DEFINE, "define"},
		{token.ATOM, "foo"},
		{token.LPAREN, "("},
		{token.LAMBDA, "lambda"},
		{token.LPAREN, "("},
		{token.ATOM, "x"},
		{token.ATOM, "y"},
		{token.RPAREN, ")"},
		{token.LPAREN, "("},
		{token.COND, "cond"},
		{token.LPAREN, "("},
		{token.LPAREN, "("},
		{token.EQ, "="},
		{token.INT, "1"},
		{token.ATOM, "x"},
		{token.RPAREN, ")"},
		{token.ATOM, "y"},
		{token.RPAREN, ")"},
		{token.LPAREN, "("},
		{token.LPAREN, "("},
		{token.LT, "<"},
		{token.INT, "2"},
		{token.ATOM, "x"},
		{token.RPAREN, ")"},
		{token.LPAREN, "("},
		{token.IF, "if"},
		{token.LPAREN, "("},
		{token.EQ, "="},
		{token.LPAREN, "("},
		{token.ASTERISK, "*"},
		{token.INT, "2"},
		{token.ATOM, "x"},
		{token.RPAREN, ")"},
		{token.INT, "10"},
		{token.RPAREN, ")"},
		{token.TRUE, "#t"},
		{token.LPAREN, "("},
		{token.SLASH, "/"},
	}

	l := New(input)

	for i, tt := range tests {
		tok := l.NextToken()

		if tok.Type != tt.expectedType {
			t.Fatalf("tests[%d] - tokentype wrong. expected=%q, got=%q",
				i, tt.expectedType, tok.Type)
		}

		if tok.Literal != tt.expectedLiteral {
			t.Fatalf("tests[%d] - literal wrong. expected=%q, got=%q",
				i, tt.expectedLiteral, tok.Literal)
		}
	}
}
