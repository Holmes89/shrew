package token

type TokenType string

type Token struct {
	Type    TokenType
	Literal string
}

const (
	ILLEGAL = "ILLEGAL"
	EOF     = "EOF"

	// Identifiers + literals
	ATOM = "ATOM" // add, foobar, x, y, ...
	INT  = "INT"  // 1343456

	// Operators
	PLUS     = "+"
	MINUS    = "-"
	ASTERISK = "*"
	SLASH    = "/"
	LT       = "<"
	GT       = ">"
	EQ       = "="

	LPAREN = "("
	RPAREN = ")"

	// Keywords
	DEFINE = "DEFINE"
	LAMBDA = "LAMBDA"
	QUOTE  = "QUOTE"
	NIL    = "NIL"
	CONS   = "CONS"
	CAR    = "CAR"
	CDR    = "CDR"
	COND   = "COND"
	TRUE   = "TRUE"
	FALSE  = "FALSE"
	LIST   = "LIST"
	AND    = "AND"
	OR     = "OR"
	NOT    = "NOT"
	IF     = "IF"
	ELSE   = "ELSE"
)

var keywords = map[string]TokenType{
	"#t":     TRUE,
	"#f":     FALSE,
	"'":      QUOTE,
	"define": DEFINE,
	"lambda": LAMBDA,
	"quote":  QUOTE,
	"list":   LIST,
	"car":    CAR,
	"cdr":    CDR,
	"cons":   CONS,
	"cond":   COND,
	"and":    AND,
	"or":     OR,
	"not":    NOT,
	"if":     IF,
	"else":   ELSE,
}

func LookupIdent(ident string) TokenType {
	if tok, ok := keywords[ident]; ok {
		return tok
	}
	return ATOM
}
