//
//  Keys.swift
//  SmartyPants
//
//  Created by Norris Wise Jr on 10/17/24.
//

import Foundation

enum Keys {
	case API
	
	var description: String? {
		switch self {
			case .API:
				let path = Bundle.main.path(forResource: "GenerativeAI", ofType: ".plist")!
				let url = URL(filePath: path)
				let plistDict = try? NSDictionary(contentsOf: url, error: ())
				return plistDict?["apiKey"] as? String
		}
	}
}
