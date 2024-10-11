//
//  RecipesDataBase.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

protocol RecipesDataBase {
	func getRecipes() async -> Result<Recipes, FetchRecipeError>
	func updateRecipes(with recipes: Recipes) async -> Result<Void, UpdateRecipeError>
	func update(_ recipe: Recipe, with imageDataUrl: URL) async -> Result<Void, UpdateRecipeError>
	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError>
}

class RecipesStub: RecipesDataBase {
	let getResult: Result<Recipes, FetchRecipeError>
	let updateResult: Result<Void, UpdateRecipeError>
	let updateImageResult: Result<Void, UpdateRecipeError>
	let getImageResult: Result<URL, FetchImageError>

	init(
		getResult: Result<Recipes, FetchRecipeError>,
		updateResult: Result<Void, UpdateRecipeError>,
		updateImageResult: Result<Void, UpdateRecipeError>,
		getImageResult: Result<URL, FetchImageError>
	) {
		self.getResult = getResult
		self.updateResult = updateResult
		self.updateImageResult = updateImageResult
		self.getImageResult = getImageResult
	}

	func getRecipes() async -> Result<Recipes, FetchRecipeError> {
		getResult
	}

	func updateRecipes(with recipes: Recipes) async -> Result<Void, UpdateRecipeError> {
		updateResult
	}

	func update(_ recipe: Recipe, with imageDataUrl: URL) async -> Result<Void, UpdateRecipeError> {
		updateImageResult
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		getImageResult
	}

}

