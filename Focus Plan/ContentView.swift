//
//  ContentView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 18.04.25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDuration = 25
    @State private var timeRemaining = 0
    @State private var timerRunning = false
    @State private var timer: Timer? = nil

    let durations = [25, 45, 60] // 可选时间（分钟）

    var body: some View {
        VStack(spacing: 20) {
            Text("番茄钟")
                .font(.largeTitle)
                .bold()

            Picker("选择时间", selection: $selectedDuration) {
                ForEach(durations, id: \.self) { duration in
                    Text("\(duration) 分钟")
                }
            }

            .pickerStyle(SegmentedPickerStyle())
            .disabled(timerRunning)
            .padding()

            Text(timeString())
                .font(.system(size: 48, weight: .medium, design: .monospaced))
                .frame(minWidth: 200)

            HStack(spacing: 20) {
                Button(action: startTimer) {
                    Text(timerRunning ? "运行中…" : "开始")
                }
                .disabled(timerRunning)

                Button("重置", action: resetTimer)
                    .disabled(!timerRunning && timeRemaining == 0)
            }
        }
        .padding()
    }

    func startTimer() {
        timeRemaining = selectedDuration * 60
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timer = nil
                timerRunning = false
            }
        }
    }

    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        timeRemaining = 0
    }

    func timeString() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
