//
//  ChatViewmodel.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation
import GoogleGenerativeAI

class ChatViewModel: ObservableObject {
	@Published var hasErr = false
	var errMsg = ""
	
	var msgAry: [ChatMessage] = [
		ChatMessage(userType: .sender, message: "How is the weather today?"),
		ChatMessage(userType: .recipeint, message: "The Weather is great! Have you went outside yet?"),
		ChatMessage(userType: .sender, message: "How is the weather today?"),
		ChatMessage(userType: .recipeint, message: "The Weather is great! Have you went outside yet?"),
		ChatMessage(userType: .recipeint, message: "The Weather is great! Have you went outside yet?"),
		ChatMessage(userType: .sender, message: "How is the weather today?"),
		ChatMessage(userType: .recipeint, message: "The Weather is great! Have you went outside yet?"),
		ChatMessage(userType: .recipeint, message: "The Weather is great! Have you went outside yet?"),
		ChatMessage(userType: .sender, message: "How is the weather today?"),
		ChatMessage(userType: .recipeint, message: "The Weather is great! Have you went outside yet?")
	]
	private let generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: Keys.API.default)
	private var sendChatTask: Task<Void, Never>?
	
	func examplePrompt() async {
		let prompt = "write a story about a magic book"
		print("Prompt: \(prompt)")
		do {
			let response = try await generativeModel.generateContent(prompt)
			if let text = response.text {
				print("Response: \(text)")
			}
		} catch let err {
			print("ERROR::GenAI: -- \(err.localizedDescription)")
		}
	}
	func sendChat(msg: String)  {
		self.msgAry.append(ChatMessage(userType: .sender, message: msg))
		self.sendChatTask = Task {
			do {
				let response = try await generativeModel.generateContent(msg)
				if let recipeintMsg = response.text {
					print("AI~Response: \(recipeintMsg)")
					DispatchQueue.main.async {
						self.msgAry.append(ChatMessage(userType: .recipeint, message: recipeintMsg))
					}
				} else {
					
				}
			} catch let err {
				hasErr = true
				errMsg = err.localizedDescription
			}
		}
		
	}
	func clearChat() {
		DispatchQueue.main.async {
			self.msgAry.removeAll()
			
		}
	}
}


enum UserType { case sender, recipeint }
struct ChatMessage: Identifiable {
	var id = UUID()
	var userType: UserType
	var message: String
}
