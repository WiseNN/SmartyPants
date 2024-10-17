//
//  ChatCellView.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation
import SwiftUI

struct ChatCellView: View {
	let cellColor: Color
	let alignment: Alignment
	let fontColor: Color
	let message: String
	
	
	
	var body: some View {
		HStack {
			if alignment == .leading {
				Text(message)
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(fontColor)
					.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
					.background(cellColor)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.background(.clear)
					.listStyle(.plain)
					

					
				Spacer(minLength: 100)
			} else {
				Spacer(minLength: 100)
				Text(message)
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(fontColor)
					.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
					.background(cellColor)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.background(.clear)

					
			}
		}
		.listRowSeparator(.hidden)
		.listRowBackground(Color.clear)
	}
}



#Preview {
	ChatCellView(cellColor: .gray, alignment: .leading, fontColor: .black, message: "Hi There!")
}
