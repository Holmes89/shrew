package repl

import (
	"fmt"
	"strings"
)

// A scope is a stack frame.
type scope struct {
	vars frame  // The variables defined in this frame.
	fn   string // The name of the called function, for tracebacks.
	args *Expr  // The arguments of the called function, for tracebacks.
}

// A Context holds the state of an interpreter.
type Context struct {
	scope         []*scope // The stack of call frames.
	stackDepth    int      // Current stack depth.
	maxStackDepth int      // Stack limit.
}

// NewContext returns a Context ready to execute. The argument specifies
// the maximum stack depth to allow, with <=0 meaning unlimited.
func NewContext(depth int) *Context {
	evalInit()
	c := &Context{}
	c.maxStackDepth = depth
	c.push(top, nil) // Global variables go in scope[0].
	vars := c.scope[0].vars
	vars[tokenT] = constT
	vars[tokenF] = constF
	vars[tokenNull] = constNull
	return c
}

// isCadR reports whether the string represents a run of car and cdr calls.
func isCadR(s string) bool {
	if len(s) < 3 || s[0] != 'c' || s[len(s)-1] != 'r' {
		return false
	}
	for _, c := range s[1 : len(s)-1] {
		if c != 'a' && c != 'd' {
			return false
		}
	}
	return true
}

// lookupElementary returns the function tied to an elementary, or nil.
func lookupElementary(name *Token) elemFunc {
	if fn, ok := elementary[name]; ok {
		return fn
	}
	return nil
}

// push pushes an execution frame onto the stack.
func (c *Context) push(fn string, args *Expr) {
	c.scope = append(c.scope, &scope{
		vars: make(frame),
		fn:   fn,
		args: args,
	})
}

// pop pops one frame of the execution stack.
func (c *Context) pop() {
	c.scope[len(c.scope)-1] = nil // Do not hold on to old frames.
	c.scope = c.scope[:len(c.scope)-1]
}

// PopStack resets the execution stack.
func (c *Context) PopStack() {
	c.stackDepth = 0
	for len(c.scope) > 1 {
		c.pop()
	}
}

// StackTrace returns a printout of the execution stack.
// The most recent call appears first. Long stacks are trimmed
// in the middle.
func (c *Context) StackTrace() string {
	if c.scope[len(c.scope)-1].fn == top {
		return ""
	}
	var b strings.Builder
	fmt.Fprintln(&b, "stack:")
	for i := len(c.scope) - 1; i > 0; i-- {
		if len(c.scope)-i > 20 && i > 20 { // Skip the middle bits.
			i = 20
			fmt.Fprintln(&b, "\t...")
			continue
		}
		s := c.scope[i]
		if s.fn != top {
			fmt.Fprintf(&b, "\t(%s %s)\n", s.fn, Car(s.args))
		}
	}
	return b.String()
}

// getScope returns the scope in which the token is set.
// If it is not set, it returns the innermost (deepest) scope.
func (c *Context) getScope(tok *Token) *scope {
	var sc *scope
	for _, s := range c.scope {
		if _, ok := s.vars[tok]; ok {
			sc = s
		}
	}
	if sc == nil {
		return c.scope[len(c.scope)-1]
	}
	return sc
}

// nonConst guarantees that tok is not a constant.
func notConst(tok *Token) {
	if tok.typ == tokenConst {
		errorf("cannot set constant %s", tok)
	}
}

// set binds the atom (token) to the expression. If the atom is already
// bound anywhere on the stack, the innermost instance is rebound.
func (c *Context) set(tok *Token, expr *Expr) {
	notConst(tok)
	c.getScope(tok).vars[tok] = expr
}

// set binds the atom (token) to the expression in the innermost scope.
func (c *Context) setLocal(tok *Token, expr *Expr) {
	notConst(tok)
	c.scope[len(c.scope)-1].vars[tok] = expr
}

// returns the bound value of the token. The value of a number is itself.
func (c *Context) get(tok *Token) *Expr {
	if tok.typ == tokenNumber {
		return atomExpr(tok)
	}
	return c.getScope(tok).vars[tok]
}
