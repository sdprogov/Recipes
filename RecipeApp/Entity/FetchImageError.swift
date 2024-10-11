//
//  FetchImageError.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

enum FetchImageError: Error, Hashable, Identifiable, Equatable, LocalizedError {
	var id: Self { self }

	case networkError(cause: String)
	case missingRecipe(receipeId: String)
	case noneSaved

	var errorDescription: String? {
		switch self {
		case .networkError(let cause):
			return cause
		case .missingRecipe(let receipeId):
			return "Cannot find receipe with Id: \(receipeId) to associate Image with"
		case .noneSaved:
			return "No Image was downloaded"
		}
	}
}
