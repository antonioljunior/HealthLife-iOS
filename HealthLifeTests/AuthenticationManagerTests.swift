////
////  AuthenticationManagerTests.swift
////  HealthLifeTests
////
////  Created by Antonio Almeida on 02/12/25.
////
//
//import Testing
//@testable import HealthLife
//
//@Suite("AuthenticationManager")
//struct AuthenticationManagerTests {
//
//    @Test("Initial state")
//    @MainActor
//    func testInitialState() async throws {
//        let manager = AuthenticationManager()
//        #expect(manager.isAuthenticated == false)
//        #expect(manager.username == nil)
//        #expect(manager.errorMessage == nil)
//    }
//
//    @Test("Login succeeds")
//    @MainActor
//    func testLoginSucceeds() async throws {
//        let manager = AuthenticationManager()
//
//        manager.login(username: "Alice", password: "secret")
//        try await Task.sleep(for: .milliseconds(600))
//
//        #expect(manager.isAuthenticated == true)
//        #expect(manager.username == "Alice")
//        #expect(manager.errorMessage == nil)
//    }
//
//    @Test("Logout clears state")
//    @MainActor
//    func testLogoutClearsState() async throws {
//        let manager = AuthenticationManager()
//
//        manager.login(username: "Bob", password: "pw")
//        try await Task.sleep(for: .milliseconds(600))
//
//        manager.logout()
//
//        #expect(manager.isAuthenticated == false)
//        #expect(manager.username == nil)
//        #expect(manager.errorMessage == nil)
//    }
//
//    @Test("Username is trimmed on login")
//    @MainActor
//    func testTrimsUsername() async throws {
//        let manager = AuthenticationManager()
//
//        manager.login(username: "   Carol  ", password: "pw")
//        try await Task.sleep(for: .milliseconds(600))
//
//        #expect(manager.username == "Carol")
//    }
//}
