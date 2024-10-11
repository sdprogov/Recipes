//
//  ActionTests.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/11/24.
//

import Testing
import Foundation
@testable import RecipeApp

@Suite("Action Tests")
struct ActionTests {

	struct FetchImageTests {
		@Test
		func testFetchImageCase_whenDownloadingImageIsSuccessful_getsSuccessfulResponse() async {
			let sut = makeSUT()
			let result = await sut.getImage(for: .malaySample)
			switch result {
			case .success(let response):
				#expect(response.absoluteString.isEmpty == false)
			case .failure:
				Issue.record("FetchRecipeAction failed")
			}
		}

		// MARK: - Helpers
		private func makeSUT(
			getImagesSource: RecipesSourceable = RecipesSource(response: .success(.mock), imageResponse: .success(URL(string: "https://jsonplaceholder.typicode.com")!)),
			file: StaticString = #file,
			line: UInt = #line
		) -> FetchImageAction {
			let sut = FetchImageAction(
				source: getImagesSource
			)
			return sut
		}
	}

	struct FetchRecipeTests {
		@Test
		func testFetchRecipeCase_whenCallingGetRecipesIsSuccessful_getsSuccessfulResponse() async {
			let sut = makeSUT()
			let result = await sut.getRecipes()
			switch result {
			case .success(let response):
				#expect(response.recipes.count == 1)
			case .failure:
				Issue.record("FetchRecipeAction failed")
			}
		}

		// MARK: - Helpers
		private func makeSUT(
			getRecipesSource: RecipesSourceable = RecipesSource(response: .success(.mock), imageResponse: .failure(.noneSaved)),
			file: StaticString = #file,
			line: UInt = #line
		) -> FetchRecipeAction {
			let sut = FetchRecipeAction(
				source: getRecipesSource
			)
			return sut
		}
	}
}
