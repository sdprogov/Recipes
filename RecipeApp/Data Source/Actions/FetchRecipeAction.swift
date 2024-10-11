//
//  FetchRecipeAction.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

class FetchRecipeAction {
	let source: RecipesSourceable

	init(source: RecipesSourceable) {
		self.source = source
	}

	func getRecipes() async -> Result<Recipes, FetchRecipeError> {
		await source.getRecipes()
	}
}

extension FetchRecipeAction {
	static let liveAction = FetchRecipeAction(source: RecipesRepository.liveEnvironment)
}

private struct FetchRecipesProviderKey: InjectionKey {
	static var currentValue: FetchRecipeAction = FetchRecipeAction.liveAction
}

extension InjectedValues {
	var fetchRecipesAction: FetchRecipeAction {
		get { Self[FetchRecipesProviderKey.self] }
		set { Self[FetchRecipesProviderKey.self] = newValue }
	}
}

