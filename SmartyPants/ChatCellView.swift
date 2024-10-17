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
	
	
	var body: some View {
		HStack {
			if alignment == .leading {
				Text("Samepl Text ds dljkncs kdj cksdjfv nksdfjv nskdfjvn sdfkjvn ksdfjnv ksdjfvn skdfjv nskdfjv skjdfvn ksdjfvn jnacskk")
					.font(.subheadline)
					.foregroundStyle(fontColor)
					.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
					.background(cellColor)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.frame(width: .infinity)
					
				Spacer(minLength: 100)
			} else {
				Spacer(minLength: 100)
				Text("Samepl Text ds dljkncs kdj cksdjfv nksdfjv nskdfjvn sdfkjvn ksdfjnv ksdjfvn skdfjv nskdfjv skjdfvn ksdjfvn jnacskk")
					.padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))
					.background(cellColor)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.frame(width: .infinity)
					
			}
		}
	}
}



#Preview {
	ChatCellView(cellColor: .gray, alignment: .leading, fontColor: .black)
}
