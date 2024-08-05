//
//  WorkoutViewModel.swift
//  WorkoutTimerWithWatchAppDeokho
//
//  Created by Jeong Deokho on 8/5/24.
//

import SwiftUI
import WatchConnectivity

final class WorkOutViewModel: NSObject, ObservableObject, WCSessionDelegate {

    @Published var workOutModels: [WorkOutModel] {
        didSet {
            save()
        }
    }
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var response = false


    private var session: WCSession?

    override init() {
        if let data = UserDefaults.standard.data(forKey: "WorkOutData"),
           let decoded = try? JSONDecoder().decode([WorkOutModel].self, from: data) {
            self.workOutModels = decoded
        } else {
            self.workOutModels = []
        }
        super.init()
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(workOutModels) {
            UserDefaults.standard.set(encoded, forKey: "WorkOutData")
        }
    }

    func addSection(name: String) {
        workOutModels.append(WorkOutModel(sectionName: name, detailModels: []))
    }

    func addWorkOut(to sectionIndex: Int, name: String) {
        workOutModels[sectionIndex].detailModels.append(WorkOutDetail(workOutName: name))
    }

    func deleteSection(at offsets: IndexSet) {
        workOutModels.remove(atOffsets: offsets)
    }

    func deleteWorkOut(at sectionIndex: Int, offsets: IndexSet) {
        workOutModels[sectionIndex].detailModels.remove(atOffsets: offsets)
    }

    func updateWorkOutDetail(at sectionIndex: Int, detailIndex: Int, reps: Int, weight: Int) {
        guard sectionIndex < workOutModels.count,
              detailIndex < workOutModels[sectionIndex].detailModels.count else {
            return
        }
        workOutModels[sectionIndex].detailModels[detailIndex].reps = reps
        workOutModels[sectionIndex].detailModels[detailIndex].weight = weight
    }

    func sendSession() {
        if WCSession.isSupported() {
            isLoading = true
            guard let session = session, session.activationState == .activated else {
                isLoading = false
                errorMessage = "통신이 활성화되지 않았습니다."
                return
            }

            guard session.isReachable else {
                isLoading = false
                errorMessage = "애플워치가 연결되어 있지 않습니다.\n애플워치 화면과 앱이 켜져있어야 합니다."
                showErrorAlert = true
                return
            }

            if let encoded = try? JSONEncoder().encode(workOutModels) {
                do {
                    try session.updateApplicationContext(["WorkOutData": encoded])
                    isLoading = false
                    self.errorMessage = "전송에 성공했습니다."
                    showErrorAlert = true
                } catch {
                    isLoading = false
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        } else {
            errorMessage = "데이터 전송을 사용할수없는 기기입니다."
            showErrorAlert = true
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let receivedData = applicationContext["WorkOutData"] as? Data {
                do {
                    let decodedData = try JSONDecoder().decode([WorkOutModel].self, from: receivedData)
                    self.updateWorkOutModels(with: decodedData)
                } catch {
                    self.errorMessage = "데이터 디코딩 실패: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }
    }

    private func updateWorkOutModels(with newModels: [WorkOutModel]) {
        self.workOutModels = newModels
        self.save()
        self.errorMessage = "운동기록이 동기화 되었습니다."
        self.showErrorAlert = true
        self.response.toggle()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }

}
