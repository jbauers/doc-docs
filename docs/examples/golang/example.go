package example

import (
	"example"
)

type Examples struct {
	ExampleEnabled         *bool                `json:"example_enabled,omitempty"`
	ExampleInt             *int                 `json:"example_int,omitempty"`
	ExampleString          *string              `json:"example_string,omitempty"`
}

func ExampleExamples_output() {
	fmt.Println("Hello")
	// Output: Hello
}
