//
//  RecipeDataSourceRemote.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

protocol RecipeDataSourceRemote {
	func fetchRecipes() async -> Result<Recipes, FetchRecipeError>
	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError>
}

class RecipeDataSourceRemoteStub: RecipeDataSourceRemote {
	let response: Result<Recipes, FetchRecipeError>
	let imageResponse: Result<URL, FetchImageError>

	init(
		response: Result<Recipes, FetchRecipeError>,
		imageResponse: Result<URL, FetchImageError>
	) {
		self.response = response
		self.imageResponse = imageResponse
	}

	func fetchRecipes() -> Result<Recipes, FetchRecipeError> {
		response
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		imageResponse
	}
}
