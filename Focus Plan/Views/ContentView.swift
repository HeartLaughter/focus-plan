import SwiftUI

struct ContentView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    
    var body: some View {
        TabView {
            TaskView(viewModel: taskViewModel)
                .tabItem {
                    Label("任务", systemImage: "list.bullet")
                }

            CalendarView(viewModel: CalendarViewModel(taskViewModel: taskViewModel))
                .tabItem {
                    Label("日历", systemImage: "calendar")
                }

            StatisticsView(viewModel: StatisticsViewModel(taskViewModel: taskViewModel))
                .tabItem {
                    Label("统计", systemImage: "chart.bar")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}