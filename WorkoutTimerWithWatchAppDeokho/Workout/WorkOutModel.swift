//
//  WorkOutModel.swift
//  WorkoutTimerWithWatchAppDeokho
//
//  Created by Jeong Deokho on 8/5/24.
//

import Foundation

struct WorkOutModel: Codable, Identifiable {
    var id = UUID()
    var sectionName: String
    var detailModels: [WorkOutDetail]
}

struct WorkOutDetail: Codable, Identifiable {
    var id = UUID()
    var workOutName: String
    var reps: Int = 0
    var weight: Int = 0
}
