package env

import (
	"errors"

	. "github.com/holmes89/shrew/types"
)

type Env struct {
	data  map[string]Expression
	outer EnvType
}

func NewEnv(outer EnvType, binds_mt Expression, exprs_mt Expression) (EnvType, error) {
	env := Env{map[string]Expression{}, outer}

	if binds_mt != nil && exprs_mt != nil {
		binds, e := GetSlice(binds_mt)
		if e != nil {
			return nil, e
		}
		exprs, e := GetSlice(exprs_mt)
		if e != nil {
			return nil, e
		}
		// Return a new Env with symbols in binds boudn to
		// corresponding values in exprs
		for i := 0; i < len(binds); i += 1 {
			if Symbol_Q(binds[i]) && binds[i].(Symbol).Val == "&" {
				env.data[binds[i+1].(Symbol).Val] = List{Val: exprs[i:]}
				break
			} else {
				env.data[binds[i].(Symbol).Val] = exprs[i]
			}
		}
	}
	return env, nil
}

type EnvFunc func(a []Expression) (Expression, error)

func DefaultEnv() EnvType {

	env, _ := NewEnv(nil, nil, nil)
	env.Set(symbolDiv, add)
	env.Set(symbolSubtract, sub)
	env.Set(symbolMul, mul)
	env.Set(symbolDiv, div)
	return env
}

var (
	add EnvFunc = func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) + a[1].(int), nil
	}
	sub EnvFunc = func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) - a[1].(int), nil
	}
	mul EnvFunc = func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) * a[1].(int), nil
	}
	div EnvFunc = func(a []Expression) (Expression, error) {
		if e := assertArgNum(a, 2); e != nil {
			return nil, e
		}
		return a[0].(int) / a[1].(int), nil
	}
)

func makeSymbol(text string) Symbol {
	return Symbol{
		Val: text,
	}
}

var (
	symbolAdd      = makeSymbol("+")
	symbolSubtract = makeSymbol("-")
	symbolMul      = makeSymbol("*")
	symbolDiv      = makeSymbol("/")
)

func (e Env) Find(key Symbol) EnvType {
	if _, ok := e.data[key.Val]; ok {
		return e
	} else if e.outer != nil {
		return e.outer.Find(key)
	} else {
		return nil
	}
}

func (e Env) Set(key Symbol, value Expression) Expression {
	e.data[key.Val] = value
	return value
}

func (e Env) Get(key Symbol) (Expression, error) {
	env := e.Find(key)
	if env == nil {
		return nil, errors.New("'" + key.Val + "' not found")
	}
	return env.(Env).data[key.Val], nil
}

func assertArgNum(a []Expression, n int) error {
	if len(a) != n {
		return errors.New("wrong number of arguments")
	}
	return nil
}
