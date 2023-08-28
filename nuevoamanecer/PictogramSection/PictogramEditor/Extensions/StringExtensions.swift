//
//  StringExtensions.swift
//  nuevoamanecer
//
//  Created by emilio on 26/08/23.
//

import Foundation

extension String {
    func cleanForSearch() -> String {
        return self.lowercased().trimmingCharacters(in: .whitespaces)
    }
}
