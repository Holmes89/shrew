package repl

import (
	"errors"
	"fmt"
	"strings"
)

type Expr struct {
	atom *Token
	car  *Expr
	cdr  *Expr
}

// String returns the expression as a formatted list (unless printSExpr is set).
func (e *Expr) String() string {
	if e == nil {
		return "null"
	}
	var b strings.Builder
	e.buildString(&b, true)
	return b.String()
}

// buildString is the internals of the String method. simplifyQuote
// specifies whether (quote expr) should be printed as 'expr.
func (e *Expr) buildString(b *strings.Builder, simplifyQuote bool) {
	if e == nil {
		b.WriteString("null")
		return
	}
	if e.atom != nil {
		e.atom.buildString(b)
		return
	}
	// Simplify (quote a) to 'a.
	if simplifyQuote && car(e).getAtom() == tokenQuoteWord {
		b.WriteByte('\'')
		car(cdr(e)).buildString(b, simplifyQuote)
		return
	}
	b.WriteByte('(')
	for {
		car, cdr := e.car, e.cdr
		car.buildString(b, simplifyQuote)
		if cdr == nil {
			break
		}
		if cdr.atom != nil {
			if cdr.atom.text == "null" {
				break
			}
			b.WriteString(" . ")
			cdr.buildString(b, simplifyQuote)
			break
		}
		b.WriteByte(' ')
		e = cdr
	}
	b.WriteByte(')')
}

func (e *Expr) getAtom() *Token {
	if e != nil && e.atom != nil {
		return e.atom
	}
	return nil
}

type Parser struct {
	lex *Lexer
}

func NewParser(lex *Lexer) *Parser {
	return &Parser{lex}
}

var ErrEndOfInputStream = errors.New("end of input stream")

func (p *Parser) Parse() (*Expr, error) {
	token := p.lex.NextToken()
	switch token.typ {
	case tokenEOF:
		return nil, ErrEndOfInputStream
	case tokenQuote:
		return p.quote()
	case tokenAtom, tokenConst, tokenNumber:
		return atomExpr(token), nil
	case tokenLpar:
		expr, err := p.list()
		if err != nil {
			return nil, err
		}
		token = p.lex.NextToken()
		if token.typ == tokenRpar {
			return expr, nil
		}
	}

	return nil, fmt.Errorf("bad token in expression: %q", token)
}

func (p *Parser) quote() (*Expr, error) {
	exp, err := p.Parse()
	if err != nil {
		return nil, err
	}
	return cons(atomExpr(tokenQuoteWord), cons(exp, nil)), nil
}

var ErrMissingRightParen = errors.New("missing right paren")

func (p *Parser) list() (*Expr, error) {
	if p.lex.IsNextRParen() {
		return nil, nil
	}

	if p.lex.IsNextLParen() {
		exp, err := p.Parse()
		if err != nil {
			return nil, err
		}
		l, err := p.list()
		if err != nil {
			return nil, err
		}
		return cons(exp, l), nil
	}

	tok := p.lex.NextToken()
	switch tok.typ {
	case tokenQuote:
		q, err := p.quote()
		if err != nil {
			return nil, err
		}
		l, err := p.list()
		if err != nil {
			return nil, err
		}
		return cons(q, l), nil
	case tokenAtom, tokenConst, tokenNumber:
		l, err := p.list()
		if err != nil {
			return nil, err
		}
		return cons(atomExpr(tok), l), nil
	case tokenDot:
		return p.Parse()
	}
	return nil, ErrMissingRightParen
}

func car(e *Expr) *Expr {
	if e == nil || e.atom != nil {
		return nil
	}
	return e.car
}

func cdr(e *Expr) *Expr {
	if e == nil || e.atom != nil {
		return nil
	}
	return e.cdr
}

func cons(car, cdr *Expr) *Expr {
	return &Expr{
		car: car,
		cdr: cdr,
	}
}
