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
	@Published var msgText = ""
	
	@Published var msgAry: [GenAI_Request_DTO] = [
		GenAI_Response_Parts_DTO(role: .user, parts: [GenAI_Message_Text_DTO(text: "Me")]),
		GenAI_Response_Parts_DTO(role: .model, parts: [GenAI_Message_Text_DTO(text: "You")]),
		GenAI_Response_Parts_DTO(role: .user, parts: [GenAI_Message_Text_DTO(text: "Me")]),
		GenAI_Response_Parts_DTO(role: .model, parts: [GenAI_Message_Text_DTO(text: "You")])
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
		self.sendChatTask?.cancel()
		
	
		
		self.sendChatTask = Task {
			do {
				await MainActor.run {
					if self.msgAry.last?.role == .user  {
						var lastMsg = self.msgAry.removeLast()
						lastMsg.parts.append(GenAI_Message_Text_DTO(text: msg))
						self.msgAry.append(lastMsg)
					} else {
						self.msgAry.append(GenAI_Request_DTO(role: .user, parts: [GenAI_Message_Text_DTO(text: msg)]))
					}
				}
				let urlStr = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(Keys.API.default)"
				let url = URL(string: urlStr)!
				var urlRequest = URLRequest(url: url)
				urlRequest.httpMethod = "POST"
				urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
				
				
				let genAIConvo = GenAI_Convo_Request_DTO(contents: self.msgAry)
				let encodedConvo = try genAIConvo.encoded()

				urlRequest.httpBody = encodedConvo
				print("BODY: \(String(data: urlRequest.httpBody!, encoding: .utf8) ?? "[No Body]")")
				let (data, urlResp) = try await URLSession.shared.data(for: urlRequest)
				
				guard let httpResp = urlResp as? HTTPURLResponse, (200..<300).contains(httpResp.statusCode) else {
					if data.count > 0 {
						self.errMsg = String(data: data, encoding: .utf8) ?? "Network Error"
						self.hasErr = true
					} else {
						self.errMsg = "Network Error"
						self.hasErr = true
					}
					return
				}
				print("RESPONSE: \(String(data: data, encoding: .utf8) ?? "[No Response]")")
//				let dtoConvos = try? JSONSerialization.jsonObject(with: data) as? NSDictionary
				
				
				let dict = try JSONSerialization.jsonObject(with: data) as? NSDictionary
				let dtoResponse = try JSONDecoder().decode(GenAI_Response_DTO.self, from: data)
				
				if data.count > 0, let lastMsg = dtoResponse.candidates?.first?.content.parts.last {
					print("AI~Response: \(lastMsg)")
					DispatchQueue.main.async {
						self.msgAry.append(GenAI_Response_Parts_DTO(role: .model, parts: [lastMsg]))
						self.msgText = ""
					}
				} else  {
					DispatchQueue.main.async {
						self.errMsg = "Looks like our guy is taking a nap. Please send a message later. Thank you!🙂"
						self.hasErr = true
					}
				}
				
			} catch let err {
				DispatchQueue.main.async {
					print("Err Main: \(err)")
					self.errMsg = err.localizedDescription
					self.hasErr = true
				}
			}
		}
		
	}
	func clearChat() {
		DispatchQueue.main.async {
			self.msgAry.removeAll()	
		}
	}
}


