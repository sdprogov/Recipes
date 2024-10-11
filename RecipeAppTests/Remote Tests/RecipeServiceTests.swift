//
//  RecipeServiceTests.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/11/24.
//

import Testing
import Foundation
@testable import RecipeApp

@Suite(.serialized)
struct RecipeServiceTests {

	@Test
	func recipeService_whenFetchingRecipesRequestSucceeds_returnsRecipes() async {
		let url = URL(string: "https://jsonplaceholder.typicode.com")!

		let encodedRecipeList = mockNormalRecipesData
		let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
		URLProtocolStub.stub(data: encodedRecipeList, response: urlResponse, error: nil)

		let sut = makeSUT()
		let recipesResult = await sut.fetchRecipes()
		switch recipesResult {
		case .success(let recipes):
			#expect(recipes.recipes.isEmpty == false)
		case .failure(_):
			Issue.record()
		}
	}

	@Test
	func recipeService_whenFetchingMalformedRecipesRequestFails_returnsNothing() async {
		let url = URL(string: "https://jsonplaceholder.typicode.com")!

		let encodedRecipeList = mockMalformedRecipesData
		let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
		URLProtocolStub.stub(data: encodedRecipeList, response: urlResponse, error: nil)

		let sut = makeSUT()
		let recipesResult = await sut.fetchRecipes()
		switch recipesResult {
		case .success(_):
			// Is this technically an issue ?
			Issue.record()
		case .failure(let error):
			#expect(error.localizedDescription.isEmpty == false)
		}
	}

	@Test
	func recipeService_whenFetchingEmptyRecipesRequestSucceeds_returnsRecipes() async {
		let url = URL(string: "https://jsonplaceholder.typicode.com")!

		let encodedRecipeList = mockEmptyRecipesData
		let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
		URLProtocolStub.stub(data: encodedRecipeList, response: urlResponse, error: nil)

		let sut = makeSUT()
		let recipesResult = await sut.fetchRecipes()
		switch recipesResult {
		case .success(let recipes):
			#expect(recipes.recipes.isEmpty == true)
		case .failure(_):
			Issue.record()
		}
	}

	@Test
	func recipeService_whenFetchingRecipesRequestFails_IfHTTPStatusIs400() async {
		let url = URL(string: "https://jsonplaceholder.typicode.com")!

		let encodedRecipeList = mockNormalRecipesData
		let urlResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
		URLProtocolStub.stub(data: encodedRecipeList, response: urlResponse, error: nil)

		let sut = makeSUT()
		let recipesResult = await sut.fetchRecipes()
		switch recipesResult {
		case .success(_):
			Issue.record()
		case .failure(let error):
			#expect(error == .networkError(cause: "HTTPURLResponse statusCode was not 200"))
		}
	}

	// MARK: - Helpers

	private func makeSUT(
		file: StaticString = #file,
		line: UInt = #line
	) -> RecipeServiceRemote {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [URLProtocolStub.self]
		let urlSession = URLSession(configuration: configuration)

		let sut = RecipeServiceRemote(urlSession: urlSession)
		return sut
	}

	private var mockNormalRecipesData: Data {
		return getData(name: "MockRecipesNormal")
	}

	private var mockMalformedRecipesData: Data {
		return getData(name: "MockRecipesMalformed")
	}

	private var mockEmptyRecipesData: Data {
		return getData(name: "MockRecipesEmpty")
	}

	private func getData(
		name: String,
		withExtension: String = "json"
	) -> Data {
		let bundle = Bundle.current
		let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
		let data = try! Data(contentsOf: fileUrl!)
		return data
	}
}

extension Bundle {
	static var current: Bundle {
		class __ { }
		return Bundle(for: __.self)
	}
}
