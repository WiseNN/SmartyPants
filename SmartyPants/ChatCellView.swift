//
//  ChatCellView.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation
import SwiftUI

struct ChatCellView: View {
	let chatMsg: GenAI_Request_DTO
	
	
	
	var body: some View {
		HStack {
			if chatMsg.role == .model {
				Text(chatMsg.parts.last?.text ?? "")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(.black)
					.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
					.background(.recipientBubble)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.background(.clear)
					.listStyle(.plain)
					

					
				Spacer(minLength: 100)
			} else {
				Spacer(minLength: 100)
				Text(chatMsg.parts.last?.text ?? "")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(.black)
					.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
					.background(.senderBubble)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.background(.clear)

					
			}
		}
		.listRowSeparator(.hidden)
		.listRowBackground(Color.clear)
		.id(chatMsg.id)
	}
}



#Preview {
	ChatCellView(chatMsg: GenAI_Request_DTO(role: .model, parts: [GenAI_Message_Text_DTO(text: "Hi There")]))
}
