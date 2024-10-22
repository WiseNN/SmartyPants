//
//  ChatViewmodel.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation
import GoogleGenerativeAI
import _PhotosUI_SwiftUI
import SwiftUI

class ChatViewModel: ObservableObject {
	@Published var hasErr = false
	var errMsg = ""
	@Published var msgText = ""
	
	@Published var msgAry: [GenAI_Request_DTO] = [
		GenAI_Response_Parts_DTO(role: .user, parts: [GenAI_Message_Text_DTO(text: "Me dnvsjkdf vkjsd fnvkjsn flvkjs ndflvkj sdfkvjnsldkfjnvlskjfv lksjdfnvlkjsdfn vlkjsd fvlkjsdn flvkjfsdnf l kvj sdlfkvjn sdlkfvjn lsdkfjv lskjdfvn lksjdfnv lksjnvklsfdv")]),
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
	func sendChat(msg: String, hasImage: Bool = false)  {
		self.sendChatTask?.cancel()
			//if user sent last message, attach this message to last else add a new message in ary
			if self.msgAry.last?.role == .user  {
				if hasImage {
					var lastMsg = self.msgAry.removeLast()
					lastMsg.parts.append(GenAI_Message_Images_DTO(inline_data: GenAI_Message_Images_Data_DTO(data: msg)))
					
					self.msgAry.append(lastMsg)
				} else {
					var lastMsg = self.msgAry.removeLast()
					lastMsg.parts.append(GenAI_Message_Text_DTO(text: msg))
					self.msgAry.append(lastMsg)
				}
			} else {
				if hasImage {
					self.msgAry.append(GenAI_Request_DTO(role: .user, parts: [GenAI_Message_Images_DTO(inline_data: GenAI_Message_Images_Data_DTO(data: msg))]))
				} else {
					self.msgAry.append(GenAI_Request_DTO(role: .user, parts: [GenAI_Message_Text_DTO(text: msg)]))
				}
				
			}
		self.msgText = ""
		
		self.sendChatTask = Task(priority: .userInitiated) {
			do {
				
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
						DispatchQueue.main.async {
							self.errMsg = String(data: data, encoding: .utf8) ?? "Network Error"
							self.hasErr = true
						}
					} else {
						DispatchQueue.main.async {
							self.errMsg = "Network Error"
							self.hasErr = true
						}
					}
					return
				}
				print("RESPONSE: \(String(data: data, encoding: .utf8) ?? "[No Response]")")
//				let dtoConvos = try? JSONSerialization.jsonObject(with: data) as? NSDictionary
				
				
				let dtoResponse = try JSONDecoder().decode(GenAI_Response_DTO.self, from: data)
				
				if data.count > 0, let lastMsg = dtoResponse.candidates?.first?.content.parts.last {
					
					if let obj = lastMsg as? JSONObject {
						for (key, value) in obj {
							switch value {
								case .string(let textValue):
									if key == "text" {
										DispatchQueue.main.async {
											let textDTO = GenAI_Message_Text_DTO(text: textValue)
											self.msgAry.append(GenAI_Response_Parts_DTO(role: .model, parts: [textDTO]))
										}
									}
										
									break
								default:
									print("Error [LOGIC]: Case unhandled.")
									self.errMsg = "Internal Error"
									self.hasErr = true
									break
							}
						}
					} else if let imageDTO = lastMsg as? GenAI_Message_Images_DTO {
						DispatchQueue.main.async {
							self.msgAry.append(GenAI_Response_Parts_DTO(role: .model, parts: [imageDTO]))
						}
					}
					print("AI~Response: \(lastMsg)")
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
	func photoRetrievalError(msg: String) {
		DispatchQueue.main.async {
			self.errMsg = msg
			self.hasErr = true
		}
	}
	func sendPhoto(pickerItem: PhotosPickerItem, with textMsg: String? = nil) {
		
		Task {
			do {
				let retrievedUIImage = try await pickerItem.convert()
				guard let imageData = retrievedUIImage.jpegData(compressionQuality: 0.3) else {
					self.errMsg = "Sorry, we are having trouble sending this image. Please contact support. Thank you!🙂"
					self.hasErr = true
					return
				}
				let baseEncoded64ImageStr = imageData.base64EncodedString()
				if let textMsg, !textMsg.isEmpty {
					DispatchQueue.main.sync {
						self.msgAry.append(GenAI_Request_DTO(role: .user, parts: [GenAI_Message_Text_DTO(text: textMsg)]))
						self.sendChat(msg: baseEncoded64ImageStr, hasImage: true)
					}
				}
			} catch let err {
				self.errMsg = "\(err)"
				self.hasErr = true
			}
		}
	}
	
}


