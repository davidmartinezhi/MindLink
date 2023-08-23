//
//  IdWrappers.swift
//  nuevoamanecer
//
//  Created by emilio on 22/08/23.
//

import Foundation

enum ViewType {
    case singleCommunicator, doubleCommunicator, basePictogramEditor, userPictogramEditor, album 
}

struct NavigationDestination: Hashable {
    var viewType: ViewType
    var id: String = ""
}

