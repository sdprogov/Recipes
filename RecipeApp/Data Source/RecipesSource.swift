//
//  RecipesSource.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

protocol RecipesSourceable {
	func getRecipes() async -> Result<Recipes, FetchRecipeError>
	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError>
}

class RecipesSource: RecipesSourceable {
	let response: Result<Recipes, FetchRecipeError>
	let imageResponse: Result<URL, FetchImageError>

	init(
		response: Result<Recipes, FetchRecipeError>,
		imageResponse: Result<URL, FetchImageError>)
	{
		self.response = response
		self.imageResponse = imageResponse
	}

	func getRecipes() -> Result<Recipes, FetchRecipeError> {
		response
	}

	func getImage(for recipe: Recipe) -> Result<URL, FetchImageError> {
		return imageResponse
	}
}
