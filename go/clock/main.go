package main

import (
	"fmt"
	"time"
)

func main() {
	digits := [8][11]string{
		{"┏━┓ ", "  ╻  ", " ┏━┓ ", " ┏━┓ ", " ╻ ╻ ", " ┏━┓ ", " ┏   ", " ┏━┓ ", " ┏━┓ ", " ┏━┓ ", "   "},
		{"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ ", " ╻ "},
		{"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ ", "   "},
		{"┃ ┃ ", "  ┃  ", " ┏━┛ ", " ┣━┫ ", " ┗━┫ ", " ┗━┓ ", " ┣━┓ ", "   ┃ ", " ┣━┫ ", " ┗━┫ ", "   "},
		{"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", "   "},
		{"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ╹ "},
		{"┗━┛ ", "  ╹  ", " ┗━━ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   "},
	}

	output_buffer := [8][8]string{
		{"┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ "},
		{"┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ "},
		{"┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "},
		{"┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "},
		{"┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "},
		{"┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ "},
		{"┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ "},
	}

	for range 100 {
		for range 100 {
			fmt.Print("\r")
		}
		fmt.Print("\033[A")
	}

	currentTime := time.Now()
	hours := currentTime.Hour()
	minutes := currentTime.Minute()
	seconds := currentTime.Second()

	for true {

		currentTime = time.Now()

		// Extract the hours, minutes, and seconds from the current time
		hours = currentTime.Hour()
		minutes = currentTime.Minute()
		seconds = currentTime.Second()
		for i := range output_buffer {
			output_buffer[i][0] = digits[i][hours/10]
			output_buffer[i][1] = digits[i][hours%10]

			output_buffer[i][3] = digits[i][minutes/10]
			output_buffer[i][4] = digits[i][minutes%10]

			output_buffer[i][6] = digits[i][seconds/10]
			output_buffer[i][7] = digits[i][seconds%10]
		}

		for _, row := range output_buffer {
			for range row {
				fmt.Print("\r")
			}
			fmt.Print("\033[A")
		}
		for _, row := range output_buffer {
			for _, element := range row {
				fmt.Print(element)
			}
			fmt.Println()
		}
		time.Sleep(time.Second)
	}
}
