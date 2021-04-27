package repl

import (
	"fmt"
	"math/big"
	"strings"
)

//go:generate stringer -type TokenType -trimprefix Token
type TokenType int

type Token struct {
	typ  TokenType
	text string
	num  *big.Int
}

const (
	tokenError TokenType = iota
	tokenEOF
	tokenAtom
	tokenConst
	tokenNumber
	tokenLpar
	tokenRpar
	tokenDot
	tokenChar
	tokenQuote
	tokenString
	tokenNewline
)

const EofRune rune = -1

func (t Token) String() string {
	if t.typ == tokenNumber {
		return fmt.Sprint(t.typ, t.num)
	}
	return fmt.Sprint(t.typ, " ", t.text)
}

func (t Token) buildString(b *strings.Builder) {
	if t.typ == tokenNumber {
		b.WriteString(fmt.Sprint(t.num))
	} else {
		b.WriteString(t.text)
	}
}
