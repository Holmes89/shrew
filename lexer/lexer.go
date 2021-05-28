package lexer

import (
	"bytes"
	"errors"
	"fmt"
	"io"
	"strconv"
	"text/scanner"
	"unicode"

	. "github.com/holmes89/shrew/types"
)

type Lexer struct {
	*scanner.Scanner
	buf bytes.Buffer
}

// New returns new lexer
func Read(r io.Reader) (Expression, error) {
	var s scanner.Scanner
	s.Init(r)
	s.Mode &^= scanner.ScanChars | scanner.ScanRawStrings
	l := &Lexer{
		Scanner: &s,
	}
	return l.readForm()
}

func makeExpression(token string, exp Expression) List {
	return List{
		Val: []Expression{
			Symbol{
				Val: token, //TODO make tokens
			},
			exp,
		},
	}
}

func (l *Lexer) readForm() (Expression, error) {
	l.eatWhitespace()
	switch l.Peek() {
	case ';':
		l.skipLine()
		return nil, nil
	case '\'':
		l.Next()
		form, err := l.readForm()
		if err != nil {
			return nil, err
		}
		return makeExpression("quote", form), nil
	case '`':
		l.Next()
		form, err := l.readForm()
		if err != nil {
			return nil, err
		}
		return makeExpression("quasiquote", form), nil
	case '~':
		l.Next()
		switch l.Peek() {
		case '@':
			l.Next()
			form, err := l.readForm()
			if err != nil {
				return nil, err
			}
			return makeExpression("splice-unquote", form), nil
		default:
			l.Next()
			form, err := l.readForm()
			if err != nil {
				return nil, err
			}
			return makeExpression("unquote", form), nil
		}
	case '^':
		l.Next()
		form, err := l.readForm()
		if err != nil {
			return nil, err
		}
		return makeExpression("with-meta", form), nil
	case '@':
		l.Next()
		form, err := l.readForm()
		if err != nil {
			return nil, err
		}
		return makeExpression("deref", form), nil
	// list
	case ')':
		return nil, errors.New("unexpected ')'")
	case '(':
		return l.readList()

	// vector
	case ']':
		return nil, errors.New("unexpected ']'")
	case '[':
		return l.readVector()
	// hash-map
	case '}':
		return nil, errors.New("unexpected '}'")
	case '{':
		return l.readHashMap()
	default:
		return l.readAtom()
	}
}

var ErrEOF = errors.New("end of line")

func (l *Lexer) readList() (Expression, error) {
	var endToken rune
	switch t := l.Next(); {
	case t == '(':
		endToken = ')'
	case t == '[':
		endToken = ']'
	case t == '{':
		endToken = '}'
	default:
		return nil, fmt.Errorf("unexpected '%s'", string(t))
	}
	list := []Expression{}
	for {
		token := l.Peek()
		if token == scanner.EOF {
			return nil, ErrEOF
		}
		if token == endToken {
			break
		}
		f, err := l.readForm()
		if err != nil {
			return nil, err
		}
		list = append(list, f)
	}
	l.Next()
	return List{Val: list}, nil
}

func (l *Lexer) eatWhitespace() {
	for {
		p := l.Peek()
		if !isSpace(p) {
			break
		}
		l.Next()
	}
}

func (l *Lexer) skipLine() {
	for {
		p := l.Next()
		if p == '\n' || p == '\r' || p == scanner.EOF {
			break
		}
	}
}

func isSpace(r rune) bool {
	return r == ' ' || r == '\t' || r == '\n' || r == '\r'
}

func (l *Lexer) readHashMap() (Expression, error) {
	list, err := l.readList()
	if err != nil {
		return nil, err
	}
	return NewHashMap(list)
}

func (l *Lexer) readVector() (Expression, error) {
	list, err := l.readList()
	if err != nil {
		return nil, err
	}
	return Vector{Val: list.(List).Val}, nil
}

func (l *Lexer) readAtom() (Expression, error) {
	switch t := l.Next(); {
	case t == scanner.EOF:
		return nil, errors.New("EOF")
	case t == '"': // quoted string
		return l.str()
	case isNumber(t): // number
		return l.number(t)
	case t == ':':
		return l.keyword(t)
	default:
		return l.alphanum(t)
	}
}

func isAlphanum(r rune) bool {
	return r == '_' || isNumber(r) || unicode.IsLetter(r) || r == '?' || r == '!' || r == '-' || r == '*' || r == '+' || r == '>' || r == '<' || r == '=' || r == '^' || r == '/'
}

func isNumber(r rune) bool {
	return '0' <= r && r <= '9'
}

func (l *Lexer) number(r rune) (Expression, error) {
	// Integer only for now.
	l.accum(r, isNumber)
	i, err := strconv.Atoi(l.buf.String())
	if err != nil {
		return nil, errors.New("unable to parse number")
	}
	return i, nil
}

func (l *Lexer) alphanum(r rune) (Expression, error) {
	l.accum(r, isAlphanum)
	switch s := l.buf.String(); {
	case s == "true":
		return true, nil
	case s == "#t":
		return true, nil
	case s == "false":
		return false, nil
	case s == "#f":
		return false, nil
	case s == "nil":
		return nil, nil
	default:
		return Symbol{Val: s}, nil
	}
}

func (l *Lexer) keyword(r rune) (Expression, error) {
	l.accum(r, isAlphanum)
	k := l.buf.String()
	return NewKeyword(k[1:])
}

func (l *Lexer) str() (Expression, error) {
	l.buf.Reset()
	var escaped bool
	for {
		r := l.Peek()
		if r == scanner.EOF {
			return nil, errors.New("unexpected EOF")
		}
		if r == '\\' { // Escape character
			escaped = !escaped //should handle escaping itself
			l.buf.WriteRune(r)
			continue
		}
		if !escaped && r == '"' { // end of string
			l.Next()
			break
		}
		l.buf.WriteRune(r)
		l.Next()
	}
	return l.buf.String(), nil
}

func (l *Lexer) accum(r rune, valid func(rune) bool) {
	l.buf.Reset()
	for {
		l.buf.WriteRune(r)
		r = l.Peek()
		if r == scanner.EOF {
			return
		}
		if !valid(r) {
			return
		}
		r = l.Next()
	}
}
