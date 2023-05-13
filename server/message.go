package main

import (
	"strconv"
	"strings"
)

type Message struct {
	EventType    string // change_player round move attempt winner error timer exit end
	PlayerID     string
	GameID       string
	OtherPlayers string // список через ,
	Syllable     string
	MoveAttempt  string
	MoveStatus   string // correct, incorrect
	Time         string // в перспективе замена на инт, миллисекунды
	Final        string // true false
}

func (Message) constructEndMessage() (msg *Message) {
	var message = &Message{
		EventType:    "end",
		PlayerID:     "",
		GameID:       "",
		OtherPlayers: "",
		Syllable:     "",
		MoveAttempt:  "",
		MoveStatus:   "",
		Time:         "",
		Final:        "",
	}
	return message
}

func (Message) constructEmptyMove(id string) (msg *Message) {
	var message = &Message{
		EventType:    "move",
		PlayerID:     id,
		GameID:       "",
		OtherPlayers: "",
		Syllable:     "",
		MoveAttempt:  "",
		MoveStatus:   "",
		Time:         "",
		Final:        "",
	}
	return message
}

func (Message) constructTimerMessage(time int, g *Game) (msg *Message) {
	keys := make([]string, len(g.Players))

	i := 0
	for k := range g.Players {
		keys[i] = k
		i++
	}

	var message = &Message{
		EventType:    "timer",
		PlayerID:     "",
		GameID:       "",
		OtherPlayers: strings.Join(keys, ","),
		Syllable:     "",
		MoveAttempt:  "",
		MoveStatus:   "",
		Time:         strconv.Itoa(time),
		Final:        "",
	}
	return message
}

func (Message) constructMoveMsg(id, move, status string, g *Game) *Message {
	keys := make([]string, len(g.ActivePlayers))

	i := 0
	for k := range g.ActivePlayers {
		keys[i] = k
		i++
	}
	var message = &Message{
		EventType:    "move",
		PlayerID:     id,
		GameID:       strconv.Itoa(g.GameID),
		OtherPlayers: strings.Join(keys, ","),
		Syllable:     g.getSyllable(),
		MoveAttempt:  move,
		MoveStatus:   status,
		Time:         "",
		Final:        "",
	}
	return message
}

func (Message) constructWinnerMessage(g *Game) *Message {
	keys := make([]string, len(g.ActivePlayers))

	i := 0
	for k := range g.ActivePlayers {
		keys[i] = k
		i++
	}
	id := "Nobody"
	if len(keys) == 1 {
		id = keys[0]
	}
	var message = &Message{
		EventType:    "winner",
		PlayerID:     id,
		GameID:       strconv.Itoa(g.GameID),
		OtherPlayers: strings.Join(keys, ","),
		Syllable:     "",
		MoveAttempt:  "",
		MoveStatus:   "",
		Time:         "",
		Final:        "",
	}
	return message
}

func (Message) constructTieMessage() *Message {
	var message = &Message{
		EventType:    "tie",
		PlayerID:     "",
		GameID:       "",
		OtherPlayers: "",
		Syllable:     "",
		MoveAttempt:  "",
		MoveStatus:   "",
		Time:         "",
		Final:        "",
	}
	return message
}

func (Message) constructChangeMsg(id string, g *Game) *Message {
	keys := make([]string, len(g.ActivePlayers))

	i := 0
	for k := range g.ActivePlayers {
		keys[i] = k
		i++
	}
	var message = &Message{
		EventType:    "change_player",
		PlayerID:     id,
		GameID:       strconv.Itoa(g.GameID),
		OtherPlayers: strings.Join(keys, ","),
		Syllable:     g.getSyllable(),
		MoveAttempt:  "",
		MoveStatus:   "",
		Time:         "",
		Final:        "",
	}
	return message
}
