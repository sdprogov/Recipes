//
//  Recipe.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

typealias RecipesOfTheSameCuisine = (cuisine: String, recipes: [Recipe])

struct Recipes: Decodable {
	var recipes: [Recipe]

	lazy var allCusineCategories: Set<String> = {
		Set(recipes.map { $0.cuisine })
	}()

	lazy var recipesByCusineCategory: [RecipesOfTheSameCuisine] = {
		var categorizedRecipes = [RecipesOfTheSameCuisine]()
		let categories = Array(allCusineCategories).sorted()
		for category in categories {
			let recipesByCategory = recipes.filter { $0.cuisine == category }
			if !recipesByCategory.isEmpty {
				let sortedRecipes: RecipesOfTheSameCuisine = (cuisine: category, recipes: recipesByCategory)
				categorizedRecipes.append(sortedRecipes)
			}
		}
		return categorizedRecipes
	}()

	init(recipes: [Recipe]) {
		self.recipes = recipes
	}
}

extension Recipes {
	static var mock: Recipes {
		.init(recipes: [.malaySample])
	}
}

struct Recipe: Decodable {
	let cuisine: String
	let name: String
	let photoURLLarge: URL
	let photoURLSmall: URL
	let sourceURL: URL?
	let youtubeURL: URL?
	let uuid: String

	enum CodingKeys: String, CodingKey {
		case cuisine
		case name
		case photoURLLarge = "photo_url_large"
		case photoURLSmall = "photo_url_small"
		case sourceURL = "source_url"
		case youtubeURL = "youtube_url"
		case uuid
	}

	var imageDataURL: URL?
	var imageLoadingError: Error?
}

extension Recipe: Identifiable {
	var id: String { uuid }
}

extension Recipe {
	static var malaySample: Recipe {
		Recipe(
			cuisine: "Malaysian",
			name: "Apam Balik",
			photoURLLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
			photoURLSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
			sourceURL: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
			youtubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!,
			uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8"
		)
	}
}
