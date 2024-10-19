//
//  ContentView.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import SwiftUI
import GoogleGenerativeAI


struct ChatView: View {
	@ObservedObject var viewModel: ChatViewModel
	@State var searchText = ""
	
	
	
    var body: some View {
		
		NavigationStack {
			
				VStack {
					ScrollViewReader { proxy in
						List(viewModel.msgAry) { chatMsg in
							ChatCellView(chatMsg: chatMsg)
						}
						.onChange(of: viewModel.msgAry) {
							if let last = viewModel.msgAry.last {
									proxy.scrollTo(last.id)
							}
						}
						
						TextField(text: $viewModel.msgText, prompt: Text("Message..."), axis: .vertical) {
							}
							.lineLimit(.max)
							.controlSize(.extraLarge)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.submitLabel(.done)
							.onSubmit() {
								viewModel.sendChat(msg: viewModel.msgText)
							}
						.safeAreaPadding()
					}
					.listRowBackground(Color.clear)
					.scrollContentBackground(.hidden)
					.background(.chatBackground)
					.defaultScrollAnchor(.bottom)
					.scrollIndicators(.hidden)
					.alert("Error", isPresented: $viewModel.hasErr) {
					} message: {
						Text(viewModel.errMsg)
					}
						
						
					}

					
			
			
		}
		.searchable(text: $searchText)
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
