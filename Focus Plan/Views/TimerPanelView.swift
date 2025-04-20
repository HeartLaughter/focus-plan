import SwiftUI

struct TimerPanelView: View {
    @ObservedObject var timerPanel: TimerPanelState
    
    var body: some View {
        VStack(spacing: 24) {
            switch timerPanel.mode {
            case .pomodoro(let minutes):
                Text("番茄钟：\(minutes)分钟")
                    .font(.title2)
                Text("剩余：\(timerPanel.remainingSeconds) 秒")
                    .font(.title)
            case .forward:
                Text("正向计时")
                    .font(.title2)
                Text("已用：\(timerPanel.elapsedSeconds) 秒")
                    .font(.title)
            default:
                EmptyView()
            }
            HStack(spacing: 24) {
                if timerPanel.isRunning {
                    Button("暂停") { timerPanel.pause() }
                } else {
                    Button("继续") { timerPanel.resume() }
                }
                Button("重置") { timerPanel.reset() }
                Button("关闭") { timerPanel.stop() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
