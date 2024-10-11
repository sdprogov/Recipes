//
//  RecipesDataBaseMemoryCache.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

class RecipesDataBaseMemoryCache: RecipesDataBase {

	private var recipes: Recipes?

	init(recipes: Recipes? = nil) {
		self.recipes = recipes
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		guard let index = recipes?.recipes.firstIndex(where: { $0.id == recipe.id}) else {
			return .failure(.missingRecipe(receipeId: recipe.id))
		}
		if let imageDataURL = recipes?.recipes[index].imageDataURL {
			return .success(imageDataURL)
		}
		return .failure(.noneSaved)
	}

	func getRecipes() async -> Result<Recipes, FetchRecipeError> {
		do {
			let recipes = try await loadRecipes()
			return .success(recipes)
		} catch {
			return .failure(.noneSaved)
		}
	}

	func updateRecipes(with recipes: Recipes) async -> Result<Void, UpdateRecipeError> {
		do {
			try await save(recipes: recipes)
			return .success(())
		} catch {
			return .failure(.localStorageError(cause: error.localizedDescription))
		}
	}

	private func loadRecipes() async throws -> Recipes {
		if let recipes = recipes {
			return recipes
		}
		throw FetchRecipeError.noneSaved
	}

	private func save(recipes: Recipes) async throws {
		self.recipes = recipes
	}

	func update(_ recipe: Recipe, with imageDataUrl: URL) async -> Result<Void, UpdateRecipeError> {
		if let index = recipes?.recipes.firstIndex(where: { $0.id == recipe.id}) {
			recipes?.recipes[index].imageDataURL = imageDataUrl
			return .success(())
		}
		return .failure(.localStorageError(cause: "No recipe with id \(recipe.id) found"))
	}
}
