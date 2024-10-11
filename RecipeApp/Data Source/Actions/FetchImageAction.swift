//
//  FetchImageAction.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

class FetchImageAction {
	let source: RecipesSourceable

	init(source: RecipesSourceable) {
		self.source = source
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		await source.getImage(for: recipe)
	}
}

extension FetchImageAction {
	static let liveAction = FetchImageAction(source: RecipesRepository.liveEnvironment)
}

private struct FetchImageActionProviderKey: InjectionKey {
	static var currentValue: FetchImageAction = FetchImageAction.liveAction
}

extension InjectedValues {
	var fetchImageAction: FetchImageAction {
		get { Self[FetchImageActionProviderKey.self] }
		set { Self[FetchImageActionProviderKey.self] = newValue }
	}
}
