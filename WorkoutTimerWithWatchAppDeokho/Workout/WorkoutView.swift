//
//  WorkoutView.swift
//  WorkoutTimerWithWatchAppDeokho
//
//  Created by Jeong Deokho on 8/5/24.
//

import SwiftUI

struct WorkoutView: View {
    @StateObject private var viewModel = WorkOutViewModel()
    @State private var showingAddSectionAlert = false
    @State private var newSectionName = ""
    @State private var showingAddWorkOutAlert = false
    @State private var newWorkOutName = ""
    @State private var selectedSectionIndex: Int?
    @State private var expandedSectionIndex: Int?


    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(Array(viewModel.workOutModels.enumerated()), id: \.element.id) { index, model in
                        DisclosureGroup(
                            isExpanded: Binding(
                                get: { expandedSectionIndex == index },
                                set: { isExpanded in
                                    if isExpanded {
                                        expandedSectionIndex = index
                                    } else if expandedSectionIndex == index {
                                        expandedSectionIndex = nil
                                    }
                                }
                            ),
                            content: {
                                ForEach(Array(model.detailModels.enumerated()), id: \.element.id) { detailIndex, detail in
                                    WorkoutDetailRow(viewModel: viewModel,
                                                     sectionIndex: index,
                                                     detailIndex: detailIndex,
                                                     workOutName: detail.workOutName)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.deleteWorkOut(at: index, offsets: IndexSet(integer: detailIndex))
                                        } label: {
                                            Label("삭제", systemImage: "")
                                        }
                                    }
                                }

                                Button(action: {
                                    selectedSectionIndex = index
                                    showingAddWorkOutAlert = true
                                }) {
                                    Label("운동 추가", systemImage: "plus")
                                }
                            },
                            label: {
                                Text(model.sectionName)
                                    .font(.headline)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            viewModel.deleteSection(at: IndexSet(integer: index))
                                        } label: {
                                            Label("삭제", systemImage: "")
                                        }
                                    }
                            }
                        )
                        .padding(10)
                    }
                }
                if viewModel.isLoading {
                    Color(uiColor: .label).opacity(0.4)
                         .edgesIgnoringSafeArea(.all)
                     ProgressView()
                         .progressViewStyle(CircularProgressViewStyle(tint: .white))
                         .scaleEffect(1.5)
                 }
            }
            .disabled(viewModel.isLoading)
            .listRowSpacing(10)
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing: Button(action: {
                showingAddSectionAlert = true
            }) {
                Text("운동 그룹 추가")
                    .foregroundStyle(.white)
            })
            .navigationBarItems(trailing: Button(action: {
                viewModel.sendSession()
            }) {
                Text("애플워치로 전송")
                    .foregroundStyle(.white)
            })
        }
        .alert("\(viewModel.errorMessage)", isPresented: $viewModel.showErrorAlert, actions: {
            Button("확인") {
                viewModel.errorMessage = ""
            }
        })
        .alert("운동 그룹 추가", isPresented: $showingAddSectionAlert) {
            TextField("그룹 이름", text: $newSectionName)
            Button("추가") {
                if !newSectionName.isEmpty {
                    viewModel.addSection(name: newSectionName)
                    newSectionName = ""
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("운동 그룹의 이름을 입력하세요.\nex) 가슴, 등, 밀기, 당기기")
        }
        .alert("운동 추가하기", isPresented: $showingAddWorkOutAlert) {
            TextField("운동 이름", text: $newWorkOutName)
            Button("추가") {
                if !newWorkOutName.isEmpty, let index = selectedSectionIndex {
                    viewModel.addWorkOut(to: index, name: newWorkOutName)
                    newWorkOutName = ""
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("새로운 운동의 이름을 입력하세요.\nex) 스쿼트, 데드리프트")
        }
    }
}

struct WorkoutDetailRow: View {
    @ObservedObject var viewModel: WorkOutViewModel
    let workOutName: String
    let sectionIndex: Int
    let detailIndex: Int
    @State private var reps: String = ""
    @State private var weight: String = ""

    init(viewModel: WorkOutViewModel, sectionIndex: Int, detailIndex: Int, workOutName: String) {
        self.viewModel = viewModel
        self.sectionIndex = sectionIndex
        self.detailIndex = detailIndex
        reps =  String(viewModel.workOutModels[sectionIndex].detailModels[detailIndex].reps)
        weight = String(viewModel.workOutModels[sectionIndex].detailModels[detailIndex].weight)
        self.workOutName = workOutName
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(workOutName)
                .fontWeight(.medium)
            HStack {
                TextField("횟수", text: $reps)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: reps, { _, new in
                        self.updateWorkOutDetail()
                    })
                    .fontWeight(.medium)
                Text("Reps")
                    .fontWeight(.medium)
                TextField("무게", text: $weight)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: weight, { _, _ in
                        self.updateWorkOutDetail()
                    })
                    .fontWeight(.medium)
                Text("kg/lbs")
                    .fontWeight(.medium)
            }
            .onChange(of: viewModel.response) { _, _ in
                reps =  String(viewModel.workOutModels[sectionIndex].detailModels[detailIndex].reps)
                weight = String(viewModel.workOutModels[sectionIndex].detailModels[detailIndex].weight)
            }
        }
    }

    private func updateWorkOutDetail() {
        if let reps = Int(reps), let weight = Int(weight) {
            viewModel.updateWorkOutDetail(at: sectionIndex, detailIndex: detailIndex, reps: reps, weight: weight)
            self.reps = String(reps)
            self.weight = String(weight)
        }
    }
}
