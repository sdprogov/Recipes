//
//  RecipeServiceRemote.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//
import Foundation

class RecipeServiceRemote: RecipeService {
	private let urlSession: URLSession

	init(urlSession: URLSession = .shared) {
		self.urlSession = urlSession
	}

	private lazy var decoder: JSONDecoder = { JSONDecoder() }()

	func fetchRecipes() async -> Result<Recipes, FetchRecipeError> {
		let urlRequest = URLRequest(url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
		do {
			let (data, urlResponse) = try await urlSession.data(for: urlRequest)
			guard let urlResponse = urlResponse as? HTTPURLResponse else {
				return .failure(.networkError(cause: "HTTPURLResponse cast error"))
			}
			guard urlResponse.statusCode == 200 else {
				return .failure(.networkError(cause: "HTTPURLResponse statusCode was not 200"))
			}
			let recipe = try decoder.decode(Recipes.self, from: data)
			return .success(recipe)
		} catch {
			return .failure(.networkError(cause: error.localizedDescription))
		}
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		do {
			let (data, _) = try await urlSession.data(from: recipe.photoURLLarge)
			guard let dataURL = URL(string: "data:image/png;base64," + data.base64EncodedString()) else {
				return .failure(.networkError(cause: "corrupted data"))
			}

			return .success(dataURL)
		} catch {
			return .failure(.networkError(cause: error.localizedDescription))
		}
	}
}
