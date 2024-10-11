//
//  FetchRecipeError.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

enum FetchRecipeError: Error, Hashable, Identifiable, Equatable, LocalizedError {
	var id: Self { self }

	case networkError(cause: String)
	case noneSaved

	var errorDescription: String? {
		switch self {
		case .networkError(let cause):
			return cause
		case .noneSaved:
			return "No saved recipes"
		}
	}
}
