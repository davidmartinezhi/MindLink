//
//  SortedArray.swift
//  Comunicador
//
//  Created by emilio on 24/05/23.
//

import Foundation

class SortedArray<T: Comparable> {
    private var items: [T] = []
    var count: Int {
        return items.count
    }
                
    func add(item: T) -> Void {
        if items.isEmpty || items.last! <= item {
            items.append(item)
            return 
        }
        
        let indexOfPrevElem: Int = findItemPos(item: item)
        items.insert(item, at: indexOfPrevElem + 1)
    }
    
    func remove(item: T) -> Void {
        if items.isEmpty {
            return
        }
        
        let itemIndex: Int? = findItem(item: item)
        
        if let unwrappedIndex: Int = itemIndex {
            items.remove(at: unwrappedIndex)
        }
    }
    
    func updateWith(item: T, with newItem: T) -> Void {
        self.remove(item: item)
        self.add(item: newItem)
    }
    
    func getItems(descending: Bool = false) -> [T] {
        if descending {
            var itemsDescending: [T] = []
            for i in (self.count-1)...0 {
                itemsDescending.append(self.items[i])
            }
            return itemsDescending
        } else {
            return self.items
        }
    }
    
    private func findItem(item: T) -> Int? {
        var l: Int = 0
        var r: Int = items.count - 1
        
        while l <= r {
            let mid: Int = (l + r) / 2
            
            if item == items[mid] {
                return mid
            } else if items[mid] < item {
                l = mid + 1
            } else {
                r = mid - 1
            }
        }
        
        return nil
    }
    
    private func findItemPos(item: T) -> Int {
        var l: Int = 0
        var r: Int = items.count - 1
        
        while l <= r {
            let mid: Int = (l + r) / 2
            
            if items[mid] <= item && (mid+1 < items.count ? item <= items[mid+1] : true) {
                return mid
            } else if items[mid] < item {
                l = mid + 1
            } else {
                r = mid - 1
            }
        }
        
        return r
    }
}
