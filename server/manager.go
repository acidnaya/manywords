package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

type Manager struct {
	sync.Mutex
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
		}
	}
	fmt.Println(fmt.Sprintf("Creating new game! \n"))
	m.AddGame(player, false)
}

func (m *Manager) AddGame(player Player, private bool) {
	var game = Game{
		GameID:         m.GenerateID(),
		Private:        private,
		GameMasterId:   player.ID,
		GameHasStarted: false,
		Players:        make(map[string]Player),
		messages:       make(chan *Message, 20),
	}
	go game.LobbyGame()
	fmt.Printf("Game #%d was created!\n", game.GameID)
	game.AddPlayer(player)
	m.Lock()
	defer m.Unlock()
	m.games[game.GameID] = game
}

func (m *Manager) RemoveGame(id int) {
	m.Lock()
	defer m.Unlock()
	delete(m.games, id)
}
