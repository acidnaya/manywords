//
//  Socket.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation
import UIKit

protocol GameRoomDelegate: AnyObject { // тут был class
	func received(message: Message)
}

class GameRoom: NSObject {
	//1
	var inputStream: InputStream!
	var outputStream: OutputStream!
	
	weak var delegate: GameRoomDelegate?
	
	//2
	var username = ""
	
	//3
	let maxReadLength = 4096
	
	func setupNetworkCommunication() {
		// 1
		var readStream: Unmanaged<CFReadStream>?
		var writeStream: Unmanaged<CFWriteStream>?
		
		// 2
		CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
										   "localhost" as CFString,
										   80,
										   &readStream,
										   &writeStream)
		
		inputStream = readStream!.takeRetainedValue()
		outputStream = writeStream!.takeRetainedValue()
		
		inputStream.delegate = self
		
		inputStream.schedule(in: .current, forMode: .common)
		outputStream.schedule(in: .current, forMode: .common)
		
		inputStream.open()
		outputStream.open()
	}
	
	func joinGame(username: String) {
		//1
		let data = "iam:\(username)".data(using: .utf8)!
		
		//2
		self.username = username
		
		//3
		data.withUnsafeBytes {
			guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
				print("Error joining game")
				return
			}
			//4
			outputStream.write(pointer, maxLength: data.count)
		}
	}
	
	func send(message: String) {
		let data = "msg:\(message)".data(using: .utf8)!
		
		data.withUnsafeBytes {
			guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
				print("Error joining game")
				return
			}
			outputStream.write(pointer, maxLength: data.count)
		}
	}
	
	func stopGameSession() {
		inputStream.close()
		outputStream.close()
	}
	
}

extension GameRoom: StreamDelegate {
	func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
		switch eventCode {
		case .hasBytesAvailable:
			print("new message received")
			readAvailableBytes(stream: aStream as! InputStream)
		case .endEncountered:
			print("new message received")
			stopGameSession()
		case .errorOccurred:
			print("error occurred")
		case .hasSpaceAvailable:
			print("has space available")
		default:
			print("some other event...")
		}
	}
	
	private func readAvailableBytes(stream: InputStream) {
		let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
		while stream.hasBytesAvailable {
			let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
			
			if numberOfBytesRead < 0, let error = stream.streamError {
				print(error)
				break
			}
			
			// Construct the message object
			if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
				// Notify interested parties
				delegate?.received(message: message)
			}
		}
	}
	
	private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
										length: Int) -> Message? {
		//1
		if let stringArray = String(
			bytesNoCopy: buffer,
			length: length,
			encoding: .utf8,
			freeWhenDone: true)?.components(separatedBy: ":"), stringArray.count == 5 {
			let activePlayer = stringArray[0]
			let move = stringArray[1]
			let syllable = stringArray[2]
			let moveStatus = stringArray[3]
			let players = stringArray[4].components(separatedBy: ",")
			return Message(activePlayer: activePlayer, move: move, syllable: syllable, moveStatus: MoveStatus(rawValue: moveStatus) ?? MoveStatus.incomplete, players: players)
		}
		else {
			return nil
		}
	}
}
