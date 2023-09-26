//
//  ArrayExtensions.swift
//  nuevoamanecer
//
//  Created by emilio on 07/09/23.
//

import Foundation

extension Array {
    // Cambia la posición del elemento que se encuentra en el índice from. Tras el cambio, su nueva posición es to
    // en el arreglo.
    mutating func moveItem(from: Int, to: Int) -> Void { // Asume indices no negativos. 
        let removedItem: Self.Element = self.remove(at: from)
        if to <= self.count {
            self.insert(removedItem, at: to)
        } else {
            self.append(removedItem)
        }
    }
}
