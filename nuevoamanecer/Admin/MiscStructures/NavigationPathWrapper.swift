//
//  NavigationPathWrapper.swift
//  nuevoamanecer
//
//  Created by emilio on 22/08/23.
//

import Foundation
import SwiftUI

class NavigationPathWrapper: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    func push<V: Hashable>(_ data: V) -> Void {
            self.path.append(data)
    }
    
    func pop() -> Void {
        if path.count > 0 {
                self.path.removeLast(1)
        }
    }
    
    func returnToRoot() -> Void {
            self.path.removeLast(self.path.count)
    }
}
