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
    
    func push<V: Hashable>(data: V) -> Void {
        DispatchQueue.main.async {
            self.path.append(data)
        }
    }
    
    func pop() -> Void {
        if path.count > 0 {
            DispatchQueue.main.async {
                self.path.removeLast(1)
            }
        }
    }
    
    func returnToRoot() -> Void {
        DispatchQueue.main.async {
            self.path.removeLast(self.path.count)
        }
    }
}
