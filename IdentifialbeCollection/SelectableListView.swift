//
//  ContentView.swift
//  IdentifialbeCollection
//
//  Created by Inti Albuquerque on 20/06/21.
//

import SwiftUI

struct SelectableListView: View {
    @StateObject var viewModel = SelectableListViewModel()
    var body: some View {
        List {
            ForEach(viewModel.users.sortedElements) { user in
                HStack {
                    VStack(alignment: .leading){
                        Text("username: \(user.name)")
                        Text("favorite animal: \(user.favoriteAnimal)")
                    }
                    Spacer()
                    if user.isSelected {
                        Image("check")
                            .renderingMode(.template)
                            .foregroundColor(.green)
                            .frame(width: 16, height: 16)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 1, perform: {
                    viewModel.selectUser(user)
                })
            }
        }
        .refreshable {
            await self.viewModel.fetchUsers()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SelectableListView()
    }
}
