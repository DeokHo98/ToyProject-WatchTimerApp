//
//  WorkoutTimerWithWatchAppDeokhoWatchApp.swift
//  WorkoutTimerWithWatchAppDeokhoWatchApp
//
//  Created by Jeong Deokho on 8/5/24.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .never)
        completion(timeline)
    }
}

struct WidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.black // 검정색 배경
            Text("운동 타이머 바로가기")
                .foregroundColor(.white) // 하얀색 글자
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

@main
struct ComplicationConfiguration: Widget {
    let kind: String = "ComplicationConfiguration"

       var body: some WidgetConfiguration {
           StaticConfiguration(kind: kind, provider: Provider()) { entry in
               WidgetView(entry: entry)
           }
           .configurationDisplayName("운동 타이머")
           .description("운동 타이머로 바로가기 할 수 있는 위젯입니다.")
           .supportedFamilies([.accessoryRectangular])
       }
}

