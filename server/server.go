package main // go run *.go

import (
	"fmt"
	"log"
	"net"
)

var (
	CHOST   = "127.0.0.1"
	CPORT   = "8080"
	CNET    = "tcp"
	manager = Manager{
		games: make(map[int]Game),
	}
)

func main() {
	addr, err := net.ResolveTCPAddr(CNET, CHOST+":"+CPORT)
	handleError(err)
	tcpListener, err := net.ListenTCP(CNET, addr)
	handleError(err)

	defer func(tcpListener *net.TCPListener) {
		err := tcpListener.Close()
		if err != nil {
			handleError(err)
		}
	}(tcpListener)

	c := &Connections{
		conns: make(map[string]*net.TCPConn),
	}

	fmt.Println("Listening on " + CHOST + ":" + CPORT)
	for {
		conn, err := tcpListener.AcceptTCP()
		handleError(err)
		c.New(conn.RemoteAddr().String(), conn)
		go handleRequest(conn)
	}
}

func CloseConnection(conn *net.TCPConn) {
	err := conn.Close()
	if err != nil {
		log.Println(err)
		fmt.Printf("Error while closing connection!\n")
	}
}

func handleRequest(conn *net.TCPConn) {
	fmt.Printf("Handling connection!\n")
	var message, err = DeserializeClientMsg(conn)
	if err != nil {
		return
	}

	player := Player{
		ID:          message.PlayerID,
		IsPlaying:   true,
		IsReceiving: true,
		Connection:  conn,
		messages:    make(chan *Message, 20),
	}

	if message.EventType == "fast" {
		manager.AddPlayer(player)
		return
	} else if message.EventType == "change_name" {
		status := changeID(message)
		var message *Message
		if status {
			fmt.Printf("change name status is ok!\n")
			message = Message.constructOkMessage(Message{})
		} else {
			fmt.Printf("change name status is not ok!\n")
			message = Message.constructErrorMessage(Message{})
		}
		bytes, err := SerializeClientMsg(message)
		if err != nil {
			fmt.Printf("Error in server.HandleRequest while serializing!\n")
			return
		}
		conn.Write(bytes)
	}
	CloseConnection(conn)
}

func handleError(err error) {
	if err != nil {
		log.Println(err)
		// os.Exit(1)
	}
}
