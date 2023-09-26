//
//  IdWrappers.swift
//  nuevoamanecer
//
//  Created by emilio on 22/08/23.
//

import Foundation
import SwiftUI

/*
enum ViewType {
    case singleCommunicator, doubleCommunicator, basePictogramEditor, userPictogramEditor, login, adminDash, patient
}
 */

struct NavigationDestination<Content:View>: Hashable {
    let id: UUID = UUID()
    let content: Content
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func==(lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        return lhs.id == rhs.id
    }
}
