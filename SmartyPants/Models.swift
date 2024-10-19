//
//  Models.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation


enum UserType { case sender, recipeint }
enum API_UserType: String, Codable { case user, model }
struct ChatMessage: Identifiable {
	var id = UUID()
	var userType: UserType
	var message: String
}
extension ChatMessage: Equatable {
	
}

struct GenAI_Convo_Request_DTO: Codable {
	var contents: [GenAI_Request_DTO]?
	init(from decoder: any Decoder) throws {
		
		do {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.contents = try container.decode([GenAI_Response_Parts_DTO].self, forKey: .contents)
			
		} catch let err {
			print("Decode err: \(err)")
			
		}
		
	}
	init(contents: [GenAI_Request_DTO]) {
		self.contents = contents
	}
}

struct GenAI_Convo_Response_DTO: Codable {
	var content: [GenAI_Response_Parts_DTO]?
	init(from decoder: any Decoder) throws {
		
		do {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.content = try container.decode([GenAI_Response_Parts_DTO].self, forKey: .content)
			
		} catch let err {
			print("Decode err: \(err)")
			
		}
		
	}
	init(content: [GenAI_Request_DTO]) {
		self.content = content
	}
}


struct GenAI_Response_DTO: Codable {
	var candidates: [GenAI_Response_Candidates]?
	var usageMetadata: GenAI_UsageMetadata?
	init(candidates: [GenAI_Response_Candidates], usageMetadata: GenAI_UsageMetadata) {
		self.candidates = candidates
		self.usageMetadata = usageMetadata
	}
	init(from decoder: any Decoder) throws {
		
		do {
			
				let container = try decoder.container(keyedBy: CodingKeys.self)
			self.usageMetadata = try container.decode(GenAI_UsageMetadata.self, forKey: .usageMetadata)
				self.candidates = try container.decode([GenAI_Response_Candidates].self, forKey: .candidates)
				
			
		}catch let err {
			print("Err 2: \(err)")
		}
	}
}
typealias GenAI_Response_Parts_DTO = GenAI_Request_DTO
struct GenAI_Response_Candidates: Codable {
	var content: GenAI_Response_Parts_DTO
	var finishReason: String
	var index: Int64
	var safetyRatings: [GenAI_Response_SafetyRating]
	
}
struct GenAI_Response_SafetyRating: Codable {
	var category: String
	var probability: String
}
struct GenAI_Request_DTO: Codable, Identifiable, Equatable {
	var id = UUID()
	var role: API_UserType
	var parts: [GenAI_Message_Text_DTO]
	enum CodingKeys: String, CodingKey {
		case role, parts
	}
	
	init(id: UUID = UUID(), role: API_UserType, parts: [GenAI_Message_Text_DTO]) {
		self.id = id
		self.role = role
		self.parts = parts
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.role = try container.decode(API_UserType.self, forKey: .role)
		self.parts = try container.decode([GenAI_Message_Text_DTO].self, forKey: .parts)
	}
}
struct GenAI_Message_Text_DTO: Codable, Equatable {
	var text: String
}


struct GenAI_UsageMetadata: Codable {
	var promptTokenCount: Int
	var candidatesTokenCount: Int
	var totalTokenCount: Int
}
