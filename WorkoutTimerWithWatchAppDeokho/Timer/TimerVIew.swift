//
//  TimerVIew.swift
//  WorkoutTimerWithWatchAppDeokho
//
//  Created by Jeong Deokho on 8/5/24.
//

import SwiftUI

struct TimerView: View {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) private var scenePhase

    var customColor: Color {
        colorScheme == .dark ? Color(uiColor: .darkGray.withAlphaComponent(0.8)) : Color.blue
    }

    @State private var sets = 0
    @State private var timerStartDate: Date?
    @State private var timerTime: TimeInterval = 0
    @State private var settingTime: TimeInterval = 0
    @State private var isShowingSettingView = false
    @State private var timer: Timer?
    @State private var alertNum: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Button("세트 초기화") {
                    sets = 0
                }
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(customColor.opacity(0.8))
                .cornerRadius(10)

                CircularTimerView(startDate: timerStartDate, duration: settingTime, sets: sets)
                .padding()

                ScrollView {
                    HStack(spacing: 20) {
                        Button(action: {
                            isShowingSettingView = true
                        }) {
                            Text("직접 설정")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                        .alert("쉬는시간 입력 (초단위)", isPresented: $isShowingSettingView) {
                            TextField("쉬는시간을 시간을 입력하세요", text: $alertNum)
                                .keyboardType(.numberPad)

                            Button("취소", role: .cancel) {
                                alertNum = ""
                            }

                            Button("확인") {
                                if let alertNum = Int(alertNum) {
                                    settingTime = TimeInterval(alertNum)
                                    startTimer()
                                }
                            }
                        }


                        Button(action: {
                            settingTime = 0
                            timerStartDate = nil
                            timerTime = 0
                            timer?.invalidate()
                            timer = nil
                        }) {
                            Text("0초")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)



                    HStack(spacing: 20) {
                        Button(action: {
                            settingTime = 30
                            startTimer()
                        }) {
                            Text("30")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }

                        Button(action: {
                            settingTime = 60
                            startTimer()
                        }) {
                            Text("1분")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)




                    HStack(spacing: 20) {
                        Button(action: {
                            settingTime = 90
                            startTimer()
                        }) {
                            Text("1분 30초")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }

                        Button(action: {
                            settingTime = 120
                            startTimer()
                        }) {
                            Text("2분")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    HStack(spacing: 20) {
                        Button(action: {
                            settingTime = 150
                            startTimer()
                        }) {
                            Text("2분 30초")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }

                        Button(action: {
                            settingTime = 180
                            startTimer()
                        }) {
                            Text("3분")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    HStack(spacing: 20) {
                        Button(action: {
                            settingTime = 210
                            startTimer()
                        }) {
                            Text("3분 30초")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }

                        Button(action: {
                            settingTime = 240
                            startTimer()
                        }) {
                            Text("4분")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    HStack(spacing: 20) {
                        Button(action: {
                            settingTime = 270
                            startTimer()
                        }) {
                            Text("4분 30초")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }

                        Button(action: {
                            settingTime = 300
                            startTimer()
                        }) {
                            Text("5분")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(customColor.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
    }

    private func startTimer() {
        guard settingTime != 0 else { return }
        timer?.invalidate()
        timer = nil
        timerTime = settingTime
        timerStartDate = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timerTime <= 1 {
                timer?.invalidate()
                timer = nil
                sets += 1
                timerStartDate = nil
                return
            }
            timerTime -= 1
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerTime = 0
        timerStartDate = nil
    }
}


struct CircularTimerView: View {
    let startDate: Date?
    let duration: TimeInterval
    let sets: Int

    @State private var currentDate = Date()

    @Environment(\.colorScheme) var colorScheme

     var customColor: Color {
         colorScheme == .dark ? Color.gray : Color.blue
     }


    var progress: Double {
        let elapsedTime = currentDate.timeIntervalSince(startDate ?? Date())
        return min(max(elapsedTime / duration, 0), 1)
    }

    var timeRemaining: Int {
        let elapsedTime = currentDate.timeIntervalSince(startDate ?? Date())
        return max(Int(ceil(duration - elapsedTime)), 0)
    }
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let center = CGPoint(x: size.width/2, y: size.height/2)
                let radius = min(size.width, size.height) / 2 - 10

                // Background circle
                context.stroke(Circle().path(in: CGRect(x: 10, y: 10, width: size.width - 20, height: size.height - 20)),
                               with: .color(customColor.opacity(0.3)),
                               lineWidth: 20)

                // Progress arc
                context.stroke(Path { path in
                    path.addArc(center: center,
                                radius: radius,
                                startAngle: .degrees(-90),
                                endAngle: .degrees(-90 + 360 * progress),
                                clockwise: false)
                }, with: .color(customColor.opacity(0.8)),
                               style: StrokeStyle(lineWidth: 20, lineCap: .round))

                // Text
                let timeString = startDate == nil ? "0 초" : "\(timeRemaining) 초"
                let setsString = "\(sets) 세트"
                let timeStringFont = Font.system(size: 50, weight: .bold)
                let setsStringFont = Font.system(size: 40, weight: .bold)

                context.draw(Text(setsString).font(setsStringFont), at: center.applying(CGAffineTransform(translationX: 0, y: -30)))
                context.draw(Text(timeString).font(timeStringFont), at: center.applying(CGAffineTransform(translationX: 0, y: 40)))

            }
            .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
            .onChange(of: timeline.date) { _, newDate in
                currentDate = newDate
            }
        }
    }
}
