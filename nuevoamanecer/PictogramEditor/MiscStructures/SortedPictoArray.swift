//
//  SortedArray.swift
//  Comunicador
//
//  Created by emilio on 24/05/23.
//

import Foundation

class SortedPictoArray {
    private var pictograms: [PictogramModel] = []
    var count: Int {
        return pictograms.count 
    }
            
    func add(picto: PictogramModel) -> Void {
        let pictoNameLowered: String = picto.name.lowercased()
        
        if pictograms.isEmpty || pictograms.last!.name.lowercased() <= pictoNameLowered {
            pictograms.append(picto)
            return 
        }
        
        for i in 0..<pictograms.count {
            if pictoNameLowered <= pictograms[i].name.lowercased() {
                pictograms.insert(picto, at: i)
                return
            }
        }
    }
    
    func remove(picto: PictogramModel) -> Void {
        if pictograms.isEmpty {
            return
        }
        
        for i in 0..<pictograms.count {
            if picto.id! == pictograms[i].id! {
                pictograms.remove(at: i)
                return 
            }
        }
    }
    
    func updateWith(picto: PictogramModel, with newPicto: PictogramModel) -> Void {
        self.remove(picto: picto)
        self.add(picto: newPicto)
    }
    
    func elements() -> [PictogramModel] {
        return self.pictograms
    }
}
