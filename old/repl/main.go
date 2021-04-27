package main

import (
	"fmt"
	"os"
	"os/user"

	"github.com/holmes89/shrew/repl"
)

func main() {
	user, err := user.Current()
	if err != nil {
		panic(err)
	}
	fmt.Printf("Hello %s! This is the Shrew an experimental LISP!\n",
		user.Username)
	repl.Start(os.Stdin, os.Stdout)
}
