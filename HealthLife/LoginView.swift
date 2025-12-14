//
//  LoginView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 28/11/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            LoginBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 22) {
                
                Text("Welcome!")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                
                // Fields
                VStack(spacing: 18) {
                    TextField("User", text: $username)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.white)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.white)
                    
                    // Error message
                    if let error = authenticationManager.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.opacity)
                            .accessibilityIdentifier("login_error_message")
                    }
                }
                
                // Buttons
                VStack(spacing: 14) {
                    Button(action: {
                        authenticationManager.login(username: username, password: password)
                    }) {
                        Text("Login")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white.opacity(0.85))
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                     
                    Button("Forgot my password") {
                        //todo
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .font(.callout)
                    
                    NavigationLink("Create New User", destination: CreateNewUserView())
                        .foregroundColor(.white.opacity(0.9))
                        .font(.callout)
                }
            }
            .padding(32)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 25)
            )
            .shadow(color: .black.opacity(0.25), radius: 20)
            .padding()
        }
    }
}
