//
//  TimerView.swift
//  WorkoutTimerWithWatchAppDeokhoWatchApp Watch App
//
//  Created by Jeong Deokho on 8/5/24.
//

import SwiftUI

struct TimerView: View {
  
    @Environment(\.scenePhase) var scenePhase

    @State private var sets = 0
    @State private var timerTime = 0
    @State private var settingTime = 0
    @State private var isShowingSettingView = false
    @State private var isShowingMemoView = false
    @State private var timer: Timer?
    @State private var extendedSession: WKExtendedRuntimeSession?
    @State private var backgroundStartTime: Date?

    @StateObject var viewModel = WorkOutViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text("\(sets) 세트")
                    .font(.system(size: 15, weight: .semibold))
                Text("\(timerTime) 초")
                    .font(.system(size: 20, weight: .bold))
                ScrollView {
                    HStack {
                        Button("직접설정") {
                            isShowingSettingView = true
                        }
                        .font(.system(size: 18, weight: .semibold))
                        Button("0초") {
                            settingTime = 0
                            timerTime = 0
                            timer?.invalidate()
                            timer = nil
                            stopExtendedSession()
                        }
                        .font(.system(size: 18, weight: .semibold))
                    }
                    HStack {
                        Button("30초") {
                            settingTime = 30
                            startTimer()
                        }
                        .font(.system(size: 18, weight: .semibold))
                        Button("1분") {
                            settingTime = 60
                            startTimer()
                        }
                        .font(.system(size: 18, weight: .semibold))
                    }

                    HStack {
                        Button("1분 30초") {
                            settingTime = 90
                            startTimer()
                        }
                        .font(.system(size: 18, weight: .semibold))
                        Button("2분") {
                            settingTime = 120
                            startTimer()
                        }
                        .font(.system(size: 18, weight: .semibold))
                    }

                    HStack {
                        Button("2분 30초") {
                            settingTime = 150
                            startTimer()
                        }
                        .font(.system(size: 18, weight: .semibold))
                        Button("3분") {
                            settingTime = 180
                            startTimer()
                        }
                        .font(.system(size: 18, weight: .semibold))
                    }
                }
            }
            .navigationDestination(isPresented: $isShowingSettingView) {
                SettingTimerView { settingTime in
                    self.settingTime = settingTime
                    startTimer()
                }
            }
            .navigationDestination(isPresented: $isShowingMemoView) {
                WorkoutView(viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("세트 초기화") {
                        sets = 0
                    }
                    .foregroundStyle(.white)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("운동기록") {
                        isShowingMemoView = true
                    }.foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            updateTimerOnForeground()
            
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                updateTimerOnForeground()
            }
        }
        .banner(show: $viewModel.showBannger, message: viewModel.message)
    }

    private func startTimer() {
        guard settingTime != 0 else { return }
        timer?.invalidate()
        timer = nil
        timerTime = settingTime
        backgroundStartTime = Date()

        startExtendedSession()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timerTime <= 0 {
                timer?.invalidate()
                timer = nil
                stopExtendedSession()
                sets += 1
                WKInterfaceDevice.current().play(.notification)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    WKInterfaceDevice.current().play(.notification)
                }
                return
            }
            timerTime -= 1
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerTime = 0
        stopExtendedSession()
    }

    private func startExtendedSession() {
        extendedSession = WKExtendedRuntimeSession()
        extendedSession?.start()
    }

    private func stopExtendedSession() {
        extendedSession?.invalidate()
        extendedSession = nil
    }

    private func updateTimerOnForeground() {
        guard let startTime = backgroundStartTime else { return }
        let elapsedTime = Int(Date().timeIntervalSince(startTime))
        timerTime = max(0, settingTime - elapsedTime)
        if timerTime == 0 {
            stopExtendedSession()
        }
    }
}

struct SettingTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @State var settingMin: Int = 0
    @State var settingSec: Int = 1

    var onSave: (Int) -> Void

    var body: some View {
        VStack {
            Button("설정하기") {
                let min = settingMin * 60
                let sec = settingSec
                onSave(min + sec)
                dismiss()
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            Spacer()
            HStack {
                Picker("분", selection: $settingMin) {
                    ForEach(0..<60, id: \.self) {
                        Text("\($0) 분")
                    }
                }
                .pickerStyle(WheelPickerStyle())

                Picker("초", selection: $settingSec) {
                    ForEach(1..<60, id: \.self) {
                        Text("\($0) 초")
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
    }
}
