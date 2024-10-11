//
//  EnumeratedForEach.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import SwiftUI

public struct EnumeratedForEach<ItemType: Identifiable, ContentView: View>: View {
	let data: [ItemType]
	let content: (Int, ItemType) -> ContentView

	public init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
		self.data = data
		self.content = content
	}

	public var body: some View {
		ForEach(Array(zip(data.indices, data)), id: \.1.id) { idx, item in
			content(idx, item)
		}
	}
}
