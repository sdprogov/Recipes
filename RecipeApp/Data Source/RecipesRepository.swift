//
//  RecipesRepository.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

class RecipesRepository: RecipesSourceable {
	let recipesRemoteSource: RecipeDataSourceRemote
	let recipesLocalSource: RecipeDataSourceLocal

	init(recipesRemoteSource: RecipeDataSourceRemote, recipesLocalSource: RecipeDataSourceLocal) {
		self.recipesRemoteSource = recipesRemoteSource
		self.recipesLocalSource = recipesLocalSource
	}

	func getRecipes() async -> Result<Recipes, FetchRecipeError> {
		let recipesLocalSourceResponse = await recipesLocalSource.fetchRecipes()
		switch recipesLocalSourceResponse {
		case .success(_):
			return recipesLocalSourceResponse
		case .failure(.noneSaved):
			return await recipesRemoteSource.fetchRecipes()
		case .failure:
			return await recipesRemoteSource.fetchRecipes()
		}
	}

	func getImage(for recipe: Recipe) async -> Result<URL, FetchImageError> {
		let imageResponse = await recipesLocalSource.getImage(for: recipe)
		switch imageResponse {
		case .success(_):
			return imageResponse
		case .failure(.noneSaved):
			return await recipesRemoteSource.getImage(for: recipe)
		case .failure(let error):
			return .failure(error)
		}
	}
}

extension RecipesRepository {
	static let liveEnvironment: RecipesRepository = {
		let remote = RecipeServiceRemote()
		let db = RecipesDataBaseMemoryCache()
		let remoteGateway = RecipeRemoteDataGateway(service: remote, db: db)
		let dbGateway = RecipesDataGateway(db: db)
		let repo = RecipesRepository(recipesRemoteSource: remoteGateway, recipesLocalSource: dbGateway)
		let action = FetchRecipeAction(source: repo)

		return repo
	}()
}

private struct AppRepositoryProviderKey: InjectionKey {
	static var currentValue: RecipesSourceable = RecipesRepository.liveEnvironment
}

extension InjectedValues {
	var repository: RecipesSourceable {
		get { Self[AppRepositoryProviderKey.self] }
		set { Self[AppRepositoryProviderKey.self] = newValue }
	}
}

