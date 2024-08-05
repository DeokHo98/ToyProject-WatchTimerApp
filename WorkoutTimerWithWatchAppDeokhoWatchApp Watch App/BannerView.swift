//
//  BannerView.swift
//  WorkoutTimerWithWatchAppDeokhoWatchApp Watch App
//
//  Created by Jeong Deokho on 8/5/24.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    @Binding var show: Bool
    let message: String

    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if show {
                VStack {
                    Text(message)
                        .font(.body)
                        .padding()
                        .background(Color(uiColor: .darkGray))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    workItem?.cancel()

                    let task = DispatchWorkItem {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            show = false
                        }
                    }
                    workItem = task
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
                }
                .onDisappear {
                    workItem?.cancel()
                }
            }
        }
    }
}

extension View {
    func banner(show: Binding<Bool>, message: String) -> some View {
        self.modifier(BannerModifier(show: show, message: message))
    }
}
