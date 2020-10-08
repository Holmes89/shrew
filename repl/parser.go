package repl

import (
	"errors"
	"fmt"
)

type Expr struct {
	atom *Token
	car  *Expr
	cdr  *Expr
}

type Parser struct {
	lex *Lexer
}

func NewParser(lex *Lexer) *Parser {
	return &Parser{lex}
}

func (p *Parser) Parse() (*Expr, error) {
	token := p.lex.NextToken()
	switch token.typ {
	case tokenEOF:
		return nil, errors.New("end of input stream")
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

func (p *Parser) list() (*Expr, error) {
	ptok := p.lex.Peek()
	//TODO better peek
	switch ptok {
	case ')':
		return nil, nil
	case '(':
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
	return nil, fmt.Errorf("bad token in expression: %q", tok)
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

func atomExpr(tok *Token) *Expr {
	return &Expr{
		atom: tok,
	}
}
