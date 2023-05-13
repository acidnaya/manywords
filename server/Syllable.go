package main

import "fmt"

/*
set := make(map[string]bool) // Новый пустой набор
set["Foo"] = true            // Добавить
for k := range set {         // Пройти в цикле
    fmt.Println(k)
}
delete(set, "Foo")    // Удалить
size := len(set)      // Размер
exists := set["Foo"]  //
*/

type Syllable struct {
	Syllable string
	Words    map[string]bool
}

func (s Syllable) New(syl string, str []string) {
	s.Syllable = syl
	for _, st := range str {
		s.Words[st] = true
	}
}

func (s Syllable) PrintSyllable() {
	fmt.Printf("syllable: " + s.Syllable)
}
