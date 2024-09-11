//
//  WorkoutTimerWithWatchAppDeokhoApp.swift
//  WorkoutTimerWithWatchAppDeokho
//
//  Created by Jeong Deokho on 8/5/24.
//

import SwiftUI

@main
struct WorkoutTimerWithWatchAppDeokhoApp: App {

    
    var body: some Scene {
        WindowGroup {
                WorkoutView()
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("운동기록")
                    }
            .accentColor(.white)
            .preferredColorScheme(.dark)

        }
    }
}
