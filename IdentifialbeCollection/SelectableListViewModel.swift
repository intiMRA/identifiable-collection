//
//  SelectableListViewModel.swift
//  IdentifialbeCollection
//
//  Created by Inti Albuquerque on 20/06/21.
//

import Combine
import Foundation

struct User: Identifiable, Selecteble {
    let id: UUID
    let name: String
    let favoriteAnimal: String
    let isSelected: Bool
    
    func makeSelected() -> User {
        User(id: self.id, name: self.name, favoriteAnimal: self.favoriteAnimal, isSelected: true)
    }
    
    func makeDeSelected() -> User {
        User(id: self.id, name: self.name, favoriteAnimal: self.favoriteAnimal, isSelected: false)
    }
}

class SelectableListViewModel: ObservableObject {
    @Published var users: IdentifiableCollection<User> = IdentifiableCollection()
    
    init() {
            
        self.users = IdentifiableCollection([
            User(id: UUID(), name: "Peter", favoriteAnimal: "dragon", isSelected: false),
            User(id: UUID(), name: "John", favoriteAnimal: "monkey", isSelected: false),
            User(id: UUID(), name: "Matt", favoriteAnimal: "lion", isSelected: false)
        ])
    }
    
    func fetchUsers() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            var newUsers = [
                User(id: UUID(), name: "Peter", favoriteAnimal: "dragon", isSelected: false),
                User(id: UUID(), name: "John", favoriteAnimal: "monkey", isSelected: false),
                User(id: UUID(), name: "Matt", favoriteAnimal: "lion", isSelected: false)
            ]
            
            newUsers.append(contentsOf:  self.users.sortedElements)
            
            self.users = IdentifiableCollection(newUsers)
        }
    }
    
    func selectUser(_ user: User) {
        self.users = self.users.select(user)
    }
}

