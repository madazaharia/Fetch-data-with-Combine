//
//  UsersView.swift
//  FetchDataWithCombine
//
//  Created by Madalin Zaharia on 14.03.2023.
//

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel = UsersViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.users.isEmpty {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.users, id: \.id) { user in
                        VStack(alignment: .leading) {
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("\(user.age) years old")
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Users")
            }
        }
        .onAppear {
            viewModel.getUsers()
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
