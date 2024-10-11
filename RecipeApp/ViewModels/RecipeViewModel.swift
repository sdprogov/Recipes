//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import SwiftUI

@Observable final class RecipeViewModel {

	var visibleRecipes: [Recipe] = []
	var recipesByCuisine: [RecipesOfTheSameCuisine] = []
	var allCuisines: [String] = []
	var selectedCuisineIndex: UInt = 0 // default on the first

	var selectedCuisine: String {
		guard selectedCuisineIndex < recipesByCuisine.count else { return "" }
		return recipesByCuisine[Int(selectedCuisineIndex)].cuisine
	}

	func updateSelectedCuisine(_ index: UInt) {
		selectedCuisineIndex = index
		visibleRecipes = recipesByCuisine[Int(index)].recipes
	}

	func fetchRecipeList() async throws {
		@Injected(\.fetchRecipesAction) var fetcher: FetchRecipeAction

		let response = await fetcher.getRecipes()
		switch response {
			case .success(var recipeResponse):
			recipesByCuisine = recipeResponse.recipesByCusineCategory
			allCuisines = recipesByCuisine.map(\.cuisine)
			if selectedCuisineIndex < recipesByCuisine.count {
				visibleRecipes = recipesByCuisine[Int(selectedCuisineIndex)].recipes
			} else {
				visibleRecipes = []
			}
		case .failure(let error):
			throw error
		}
	}

	func fetchImage(for recipe: Recipe) async {

		@Injected(\.fetchImageAction) var imageFetcher: FetchImageAction
		let response = await imageFetcher.getImage(for: recipe)
		switch response {
		case .success(let url):
			guard let index = visibleRecipes.firstIndex(where: { $0.id == recipe.id }),
					visibleRecipes[index].imageDataURL == nil else { return }
			visibleRecipes[index].imageDataURL = url
			visibleRecipes[index].imageLoadingError = nil
		case .failure(let error):
			guard let index = visibleRecipes.firstIndex(where: { $0.id == recipe.id }),
					visibleRecipes[index].imageDataURL == nil else { return }
			visibleRecipes[index].imageLoadingError = error
		}
	}
}
