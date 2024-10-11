//
//  UpdateRecipeError.swift
//  RecipeApp
//
//  Created by Stefan Progovac on 10/10/24.
//

import Foundation

enum UpdateRecipeError: Error, Equatable, LocalizedError {
	case localStorageError(cause: String)

	var errorDescription: String? {
		switch self {
		case .localStorageError(let cause):
			return cause
		}
	}
}
