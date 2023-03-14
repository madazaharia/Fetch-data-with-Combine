//
//  User.swift
//  FetchDataWithCombine
//
//  Created by Madalin Zaharia on 14.03.2023.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
}
