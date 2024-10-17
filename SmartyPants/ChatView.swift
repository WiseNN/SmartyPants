//
//  ContentView.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import SwiftUI
import GoogleGenerativeAI


struct ChatView: View {
    var body: some View {
		VStack {
				List {
					ChatCellView(cellColor: .gray, alignment: .leading, fontColor: .black)
					ChatCellView(cellColor: .blue, alignment: .trailing, fontColor: .black)
					ChatCellView(cellColor: .gray, alignment: .leading, fontColor: .black)	
				}
			}
    }
}

#Preview {
    ChatView()
}
