//
//  Socket.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation
import UIKit

protocol GameRoomDelegate: AnyObject {
	func received(message: Message)
}

class GameRoom: NSObject, MoveSenderDelegate {
	var inputStream: InputStream!
	var outputStream: OutputStream!
	var moveWasMade = [Bool](repeating: false, count: 100)
	var moveCounter = 0
	weak var delegate: GameRoomDelegate?
	let maxReadLength = 4096
	let encoder = JSONEncoder()
	let decoder = JSONDecoder()
	let deviceId = UserDefaults.standard.string(forKey: DefaultsKeys.username)
	
	func initn(gc: GameRoomDelegate) {
		delegate = gc
	}
	
	func setupNetworkCommunication() {
		var readStream: Unmanaged<CFReadStream>?
		var writeStream: Unmanaged<CFWriteStream>?
		CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
										   "localhost" as CFString,
										   8080,
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
	
	func send(message: String, type: String) {
		if (type == "move") {
			moveWasMade[moveCounter] = true
		}
		let msg = Message(e: type, p: deviceId!, g: "", o: "", s: "", a: message, ms: "", t: "", f: "false")
		send(message: msg)
	}
	
	func send(message: Message) {
		var data = "defaultinfo".data(using: .utf8)!

		do {
			data = try encoder.encode(message)
		} catch {
			print(error)
		}
		print(String(data: data, encoding: .utf8)!)

		data.withUnsafeBytes {
			guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
				print("Error sending")
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
			readAvailableBytes(stream: aStream as! InputStream)
		case .endEncountered:
			stopGameSession()
		default:
			print("Не удалось распознать сообщение")
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
			print("numberOfBytesRead: " + String(numberOfBytesRead))
			
			if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
				delegate?.received(message: message)
			} else {
				print("Не удалось сконструировать сообщение")
				stopGameSession()
			}
		}
	}
	
	private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
										length: Int) -> Message? {
		var msg : Message
		if let str = (String(
			bytesNoCopy: buffer,
			length: length,
			encoding: .utf8,
			freeWhenDone: true)?.data(using: .utf8)!) {
			do {
				msg = try decoder.decode(Message.self, from: str)
				return msg
			} catch {
				print(error)
				return nil
			}
		}
		return nil
	}
}
