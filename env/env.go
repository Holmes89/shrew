package env

import (
	"fmt"

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

func DefaultEnv() EnvType {

	env, _ := NewEnv(nil, nil, nil)

	return env
}

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
		return nil, fmt.Errorf("'%s' not found", key.Val)
	}
	return env.(Env).data[key.Val], nil
}
