//
//  ChatCellView.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct ChatCellView: View {
	let chatMsg: GenAI_Request_DTO
	
	
	
	var body: some View {
		HStack {
			if chatMsg.role == .model {
				
				if let data = chatMsg.parts.last, let text = String(data: data, encoding: .utf8), let imageURL = URL(string: text) {
					CachedAsyncImage(url: imageURL, urlCache: .imageCache)
				} else if let data = chatMsg.parts.last, let textDTO = try? JSONDecoder().decode(GenAI_Message_Text_DTO.self, from: data) {
					Text(textDTO.text)
						.font(.subheadline)
						.fontWeight(.semibold)
						.foregroundStyle(.black)
						.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
						.background(.recipientBubble)
						.clipShape(RoundedRectangle(cornerRadius: 12))
						.background(.clear)
						.listStyle(.plain)
				} else {
					EmptyView()
				}
				
					

					
				Spacer(minLength: 100)
			} else {
				Spacer(minLength: 100)
					if let data = chatMsg.parts.last, let text = String(data: data, encoding: .utf8), let imageURL = URL(string: text) {
						CachedAsyncImage(url: imageURL, urlCache: .imageCache)
					} else if let data = chatMsg.parts.last, let textDTO = try? JSONDecoder().decode(GenAI_Message_Text_DTO.self, from: data) {

						
						Text(textDTO.text)
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(.black)
							.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
							.background(.senderBubble)
							.clipShape(RoundedRectangle(cornerRadius: 12))
							.background(.clear)
					} else {
						EmptyView()
					}
			}
		}
		.listRowSeparator(.hidden)
		.listRowBackground(Color.clear)
		.id(chatMsg.id)
	}
}



#Preview {
	ChatCellView(chatMsg: GenAI_Request_DTO(role: .model, parts: [GenAI_Message_Text_DTO(text: "Hi There").encoded()]))
}

extension URLCache {
	static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
 
