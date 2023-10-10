//
//  UserMethods.swift
//  nuevoamanecer
//
//  Created by emilio on 08/10/23.
//

import Foundation

func filterUsers(users: [User], searchText: String, userType: UserType = .baseUserOrAdminUser) -> [User] {
    if !searchText.isEmpty {
        return filterUsersByType(users: filterUsersBySearchText(users: users, searchText: searchText), userType: userType)
    } else {
        return filterUsersByType(users: users, userType: userType)
    }
}

func sortUsersByName(users: [User]) -> [User] {
    return users.sorted {$0.name.cleanForSearch() < $1.name.cleanForSearch()}
}

func filterUsersByType(users: [User], userType: UserType) -> [User] {
    return users.filter { user in
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

func filterUsersBySearchText(users: [User], searchText: String) -> [User] {
    let cleanedSearchText: String = searchText.cleanForSearch()
    return users.filter {$0.name.cleanForSearch().contains(cleanedSearchText)}
}

func userArrayToDict(users: [User]) -> [String:User] {
    return Dictionary(uniqueKeysWithValues: users.map {($0.id!, $0)})
}
