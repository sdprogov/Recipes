//
//  RecipesDataGateway.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

class RecipesDataGateway: RecipeDataSourceLocal {
	
	let db: RecipesDataBase

	init(db: RecipesDataBase) {
		self.db = db
	}

	func fetchRecipes() async -> Result<Recipes, FetchRecipeError> {
		await db.getRecipes()
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		await db.getImage(for: recipe)
	}
}
