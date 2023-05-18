package main

import (
	"fmt"
	"net"
	"time"
)

type Player struct {
	ID          string
	IsPlaying   bool
	IsReceiving bool
	Connection  *net.TCPConn
	messages    chan *Message
}

func (p Player) GetMove() (msg *Message) {
	select {
	case msg := <-p.messages:
		fmt.Println("Ход был отправлен\n")
		return msg
	case <-time.After(5 * time.Second):
		fmt.Println("Ход не был отправлен\n")
		return Message.constructEmptyMove(Message{}, p.ID)
	}
}
