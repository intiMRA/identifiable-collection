//
//  IdentifiableCollection.swift
//  IdentifialbeCollection
//
//  Created by Inti Albuquerque on 20/06/21.
//

import Foundation

protocol Selecteble {
    func makeSelected() -> Self
    func makeDeSelected() -> Self
}

struct IdentifiableCollection<T: Identifiable & Selecteble> {
    
    typealias Element = T
    typealias Identifier = T.ID
    
    var elements: [Identifier: Element]
    var ids: [Identifier]
    
    var sortedElements: [Element] {
        ids.compactMap { elements[$0] }
    }
    
    init(with elements: [Element]) {
        var elementsDict = [Identifier: Element]()
        var ids = [Identifier]()
        
        elements.forEach { element in
            elementsDict[element.id] = element
            ids.append(element.id)
        }
        
        self.elements = elementsDict
        self.ids = ids
    }
    
    func element(with id: Identifier) -> Element? {
        elements[id]
    }
}

extension IdentifiableCollection: RangeReplaceableCollection {
    
    typealias SubSequence = IdentifiableCollection
    typealias Index = Array<Element>.Index
    
    var startIndex: Index {
        ids.startIndex
    }
    
    var endIndex: Index {
        ids.endIndex
    }
    
    init() {
        self.elements = [:]
        self.ids = []
    }
    
    mutating func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C) where C : Collection, T == C.Element {
        
        let idsToReplace = ids[subrange]
        idsToReplace.forEach { id in
            elements.removeValue(forKey: id)
        }
        
        ids.replaceSubrange(subrange, with: newElements.map(\.id))
        newElements.forEach { e in
            elements[e.id] = e
        }
    }
    
    subscript(bounds: Index) -> T {
        elements[ids[bounds]]!
    }
    
    func index(after i: Index) -> Index {
        ids.index(after: i)
    }
    
}

extension RangeReplaceableCollection where Element: Selecteble & Identifiable {
    
    func select(_ element: Element) -> Self {
        var newCollection = self
        let selectedCollection = newCollection.map { $0.id == element.id ? $0.makeSelected() : $0.makeDeSelected() }
        newCollection.removeAll()
        newCollection.append(contentsOf: selectedCollection)
        
        return newCollection
    }
}
