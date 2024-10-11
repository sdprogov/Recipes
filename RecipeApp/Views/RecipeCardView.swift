//
//  RecipeCardView.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import SwiftUI
import Combine

struct RecipeCardView: View {
	enum UserAction {
		case reloadImage(recipe: Recipe)
		case recipeDetails(recipe: Recipe)
	}

	@Environment(\.displayScale) var scale

	@State private var translation: CGSize = .zero
	private var recipe: Recipe
	private var moveFrom: (_ recipe: Recipe) -> Void
	private var userAction: (_ action: UserAction) -> Void

	init(recipe: Recipe, userAction: @escaping (_ action: UserAction) -> Void, moveFrom: @escaping (_ recipe: Recipe) -> Void) {
		self.recipe = recipe
		self.moveFrom = moveFrom
		self.userAction = userAction
	}

	// the threshold for dragging when the card is moved off the screen
	private var thresholdPercentage: CGFloat = 0.5

	/// What percentage of our own width have we swipped
	/// - Parameters:
	///   - geometry: The geometry
	///   - gesture: The current gesture translation value
	private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
		gesture.translation.width / geometry.size.width
	}

	@ViewBuilder
	var retryLoadingImageView: some View {
		ContentUnavailableView(label: {
			Image(systemName: "photo")
				.font(.title)
				.foregroundStyle(.secondary)
		}, actions: {
			Button(action: {
				self.userAction(.reloadImage(recipe: recipe))
			}) {
				Label("Retry", systemImage: "arrow.counterclockwise")
			}
		})
	}

	@ViewBuilder
	var imageView: some View {
		AsyncImage(url: recipe.imageDataURL, scale: scale) { phase in
			if let image = phase.image {
				image
					.resizable()
					.aspectRatio(contentMode: .fill)
			} else if phase.error != nil {
				Image(systemName: "photo")
					.font(.title)
					.foregroundStyle(.secondary)
			} else {
				ProgressView()
			}
		}
	}

	var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading) {

				Group {
					if (recipe.imageLoadingError != nil) {
						retryLoadingImageView
					} else {
						imageView
					}
				}
				.frame(width: geometry.size.width, height: geometry.size.height * 0.75)
				.clipped()

				HStack {
					VStack(alignment: .leading, spacing: 6) {
						Text(recipe.name)
							.font(.title)
							.bold()
						Text(recipe.cuisine)
							.font(.subheadline)
							.bold()
					}
					Spacer()

					Button(action: {
						userAction(.recipeDetails(recipe: recipe))
					}, label: {
						Image(systemName: "info.circle")
							.foregroundColor(.gray)
					})
				}
				.padding(.horizontal)
			}
			.padding(.bottom)
			.background(Color.white)
			.cornerRadius(10)
			.shadow(radius: 5)
			.animation(.interactiveSpring(), value: UUID())
			.offset(x: self.translation.width, y: 0)
			.rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
			.gesture(
				DragGesture()
					.onChanged { value in
						self.translation = value.translation

				}.onEnded { value in
					// determine snap distance > 0.5 aka half the width of the screen
						if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
							self.moveFrom(recipe)
						} else {
							self.translation = .zero
						}
					}
			)
		}
	}
}

#Preview {
	RecipeCardView(recipe: Recipe.malaySample,
				   userAction: { _ in
		// do nothing
	},
				   moveFrom: { _ in
		// do nothing
	})
	.frame(height: 400)
	.padding()
}
