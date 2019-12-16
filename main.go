package main

import (
	"fmt"
	"github.com/Holmes89/shrew/repl"
	"os"
	"os/user"
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
