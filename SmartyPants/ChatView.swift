//
//  ContentView.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import SwiftUI
import GoogleGenerativeAI
import _PhotosUI_SwiftUI


struct ChatView: View {
	@ObservedObject var viewModel: ChatViewModel
	@State var searchText = ""
	@State var pickerItem: PhotosPickerItem?
	@State var selectedImage: Image?
	
	
	
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
						
						HStack {
							PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
								Image(systemName: "plus.circle")
									.resizable()
									.frame(width: 25, height: 25)
							}
							.onChange(of: pickerItem) { _, newPhoto in
								guard let newPhoto else {
									viewModel.photoRetrievalError(msg: "Sorry, this photo is missing.")
									return
								}
								viewModel.sendPhoto(pickerItem: newPhoto)
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
//			viewModel.clearChat()
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
