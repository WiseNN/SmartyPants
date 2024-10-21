//
//  Models.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation
import GoogleGenerativeAI

enum UserType { case sender, recipeint }
enum API_UserType: String, Codable { case user, model }
struct ChatMessage: Identifiable {
	var id = UUID()
	var userType: UserType
	var message: String
	var linkStr: String? 
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
extension GenAI_Convo_Request_DTO {
	func toDictionary() -> [String: [String: Codable]]? {
		//run bfs
		guard let contents = self.contents else { return  nil }
		var parentDict: [String: [String: Codable]] = [:]
		var userDict: [String: Codable] = [:]
		for item in contents {
			userDict["role"] = item.role.rawValue
			let partsResult = self.generateParts(using: item.parts)
			userDict["parts"] = partsResult
		}
		parentDict["contents"] = userDict
		return parentDict
		
	}
	private func generateParts(using dataAry: [Data]) -> [String] {
		dataAry.map {
			return String(data: $0, encoding: .utf8)!
		}
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

//protocol GenAI_Text_And_Image_Data: Codable {
//	var text: String?
//	var inline_data: String
//}
struct GenAI_Request_DTO: Codable, Identifiable, Equatable {
	var id = UUID()
	var role: API_UserType
	var parts: [Data]
	enum CodingKeys: String, CodingKey {
		case role, parts
	}
	
	init(id: UUID = UUID(), role: API_UserType, parts: [Data]) {
		self.id = id
		self.role = role
		self.parts = parts
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.role = try container.decode(API_UserType.self, forKey: .role)
		self.parts = try container.decode([Data].self, forKey: .parts)
	}
}
struct GenAI_Message_Text_DTO: Codable, Equatable {
	var text: String
	
}

extension GenAI_Message_Text_DTO {
	func encoded() -> Data {
		return try! JSONEncoder().encode(self)
	}
}

struct GenAI_Message_Images_DTO: Codable, Equatable {
	var inline_data: GenAI_Message_Images_Data_DTO
}

extension GenAI_Message_Images_DTO {
	func encoded() throws -> Data {
		return try JSONEncoder().encode(self)
	}
	func decoded<T: Decodable>(data: Data, type: T) throws -> T {
		return try JSONDecoder().decode(T.self, from: data)
	}
}

struct GenAI_Message_Images_Data_DTO: Codable, Equatable {
	var mime_type = "image/jpeg"
	var data: String
}

struct GenAI_UsageMetadata: Codable {
	var promptTokenCount: Int
	var candidatesTokenCount: Int
	var totalTokenCount: Int
}





extension Dictionary where Key: Encodable, Value: Encodable {
	func encoded() throws -> Data {
		do {
			return try JSONEncoder().encode(self)
		} catch let err {
			throw err
		}
	}
}
