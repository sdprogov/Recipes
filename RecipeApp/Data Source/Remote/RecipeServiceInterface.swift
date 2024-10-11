//
//  RecipeServiceInterface.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

protocol RecipeService {
	func fetchRecipes() async -> Result<Recipes, FetchRecipeError>
	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError>

}

class RecipeServiceStub: RecipeService {
	let result: Result<Recipes, FetchRecipeError>
	let imageResult: Result<URL, FetchImageError>

	init(
		result: Result<Recipes, FetchRecipeError>,
		imageResult: Result<URL, FetchImageError>
	) {
		self.result = result
		self.imageResult = imageResult
	}

	func fetchRecipes() async -> Result<Recipes, FetchRecipeError> {
		result
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		imageResult
	}
}
