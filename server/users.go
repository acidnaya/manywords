package main

import (
	"fmt"
	"log"
	"os"
	"strings"
)

func readUserInfo() (lines []string) {
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}

	dat, err := os.ReadFile(path + "/users/ids")
	if err != nil {
		fmt.Println(err)
		return
	}
	lines = strings.Split(string(dat[:]), ",")
	return
}

func writeUserInfo(users map[string]bool) {
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	keys := make([]string, len(users))
	i := 0
	for k := range users {
		keys[i] = k
		i++
	}
	line := strings.Join(keys[:], ",")
	data := []byte(line)
	_ = os.WriteFile(path+"/users/ids", data, 0666)
}

func changeID(message *Message) (status bool) {
	lines := readUserInfo()
	users := make(map[string]bool)
	for _, line := range lines {
		users[line] = true
	}
	_, ok := users[message.MoveAttempt]
	if ok {
		return false
	} else {
		delete(users, message.PlayerID)
		users[message.MoveAttempt] = true
	}
	writeUserInfo(users)
	return true
}
