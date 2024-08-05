//
//  WorkoutView.swift
//  WorkoutTimerWithWatchAppDeokhoWatchApp Watch App
//
//  Created by Jeong Deokho on 8/5/24.
//

import SwiftUI

struct WorkoutView: View {
    @StateObject var viewModel: WorkOutViewModel

    var body: some View {
        NavigationView {
            if viewModel.workOutModels.isEmpty {
                Text("운동기록이 없습니다.")
            } else {
                ScrollView {
                    ForEach(
                        Array(viewModel.workOutModels.enumerated()), id: \.element.id
                    ) { sectionIndex, section in
                        Text(section.sectionName).font(.title3)
                        ForEach(
                            Array(section.detailModels.enumerated()), id: \.element.id
                        ) { detailIndex, exercise in
                            NavigationLink(
                                destination: ExerciseDetailView(
                                    viewModel: viewModel,
                                    sectionIndex: sectionIndex,
                                    detailIndex: detailIndex
                                )
                            ) {
                                Text(exercise.workOutName)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("아이폰으로 전송") {
                            viewModel.sendSession()
                        }.foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

struct ExerciseDetailView: View {
    @StateObject var viewModel: WorkOutViewModel
    let sectionIndex: Int
    let detailIndex: Int

    var exercise: WorkOutDetail {
        viewModel.workOutModels[sectionIndex].detailModels[detailIndex]
    }

    @State var reps = 0
    @State var weight = 0

    var body: some View {
        Text("\(exercise.workOutName)").font(.title3).padding(.bottom, 5)
        stepperView(title: "Reps", value: self.$reps, updateFunc: { newValue in
            viewModel.updateWorkOutDetail(at: sectionIndex, detailIndex: detailIndex, reps: newValue, weight: exercise.weight)
        })
        stepperView(title: "Weight", value: self.$weight, updateFunc: { newValue in
            viewModel.updateWorkOutDetail(at: sectionIndex, detailIndex: detailIndex, reps: exercise.reps, weight: newValue)
        })

    }

    private func stepperView(title: String, value: Binding<Int>, updateFunc: @escaping (Int) -> Void) -> some View {
        VStack {
            if title == "Weight" {
                Text("\(title): \(value.wrappedValue) kg/lbs")
            } else {
                Text("\(title): \(value.wrappedValue) reps")
            }
            Stepper("", value: value, in: 0...Int.max)
                .onChange(of: value.wrappedValue) { _, newValue in
                    updateFunc(value.wrappedValue)
                }
        }
        .onChange(of: viewModel.response, { _, _ in
            self.reps = exercise.reps
            self.weight = exercise.weight
        })
        .onAppear {
            self.reps = self.exercise.reps
            self.weight = self.exercise.weight
        }
    }
}
