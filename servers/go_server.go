package main

import (
	"io"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "Hello World")
	})
	log.Fatal(http.ListenAndServe("0.0.0.0:9292", nil))
}
