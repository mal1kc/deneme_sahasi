package main

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var clients = make(map[*websocket.Conn]bool)

func main() {
	if len(os.Args) < 2 {
		panic("give root of fileServer as commandline arg")
	}
	directoryPath := os.Args[1]

	_, err := os.Stat(directoryPath)
	if os.IsNotExist(err) {
		fmt.Printf("dir %s not found.\n", directoryPath)
		return
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		serveFileWithScript(w, r, directoryPath)
	})

	http.HandleFunc("/ws", handleWebSocket)

	go watchDirectory(directoryPath)

	port := 7060
	fmt.Printf("Server started at http://localhost:%d\n", port)
	err = http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}

func serveFileWithScript(w http.ResponseWriter, r *http.Request, directoryPath string) {
	filePath := filepath.Join(directoryPath, r.URL.Path)

	// Check if the requested file is an HTML file
	if filepath.Ext(filePath) == ".html" {
		// Serve the HTML file with injected script
		http.ServeFile(w, r, filePath)
		injectScript(w, filePath)
	} else {
		// Serve other files as raw data
		http.ServeFile(w, r, filePath)
	}
}

func injectScript(w http.ResponseWriter, filePath string) {
	// Read the HTML file content
	content, err := os.ReadFile(filePath)
	if err != nil {
		http.Error(w, "Could not read file", http.StatusInternalServerError)
		return
	}

	// Inject the script before the closing </body> tag
	script := `<script>
        const socket = new WebSocket('ws://localhost:7060/ws');
        socket.onmessage = function(event) {
            if (event.data === 'refresh') {
                location.reload();
                    console.log("trying content with websocket notfication");
            }
        };
    </script>`

	// Replace the closing </body> tag with the injected script
	contentStr := string(content)
	contentStr = contentStr[:len(contentStr)-7] + script + "\n</body>"

	// Write the modified content back to the response
	w.Header().Set("Content-Type", "text/html")
	w.Write([]byte(contentStr))
}

func handleWebSocket(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		fmt.Println("Error upgrading connection:", err)
		return
	}
	defer conn.Close()

	clients[conn] = true

	// Keep the connection open
	for {
		_, _, err := conn.ReadMessage()
		if err != nil {
			fmt.Println("Error reading message:", err)
			break
		}
	}
	delete(clients, conn)
}

func watchDirectory(directoryPath string) {
	lastModTime := time.Time{}

	for {
		files, err := os.ReadDir(directoryPath)
		if err != nil {
			fmt.Println("Error reading directory:", err)
			return
		}

		var newestModTime time.Time
		for _, file := range files {
			info, err := file.Info()
			if err != nil {
				fmt.Println("Error getting file info:", err)
				continue
			}
			if info.ModTime().After(newestModTime) {
				newestModTime = info.ModTime()
			}
		}

		if newestModTime.After(lastModTime) {
			lastModTime = newestModTime
			notifyClients()
		}

		time.Sleep(1 * time.Second) // Check every second
	}
}

func notifyClients() {
	for client := range clients {
		err := client.WriteMessage(websocket.TextMessage, []byte("refresh"))
		if err != nil {
			fmt.Println("Error sending message:", err)
			client.Close()
			delete(clients, client)
		}
	}
}
