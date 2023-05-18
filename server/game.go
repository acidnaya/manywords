package main

import (
	"fmt"
	"sort"
	"time"
)

type Game struct {
	GameID         int
	Private        bool
	GameMasterId   string
	GameHasStarted bool
	//CreationTime   time.Time
	MoveTime        int
	Syllables       []Syllable
	SyllableCounter int
	ActivePlayers   map[string]Player
	PlayersKeys     []string
	MoveWasMade     bool
	//sync.Mutex
	Players  map[string]Player
	messages chan *Message
}

func (g *Game) LobbyGame() {
	// возможно удалить из списка игр
	go g.broadcast() // moved here
	i := 10
	for i > 0 {
		time.Sleep(1 * time.Second)
		g.messages <- Message.constructTimerMessage(Message{}, i, g)
		i -= 1
	}
	if len(g.Players) > 1 {
		g.StartGame()
	} else {
		g.messages <- Message.constructEndMessage(Message{})
		time.Sleep(1 * time.Second)
		g.EndGame() // вот тут мы застреваем почему-то
	}
}

func (g *Game) HandleConnection(p Player) {
	for {
		if !p.IsPlaying {
			break
		}
		message, err := DeserializeClientMsg(p.Connection)
		if err != nil || message.EventType == "exit" {
			//fmt.Printf("Error reading message from %s: %s\n", p.ID, err.Error())
			fmt.Printf("Player %s left game.\n", p.ID)
			g.RemovePlayer(p)
			break
		}
		p.messages <- message
	}
}

func (g *Game) getSyllable() string {
	return g.Syllables[g.SyllableCounter%len(g.Syllables)].Syllable
}

func (g *Game) AddPlayer(player Player) (b bool) {
	//g.Lock()
	//defer g.Unlock()
	if len(g.Players) < 5 {
		g.Players[player.ID] = player
		fmt.Println(fmt.Sprintf("Player %s was added to game #%d!\n", player.ID, g.GameID))
		go g.HandleConnection(player)
		return true
	} else {
		return false
	}
}

func (g *Game) RemoveActivePlayer(player Player) {
	//g.Lock()
	//defer g.Unlock()
	player.IsPlaying = false
	delete(g.ActivePlayers, player.ID)
}

func (g *Game) RemovePlayer(player Player) {
	//g.Lock()
	//defer g.Unlock()
	player.IsReceiving = false
	delete(g.Players, player.ID)
	g.RemoveActivePlayer(player)
	g.CloseConnection(player)
}

func (g *Game) broadcast() {
	//Loop continually sending messages
	for {
		time.Sleep(100 * time.Millisecond)
		msg := <-g.messages
		message, err := SerializeClientMsg(msg)
		if err != nil {
			fmt.Printf("Error in Game.broadcast while serializing!\n")
			break
		}
		for _, player := range g.Players {
			if !player.IsReceiving {
				continue
			}
			_, err := player.Connection.Write(message)
			if err != nil {
				fmt.Printf("Error while writing to player %s!\n", player.ID)
				g.RemovePlayer(player)
			} else {
				stringMessage := string(message[:])
				fmt.Printf("Succesfully wrote message:\n %s \n to %s!\n", stringMessage, player.ID)
			}
		}
		if len(g.Players) == 0 {
			fmt.Printf("No players are left!\n")
			break
		}
	}
	fmt.Printf("Broadcaster is done!\n")
	//for _, player := range g.Players {
	//	g.CloseConnection(player)
	//}
}

func (g *Game) CloseConnection(player Player) {
	err := player.Connection.Close()
	if err != nil {
		fmt.Printf("Error while closing connection with player #%s!\n", player.ID)
	} else {
		fmt.Printf("Succesfully closed connection with player #%s.\n", player.ID)
	}
}

func (g *Game) StartGame() {
	g.GameHasStarted = true
	manager.RemoveGame(g.GameID)
	fmt.Printf("Game #%d has started\n", g.GameID)
	g.GamePreprocess()
	fmt.Printf("Preprocess ended\n")
	g.GameProcess()
	g.EndGame()
}

func (g *Game) EndGame() {
	fmt.Printf("Попал в EndGame #%d\n", g.GameID)
	time.Sleep(11 * time.Second)
	fmt.Printf("End of game #%d\n", g.GameID)
	for _, player := range g.Players {
		g.RemovePlayer(player)
	}
	close(g.messages)
	manager.RemoveGame(g.GameID)
}

func (g *Game) GamePreprocess() {
	g.MoveTime = 5000000000
	g.SyllableCounter = 0

	g.Syllables = getSyllables()

	g.ActivePlayers = map[string]Player{}
	for key, value := range g.Players {
		g.ActivePlayers[key] = value
	}
}

func (g *Game) ValidateMove(move string) bool {
	syllable := g.Syllables[g.SyllableCounter%len(g.Syllables)]
	_, ok := syllable.Words[move]
	if ok {
		fmt.Printf("Был сделан ВЕРНЫЙ ход: %s!\n", move)
	} else {
		fmt.Printf("Был сделан НЕВЕРНЫЙ ход: %s!\n", move)
	}
	return ok
}

func (g *Game) UpdatePlayerKeys() {
	g.PlayersKeys = make([]string, 0, len(g.ActivePlayers))

	for k := range g.ActivePlayers {
		g.PlayersKeys = append(g.PlayersKeys, k)
	}
	sort.Strings(g.PlayersKeys)
}

func (g *Game) GameRound() {

	g.UpdatePlayerKeys() // поменяла.........

	for _, key := range g.PlayersKeys {
		time.Sleep(100 * time.Millisecond)
		message := Message.constructChangeMsg(Message{}, g.ActivePlayers[key].ID, g)
		g.messages <- message
		// time.Sleep(100 * time.Millisecond)
		fmt.Println(fmt.Sprintf("Player %s move", g.ActivePlayers[key].ID))
		g.MoveWasMade = false
		player, ok := g.ActivePlayers[key]
		if !ok {
			continue
		}
		for !g.MoveWasMade {
			message := player.GetMove()
			g.HandleMessage(message) // убрать флаг то сделан ход
		}
		g.SyllableCounter += 1
	}
}

func (g *Game) HandleMessage(message *Message) {
	switch message.EventType {
	case "attempt":
		fmt.Printf("Attempt was made\n")
		g.messages <- message
	case "move":
		fmt.Printf("Move was made\n")
		g.MoveWasMade = true
		if g.ValidateMove(message.MoveAttempt) {
			msg := Message.constructMoveMsg(Message{}, message.PlayerID, message.MoveAttempt, "correct", g)
			g.messages <- msg
		} else {
			msg := Message.constructMoveMsg(Message{}, message.PlayerID, message.MoveAttempt, "incorrect", g)
			g.messages <- msg
			g.RemoveActivePlayer(g.ActivePlayers[message.PlayerID]) // проблема тут???
		}
		time.Sleep(3000 * time.Millisecond)
	case "exit":
		g.RemovePlayer(g.Players[message.PlayerID])
	default:
		break
	}
}

func (g *Game) GameProcess() {

	for {
		if len(g.ActivePlayers) == 0 {
			//g.EndGame()
			msg := Message.constructTieMessage(Message{})
			g.messages <- msg
			return
		}
		if len(g.ActivePlayers) == 1 {
			msg := Message.constructWinnerMessage(Message{}, g)
			g.messages <- msg
			//g.EndGame()
			return
		}
		g.GameRound()
		//g.ActivePlayers = g.Players
	}
}
