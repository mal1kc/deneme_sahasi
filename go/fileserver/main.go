package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	if len(os.Args) < 1 {
		panic("give root of fileServer as commandline arg")
	}
	directoryPath := os.Args[1]

	_, err := os.Stat(directoryPath)
	if os.IsNotExist(err) {
		fmt.Printf("dir %s not found.\n", directoryPath)
		return
	}
	fileServer := http.FileServer(http.Dir(directoryPath))

	http.Handle("/", fileServer)

	port := 7060
	fmt.Printf("Server started at http://localhost:%d\n", port)
	err = http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
	return
}
