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
				
					
				
				ForEach(0..<chatMsg.parts.count, id: \.self) { index in
					let part = chatMsg.parts[index]
					if 	let imageDTO = part as? GenAI_Message_Images_DTO, let imageData = Data(base64Encoded: imageDTO.inline_data.data),
						let uiImage = UIImage(data: imageData) {
						Image(uiImage: uiImage)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(maxWidth: 220)
							.background(.yellow)
							.clipShape(RoundedRectangle(cornerRadius: 15))
							
					} else if let textDTO = part as? GenAI_Message_Text_DTO {
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
					
				}
			} else {
				Spacer(minLength: 100)
				VStack {
					ForEach(0..<chatMsg.parts.count, id: \.self) { index in
						let part = chatMsg.parts[index]
						
						
						if
							let imageDTO = part as? GenAI_Message_Images_DTO,
							let imageData = Data(base64Encoded: imageDTO.inline_data.data),
							let uiImage = UIImage(data: imageData) {
								Image(uiImage: uiImage)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: 220)
								.background(.yellow)
								.clipShape(RoundedRectangle(cornerRadius: 15))
							} else if let textDTO = part as? GenAI_Message_Text_DTO {
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
				
			}
		}
		.listRowSeparator(.hidden)
		.listRowBackground(Color.clear)
		.id(chatMsg.id)
	}
}



#Preview {
	ChatCellView(chatMsg: GenAI_Request_DTO(role: .model, parts: [GenAI_Message_Images_DTO(inline_data: GenAI_Message_Images_Data_DTO(data: "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"))]))
}

extension URLCache {
	static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
 
