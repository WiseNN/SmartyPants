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
				
				if let imageDTO = chatMsg.parts.last as? GenAI_Message_Images_DTO, let imageURL = URL(string: imageDTO.inline_data.data) {
					CachedAsyncImage(url: imageURL, urlCache: .imageCache)
				} else if let textDTO = chatMsg.parts.last as? GenAI_Message_Text_DTO {
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
				if let imageDTO = chatMsg.parts.last as? GenAI_Message_Images_DTO, let imageURL = URL(string: imageDTO.inline_data.data) {
						CachedAsyncImage(url: imageURL, urlCache: .imageCache)
					} else if let textDTO = chatMsg.parts.last as? GenAI_Message_Text_DTO {
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
 
