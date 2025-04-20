import SwiftUI
import Combine

enum TimerMode: Equatable {
    case none
    case pomodoro(minutes: Int)
    case forward
}

class TimerPanelState: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var mode: TimerMode = .none
    @Published var remainingSeconds: Int = 0
    @Published var elapsedSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentTaskId: UUID? = nil

    private var timer: Timer?
    private var startDate: Date?
    private var totalDuration: Int = 0

    func showPomodoroPicker(for task: Task) {
        currentTaskId = task.id
        mode = .none
        isShowing = true
        reset()
    }

    func startPomodoro(minutes: Int) {
        mode = .pomodoro(minutes: minutes)
        totalDuration = minutes * 60
        remainingSeconds = totalDuration
        elapsedSeconds = 0
        isRunning = true
        startDate = Date()
        startTimer()
    }

    func startForward(for task: Task) {
        currentTaskId = task.id
        mode = .forward
        elapsedSeconds = 0
        isRunning = true
        startDate = Date()
        startTimer()
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        guard isRunning == false else { return }
        isRunning = true
        startDate = Date()
        startTimer()
    }

    func reset() {
        pause()
        remainingSeconds = 0
        elapsedSeconds = 0
        mode = .none
    }

    func stop() {
        pause()
        isShowing = false
        mode = .none
        currentTaskId = nil
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        guard isRunning else { return }
        switch mode {
        case .pomodoro(_):
            if remainingSeconds > 0 {
                remainingSeconds -= 1
                elapsedSeconds = totalDuration - remainingSeconds
            } else {
                isRunning = false
                timer?.invalidate()
                // 这里可以添加计时完成后的回调
            }
        case .forward:
            elapsedSeconds += 1
        default:
            break
        }
    }
}
