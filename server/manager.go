package main

import (
	"fmt"
	"math/rand"
	"time"
)

type Manager struct {
	//sync.Mutex
	games map[int]Game
}

func (m *Manager) GenerateID() int {
	rand.Seed(time.Now().UnixNano())
	for {
		min := 100000
		max := 999999
		rndnum := rand.Intn(max-min+1) + min
		if _, exists := m.games[rndnum]; !exists {
			return rndnum
		}
	}
}

func (m *Manager) AddPlayer(player Player) {
	for _, game := range m.games {
		if !game.GameHasStarted && !game.Private {
			if game.AddPlayer(player) {
				return
			}
			//fmt.Println(fmt.Sprintf("Number of game players: %d\n", len(game.Players)))
			//if len(game.Players) > 1 { // >1
			//	fmt.Println(fmt.Sprintf("Player > 1 \n"))
			//	go game.StartGame()
			//}
		}
	}
	fmt.Println(fmt.Sprintf("Creating new game! \n"))
	m.AddGame(player, false)
	// fmt.Println(fmt.Sprintf("New game was created! \n"))
}

//func (m *Manager) AddPlayerByID(player Player, id int) {
//	if game, exists := m.games[id]; exists && !game.GameHasStarted {
//		game.AddPlayer(player)
//	} else {
//		m.AddGame(player, false)
//	}
//}

func (m *Manager) AddGame(player Player, private bool) {
	//m.Lock()
	//defer m.Unlock()
	var game = Game{
		GameID:         m.GenerateID(),
		Private:        private,
		GameMasterId:   player.ID,
		GameHasStarted: false,
		Players:        make(map[string]Player),
		messages:       make(chan *Message, 20), // мб 1???
	}
	//go game.broadcast() // moved here
	go game.LobbyGame()
	fmt.Printf("Game #%d was created!\n", game.GameID)
	game.AddPlayer(player)
	m.games[game.GameID] = game
}

func (m *Manager) RemoveGame(id int) {
	//m.Lock()
	//defer m.Unlock()
	delete(m.games, id)
}
