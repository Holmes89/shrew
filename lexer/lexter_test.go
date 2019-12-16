package lexer

import (
	"github.com/Holmes89/shrew/token"
	"testing"
)

func TestNextToken(t *testing.T) {
	input := `(defn test [x] 
					(let [y x]
						(+ y 7))))
				(= 1 α)`
	tests := []struct {
		expectedType    token.TokenType
		expectedLiteral string
	}{
		{token.LPAREN, "("},
		{token.FUNCTION, "defn"},
		{token.IDENT, "test"},
		{token.LBRACKET, "["},
		{token.IDENT, "x"},
		{token.RBRACKET, "]"},
		{token.LPAREN, "("},
		{token.IDENT, "let"},
		{token.LBRACKET, "["},
		{token.IDENT, "y"},
		{token.IDENT, "x"},
		{token.RBRACKET, "]"},
		{token.LPAREN, "("},
		{token.PLUS, "+"},
		{token.IDENT, "y"},
		{token.INT, "7"},
		{token.RPAREN, ")"},
		{token.RPAREN, ")"},
		{token.RPAREN, ")"},
		{token.LPAREN, "("},
		{token.LPAREN, "("},
		{token.IDENT, "="},
		{token.IDENT, "α"},
		{token.RPAREN, ")"},
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
