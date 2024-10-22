//
//  Extension + PhotoPickerItem.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/22/24.
//

import Foundation
import SwiftUI
import _PhotosUI_SwiftUI

extension PhotosPickerItem {
	func convert() async throws -> UIImage {
		
		do {
			if let imageData = try await self.loadTransferable(type: Data.self),
			   let uiImage = UIImage(data: imageData) {
				return uiImage
			}
		} catch let err {
			throw err
		}
		return UIImage.init(systemName: "xmark.icloud")!
		
	}
}
