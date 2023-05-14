package main

import (
	"fmt"
	"log"
	"os"
	"strings"
)

type Syllable struct {
	Syllable string
	Words    map[string]bool
}

func (s Syllable) Init(syl string, str []string) {
	s.Syllable = syl
	for _, st := range str {
		s.Words[st] = true
	}
}

func (Syllable) New(syl string, str []string) (s Syllable) {
	s.Syllable = syl
	s.Words = make(map[string]bool)
	for _, st := range str {
		s.Words[st] = true
	}
	return s
}

func (s Syllable) PrintSyllable() {
	fmt.Println(s.Syllable + ":")
	for key, _ := range s.Words {
		fmt.Print(key + ", ")
	}
	fmt.Println(" ")
}

func getSyllables() []Syllable {
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	fmt.Println(path)

	f, err := os.Open(path + "/syllables")
	if err != nil {
		fmt.Println(err)
		return nil
	}
	files, err := f.Readdir(0)
	if err != nil {
		fmt.Println(err)
		return nil
	}

	var syllables []Syllable
	for _, v := range files {
		fmt.Println(v.Name())
		dat, err := os.ReadFile(path + "/syllables/" + v.Name())
		if err != nil {
			fmt.Println(err)
			return nil
		}
		array := strings.Split(string(dat[:]), ",")
		syllables = append(syllables, Syllable.New(Syllable{}, v.Name(), array))
	}
	return syllables
}
