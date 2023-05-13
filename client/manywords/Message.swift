//
//  Move.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation

struct Message : Codable {
	let EventType:   	String
	let PlayerID:    	String
	let GameID:      	String
	let OtherPlayers:	String
	let Syllable:    	String
	let MoveAttempt: 	String
	let MoveStatus:   	String
	let Time:         	String
	let Final:       	String
	
	init(e: String, p: String, g: String, o: String, s: String, a: String, ms: String, t: String, f: String) {
		EventType = e
		PlayerID = p
		GameID = g
		OtherPlayers = o
		Syllable = s
		MoveAttempt = a
		MoveStatus = ms
		Time = t
		Final = f
	}
	
	func printmsg() {
		print("EventType = " + EventType)
		print("PlayerID = " + PlayerID)
		print("GameID = " + GameID)
		print("OtherPlayers = " + OtherPlayers)
		print("Syllable = " + Syllable)
		print("MoveAttempt = " + MoveAttempt)
		print("MoveStatus = " + MoveStatus)
		print("Time = " + Time)
		print("Final = " + Final)
		
	}
}
