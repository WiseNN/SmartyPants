//
//  ContentView.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import SwiftUI
import GoogleGenerativeAI


struct ChatView: View {
	let viewModel: ChatViewModel
	@State var searchText = ""
	@State var msgText = ""
	
	
    var body: some View {
		
		NavigationStack {
			VStack {
//				List {
//					
//					ChatCellView(cellColor: .recipientBubble, alignment: .leading, fontColor: .black)
//						
//					ChatCellView(cellColor: .senderBubble, alignment: .trailing, fontColor: .black)
//	//					.background(.yellow)
//						
//					ChatCellView(cellColor: .recipientBubble, alignment: .leading, fontColor: .black)
//	//					.background(.yellow)
//						
//					ChatCellView(cellColor: .senderBubble, alignment: .trailing, fontColor: .black)
//	//					.background(.yellow)
//						
//				}
				
				ScrollView {
						VStack {
								Spacer()
							
							ForEach(viewModel.msgAry, id: \.id) { chatMsg in
								if chatMsg.userType == .sender {
									ChatCellView(cellColor: .senderBubble, alignment: .trailing, fontColor: .black, message: chatMsg.message)
								} else {
									ChatCellView(cellColor: .recipientBubble, alignment: .leading, fontColor: .black, message: chatMsg.message)
								}
							}
							
		//					.background(.yellow)
						}
				}
				.scrollIndicators(.hidden)
				.safeAreaPadding()
//				.frame(height: .infinity, alignment: .bottom)
//				.background(.gray)
				
				
				TextField(text: $msgText, prompt: Text("Message..."), axis: .vertical) {
						
					}
				.background(.clear)
				.lineLimit(.max)
				.controlSize(.extraLarge)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.submitLabel(.done)
				.onSubmit() {
					viewModel.sendChat(msg: msgText)
				}
			.safeAreaPadding()
			}
//			.listStyle(.grouped)
			.listRowBackground(Color.clear)
			.scrollContentBackground(.hidden)
			.background(.chatBackground)
			
		}
		.searchable(text: $msgText)
		.onAppear {
			viewModel.clearChat()
		}
    }
		
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}



//struct ChatTextFieldStyle: TextFieldStyle {
//	
//	func _body(configuration: TextField<Self._Label>) -> some View {
//			configuration
//			.padding(30)
//			.background(
//				RoundedRectangle(cornerRadius: 20, style: .continuous)
//					.stroke(Color.red, lineWidth: 3)
//			).padding()
//		}
//	
//}
