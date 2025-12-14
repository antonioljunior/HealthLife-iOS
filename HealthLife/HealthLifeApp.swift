//
//  HealthLifeApp.swift
//  HealthLife
//
//  Created by Antonio Almeida on 28/11/25.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct HealthLifeApp: App {
    @StateObject private var authenticationManager = AuthenticationManager()
    
    init(){
        requestNotificationPermissions()
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    // SwiftData container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserModel.self,
            HydrationModel.self,
            GymModel.self,
            BodyMeasurementModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authenticationManager.isAuthenticated {
                    HomeView()
                } else {
                    NavigationStack {
                        LoginView()
                    }
                }
            }
            .environmentObject(authenticationManager)
            .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: sharedModelContainer) { _, _ in
            // no-op; placeholder to show where container is available
        }
    }
}

