//
//  UsersViewModel.swift
//  FetchDataWithCombine
//
//  Created by Madalin Zaharia on 14.03.2023.
//

import Foundation
import Combine

class UsersViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var users: [User] = []
    
    func getUsers() {
        NetworkManager.shared.getData(type: UserResponse.self)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                guard let self = self else { return }
                
                self.users = user.users
            }
            .store(in: &cancellables)
    }
}
