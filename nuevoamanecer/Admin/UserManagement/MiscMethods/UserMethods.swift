//
//  UserMethods.swift
//  nuevoamanecer
//
//  Created by emilio on 08/10/23.
//

import Foundation
import SwiftUI

func filterUsers(userIndexes: [(Int, User)], searchText: String, userType: UserType = .baseUserOrAdminUser) -> [(Int, User)] {
    if !searchText.isEmpty {
        return filterUsersByType(userIndexes: filterUsersBySearchText(userIndexes: userIndexes, searchText: searchText), userType: userType)
    } else {
        return filterUsersByType(userIndexes: userIndexes, userType: userType)
    }
}

func filterUsersByType(userIndexes: [(Int, User)], userType: UserType) -> [(Int, User)] {
    return userIndexes.filter { (index, user) in
        switch userType {
        case .baseUserOrAdminUser:
            return true
        case .adminUser:
            return user.isAdmin == true
        case .baseUser:
            return user.isAdmin == false
        }
    }
}

func filterUsersBySearchText(userIndexes: [(Int, User)], searchText: String) -> [(Int, User)] {
    let cleanedSearchText: String = searchText.cleanForSearch()
    return userIndexes.filter {(index, user) in user.name.cleanForSearch().contains(cleanedSearchText)}
}

func sortUsersByName(userIndexes: [(Int, User)]) -> [(Int, User)] {
    return userIndexes.sorted {$0.1.name.cleanForSearch() < $1.1.name.cleanForSearch()}
}

func userArrayToIndexesArray(users: [User]) -> [(Int, User)] {
    return users.enumerated().map {(index, user) in (index, user)}
}

