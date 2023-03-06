//
//  Move.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation

enum MoveStatus: String {
	case wrong = "wrong"
	case right = "right"
	case incomplete = "incomplete"
}

struct Message {
	
	let activePlayer: String
	let move: String
	let syllable: String
	let moveStatus: MoveStatus
	let players: [String]
	
	init(activePlayer: String, move: String, syllable: String, moveStatus: MoveStatus, players: [String]) {
		self.activePlayer = activePlayer
		self.move = move
		self.syllable = syllable
		self.moveStatus = moveStatus
		self.players = players
		
	}
}
