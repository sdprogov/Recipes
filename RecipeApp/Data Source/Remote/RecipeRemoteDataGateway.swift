//
//  RecipeRemoteDataGateway.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

class RecipeRemoteDataGateway: RecipeDataSourceRemote {
	
	let service: RecipeService
	let db: RecipesDataBase

	init(service: RecipeService, db: RecipesDataBase) {
		self.service = service
		self.db = db
	}

	func fetchRecipes() async -> Result<Recipes, FetchRecipeError> {
		let fetchRecipesResponse = await service.fetchRecipes()
		switch fetchRecipesResponse {
		case let .success(recipes):
			let _ = await db.updateRecipes(with: recipes)
			return .success(recipes)
		case let .failure(error):
			return .failure(error)
		}
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		let fetchImageResponse = await service.getImage(for: recipe)
		switch fetchImageResponse {
		case let .success(url):
			let _ = await db.update(recipe, with: url)
			return .success(url)
		case let .failure(error):
			return .failure(error)
		}
	}
}
