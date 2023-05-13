package main // go run *.go

import (
	"fmt"
	"log"
	"net"
	"os"
)

var (
	CHOST   = "127.0.0.1"
	CPORT   = "8080"
	CNET    = "tcp"
	manager = Manager{
		games: make(map[int]Game),
	}
)

// MSG is used in transporting individual messages
type MSG struct {
	username string
	msg      string
	isLast   bool

	conn *net.TCPConn
}

// User contains username
type User struct {
	Iam string `json:"iam,omitempty"`
}

func main() {
	//Create addr
	addr, err := net.ResolveTCPAddr(CNET, CHOST+":"+CPORT)
	handleError(err)

	//Create listener
	tcpListener, err := net.ListenTCP(CNET, addr)
	handleError(err)

	defer func(tcpListener *net.TCPListener) {
		err := tcpListener.Close()
		if err != nil {
			handleError(err) // ТУТ ПЕРЕДЕЛАЛА И КАКАЯ_ТО ХУЕТА ХУЕТ
		}
	}(tcpListener)

	//Create broadcaster
	var broadcaster = make(chan *MSG, 1)
	defer close(broadcaster)
	c := &Connections{
		conns: make(map[string]*net.TCPConn),
	}
	//go c.broadcast(broadcaster)

	fmt.Println("Listening on " + CHOST + ":" + CPORT)
	for {
		// Listen for an incoming connection.
		conn, err := tcpListener.AcceptTCP()
		handleError(err)
		c.New(conn.RemoteAddr().String(), conn)

		// Handle connections in a new goroutine.
		go handleRequest(conn, broadcaster)
	}
}

func handleRequest(conn *net.TCPConn, messages chan *MSG) {
	defer func(conn *net.TCPConn) {
		//err := conn.Close()
		//if err != nil {
		//	handleError(err)
		//}
		fmt.Println("Close connection tipa")
	}(conn)

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
		fmt.Println("Finding fast game...")
		manager.AddPlayer(player)
		fmt.Println("Worked with manager...")
	} else if message.EventType == "exit" {
		return
	}

}

func handleError(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
