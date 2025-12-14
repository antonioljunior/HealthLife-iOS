//
//  CreateNewUserView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 30/11/25.
//

import SwiftUI

struct CreateNewUserView: View {
    @State private var newUsername = ""
    @State private var newPassword = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Create your account")
                .font(.largeTitle)
                .bold()
            
            TextField("User Name", text: $newUsername)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Register") {
                //todo
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer() // Push the content to the top of the screen
        }
        .padding(.top, 40)
        .navigationTitle("Registro")
    }
}
#Preview("New User") {
    CreateNewUserView()
}
