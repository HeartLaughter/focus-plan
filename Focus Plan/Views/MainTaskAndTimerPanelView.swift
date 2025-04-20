import SwiftUI

struct MainTaskAndTimerPanelView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @StateObject private var timerPanel = TimerPanelState()
    @State private var selectedTask: Task? = nil

    var body: some View {
        HStack(spacing: 0) {
            // 左侧任务列表
            TaskView(viewModel: taskViewModel, onTaskSelect: { task in
                selectedTask = task
                timerPanel.showPomodoroPicker(for: task)
            })
            .frame(width: 320)
            .background(Color.gray.opacity(0.1))
            Divider()

            // 右侧面板
            Group {
                if let task = selectedTask, timerPanel.isShowing {
                    if timerPanel.mode == .none {
                        VStack(spacing: 20) {
                            Text("为『\(task.name)』选择计时方式")
                                .font(.headline)
                            Button("番茄钟") {
                                // 可扩展为弹窗选择 25/45/60
                                timerPanel.startPomodoro(minutes: 25)
                            }
                            Button("正向计时") {
                                timerPanel.startForward(for: task)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        TimerPanelView(timerPanel: timerPanel)
                    }
                } else {
                    Text("请选择任务")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}
