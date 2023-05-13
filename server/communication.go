package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net"
)

func readFromConnection(connection *net.TCPConn) ([]byte, error) {
	buf := make([]byte, 2048)
	_, err := connection.Read(buf)
	if err != nil {
		fmt.Println("Error reading:", err.Error())
		return nil, err
	}

	buf = bytes.Trim(buf, "\x00")

	return buf, nil
}

func DeserializeClientMsg(connection *net.TCPConn) (*Message, error) {
	var data, err = readFromConnection(connection)
	if err != nil {
		return nil, err
	}
	var message Message
	err = json.Unmarshal(data, &message)
	if err != nil {
		fmt.Println("Error deserializing message:", err.Error())
		return nil, err
	}

	return &message, nil
}

func SerializeClientMsg(message *Message) ([]byte, error) {
	bytes, err := json.Marshal(message)
	if err != nil {
		fmt.Println("Error serializing message:", err.Error())
		return nil, err
	}

	return bytes, nil
}
