//
//  UserModel.swift
//  HealthLife
//
//  Created by Antonio Almeida on 28/11/25.
//

import SwiftData

@Model
final class UserModel {
    var username: String
    var password: String

    init(username: String = "", password: String = "") {
        self.username = username
        self.password = password
    }
}
