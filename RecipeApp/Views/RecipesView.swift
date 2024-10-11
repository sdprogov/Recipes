//
//  ContentView.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import SwiftUI
import Foundation

extension String: @retroactive Identifiable {
	public var id: String { self }
}

extension URL: @retroactive Identifiable {
	public var id: String { self.absoluteString }
}

struct RecipesView: View {

	enum ViewState {
		case inactive
		case loading
		case loadedRecipes
		case errorLoadingRecipes(String)
	}

	@State private var viewState: ViewState = .inactive
	@State private var recipeModel = RecipeViewModel()
	@State private var recipeDetailsURL: URL? = nil

	/// Return the CardViews width for the given offset in the array
	/// - Parameters:
	///   - geometry: The geometry proxy of the parent
	///   - index: The ID of the current index of the recipe
	private func getCardWidth(_ geometry: GeometryProxy, index: Int) -> CGFloat {
		let offset: CGFloat = getCardOffset(index)
		let width = geometry.size.width - offset
		return width
	}

	/// Return the CardViews frame offset for the given offset in the array
	/// - Parameters:
	///   - index: The ID of the current user
	private func getCardOffset(_ index: Int) -> CGFloat {
		let count = recipeModel.visibleRecipes.count
		let offSet = CGFloat(count - 1 - index) * 10
		return offSet
	}

	@ViewBuilder
	private var recipes: some View {
		VStack {
			GeometryReader { geometry in
				LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color.init(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1))]), startPoint: .bottom, endPoint: .top)
					.frame(width: geometry.size.width * 1.5, height: geometry.size.height)
					.background(Color.blue)
					.clipShape(Circle())
					.offset(x: -geometry.size.width / 4, y: -geometry.size.height / 2)

				VStack(spacing: 24) {
					HeaderView(recipesModel: $recipeModel)
					Spacer()
					ZStack {
						EnumeratedForEach(recipeModel.visibleRecipes) { index, recipe in
							Group {
								if (recipeModel.visibleRecipes.count - 3)...recipeModel.visibleRecipes.count ~= index {
									RecipeCardView(recipe: recipe, userAction: { action in
										switch action {
										case .reloadImage(let recipe):
											Task {
												await recipeModel.fetchImage(for: recipe)
											}
										case .recipeDetails(let recipe):
											if let recipeDetailsURL = recipe.sourceURL {
												self.recipeDetailsURL = recipeDetailsURL
											} else {
												self.recipeDetailsURL = recipe.youtubeURL
											}
										}

									}, moveFrom: { oldRecipe in
										recipeModel.visibleRecipes.removeAll { $0.id == oldRecipe.id }
									})
									.task {
										await recipeModel.fetchImage(for: recipe)
									}
									.animation(.spring(), value: UUID())
									.frame(width: self.getCardWidth(geometry, index: index), height: 400)
									.offset(x: 0, y: self.getCardOffset(index))
								}
							}
						}
					}
					Spacer()
				}
			}
		}
		.padding()
	}

    var body: some View {
		Group {
			switch viewState {
			case .inactive:
				EmptyView()
			case .loading:
				ProgressView()
			case .loadedRecipes:
				ScrollView {
					if recipeModel.visibleRecipes.isEmpty {
						EmptyStateView()
					} else {
						recipes
					}
				}
				.refreshable {
					await refresh()
				}
			case .errorLoadingRecipes(let error):
				ScrollView {
					ErrorView(errorMessage: error)
				}
				.refreshable {
					await refresh()
				}
			}
		}
		.task { await refresh() }
		.sheet(item: $recipeDetailsURL) { url in
			NavigationStack {
				WebView(url: url)
					.ignoresSafeArea()
					.navigationTitle("Recipe Details")
					.navigationBarTitleDisplayMode(.inline)
			}
		}
    }

	func refresh() async {
		self.viewState = .loading
		do {
			try await recipeModel.fetchRecipeList()
			self.viewState = .loadedRecipes
		} catch {
			self.viewState = .errorLoadingRecipes(error.localizedDescription)
		}
	}

	struct HeaderView: View {

		@Binding var recipesModel: RecipeViewModel

		var body: some View {
			VStack {
				HStack {
					Menu("All \(recipesModel.selectedCuisine) Recipes") {
						EnumeratedForEach(recipesModel.allCuisines) { index, cuisine in
							Button(cuisine, action: {
								recipesModel.updateSelectedCuisine(UInt(index))
							})
						}
					}
					.font(.title)
					.bold()
					Spacer()
				}
				.padding()
			}
			.background(Color.white)
			.cornerRadius(10)
			.shadow(radius: 5)
		}
	}

	struct ErrorView: View {
		let errorMessage: String

		var body: some View {
			VStack {
				HStack {
					Text(errorMessage)
						.font(.title)
						.foregroundStyle(.red)
						.bold()
					Spacer()
				}
				.padding()
			}
			.background(Color.white)
			.cornerRadius(10)
			.shadow(radius: 5)
		}
	}

	struct EmptyStateView: View {
		var body: some View {
			VStack(alignment: .center) {
				HStack {
					Text("No Recipes")
						.font(.title)
						.foregroundStyle(.red)
						.bold()
					Spacer()
				}
				.padding()
			}
			.background(Color.white)
			.cornerRadius(10)
			.shadow(radius: 5)
		}
	}
}

#Preview {
    RecipesView()
}
