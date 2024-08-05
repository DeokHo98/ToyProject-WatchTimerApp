//
//  WorkOutViewModel.swift
//  WorkoutTimerWithWatchAppDeokhoWatchApp Watch App
//
//  Created by Jeong Deokho on 8/5/24.
//

import Foundation
import WatchConnectivity

final class WorkOutViewModel: NSObject, ObservableObject, WCSessionDelegate {

    @Published var workOutModels: [WorkOutModel] {
        didSet {
            save()
        }
    }
    @Published var message = ""
    @Published var showBannger = false
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
            guard let session = session, session.activationState == .activated else {
                message = "통신이 활성화되지 않았습니다."
                showBannger = true
                return
            }

            guard session.isReachable else {
                message = "아이폰이 연결되어 있지 않습니다."
                showBannger = true
                return
            }

            if let encoded = try? JSONEncoder().encode(workOutModels) {
                do {
                    try session.updateApplicationContext(["WorkOutData": encoded])
                    self.message = "전송에 성공했습니다."
                    showBannger = true
                } catch {
                    message = error.localizedDescription
                    showBannger = true
                }
            }
        } else {
            message = "데이터 전송을 사용할수없는 기기입니다."
            showBannger = true
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
                    self.message = "데이터 디코딩 실패: \(error.localizedDescription)"
                    showBannger = true
                }
            }
        }
    }

    private func updateWorkOutModels(with newModels: [WorkOutModel]) {
        self.workOutModels = newModels
        self.save()
        message = "운동기록이 동기화 되었습니다."
        showBannger = true
        response.toggle()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
}
