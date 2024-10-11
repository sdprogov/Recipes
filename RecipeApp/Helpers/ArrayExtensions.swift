//
//  ArrayExtensions.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

extension Array {
	func lastItemsWrapped(from startIndex: Int = 0, count: Int) -> [Element] {
		guard !self.isEmpty else { return [] }
		guard count <= self.count else { return self }
		guard count >= 0 else { return self }
		guard startIndex >= 0 else { return self }
		guard startIndex < self.count else { return self }

//		let start = self.count >= count ? self.count - count : 0
//		let endSlice = self[start..<self.count]
//
//		if start == 0 {
//			let wrappedCount = count - endSlice.count
//			let wrappedSlice = self.prefix(wrappedCount)
//			return Array(endSlice + wrappedSlice)
//		}
//
//		return Array(endSlice)

		var result = [Element]()
		let n = self.count

		for i in 0..<count {
			let index = (startIndex + i) % n
			result.append(self[index])
		}

		return result
	}
}
