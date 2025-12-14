//
//  AuthenticationManager.swift
//  HealthLife
//
//  Created by Antonio Almeida on 29/11/25.
//

import Combine
import Foundation

@MainActor
final class AuthenticationManager: ObservableObject {

    // @Published property always notifies the Views when its value changes.
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil
    @Published var username: String? = nil

    // Mocked login function with a small delay to simulate work.
    func login(username: String, password: String) {
        // Trim once
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines)
//        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        // You can add validation here if needed and set errorMessage.

        Task {
            try? await Task.sleep(for: .seconds(0.5)) // 0.5s
            // Set the username upon successful login
            self.username = u
            self.isAuthenticated = true
            print("User Authenticated: \(self.isAuthenticated), username: \(self.username ?? "-")")
        }
    }

    func logout() {
        self.isAuthenticated = false
        self.errorMessage = nil
        self.username = nil
        print("User logged out: \(self.isAuthenticated)")
    }
}

