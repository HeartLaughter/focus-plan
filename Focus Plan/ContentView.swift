//
//  ContentView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 18.04.25.
//

import SwiftUI

// 主入口视图，包含底部 TabView
struct ContentView: View {
    @StateObject private var taskStore = TaskStore()  // 添加这一行

    var body: some View {
        TabView {
            TaskView()
                .tabItem {
                    Label("任务", systemImage: "list.bullet")
                }

            CalendarView()
                .tabItem {
                    Label("日历", systemImage: "calendar")
                }

            StatisticsView()
                .tabItem {
                    Label("统计", systemImage: "chart.bar")
                }
        }
        .environmentObject(taskStore)  // 添加这一行

    }
}

// 任务模型结构体，符合 Identifiable 和 Hashable 以支持 ForEach
struct Task: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var children: [Task]? = nil
    var isUsingPomodoro: Bool = true
    var startHour: Int? = nil
    var endHour: Int? = nil
}

// 全局任务数据模型
class TaskStore: ObservableObject {
    @Published var tasks: [Task] = [
        Task(name: "学习", children: [
            Task(name: "数学", startHour: 10, endHour: 12),
            Task(name: "英语", startHour: 14, endHour: 15)
        ]),
        Task(name: "工作", children: [
            Task(name: "项目 A", startHour: 16, endHour: 18)
        ])
    ]

    // 获取所有扁平化的任务（即 children 任务）
    var allFlatTasks: [Task] {
        tasks.flatMap { $0.children ?? [] }.filter { $0.startHour != nil && $0.endHour != nil }
    }
}

// 任务视图界面
struct TaskView: View {
    @StateObject private var taskStore = TaskStore()
    @State private var newFolderName: String = ""
    @State private var showingNewTaskAlert: UUID? = nil
    @State private var newTaskName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // 顶部添加文件夹栏
                HStack {
                    TextField("新文件夹名称", text: $newFolderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("添加文件夹") {
                        guard !newFolderName.isEmpty else { return }
                        taskStore.tasks.append(Task(name: newFolderName, children: []))
                        newFolderName = ""
                    }
                    .padding(.trailing)
                }
                .padding(.top)

                // 文件夹和任务列表
                List {
                    ForEach($taskStore.tasks) { $folder in
                        Section(header:
                            HStack {
                                Text(folder.name).font(.headline)
                                Spacer()
                                Button(action: {
                                    showingNewTaskAlert = folder.id
                                }) {
                                    Image(systemName: "plus.circle")
                                }
                            }) {
                                if let children = folder.children {
                                    ForEach(children) { task in
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(task.name)
                                                Spacer()
                                                Picker("", selection: .constant(task.isUsingPomodoro)) {
                                                    Text("番茄钟").tag(true)
                                                    Text("正向计时").tag(false)
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .frame(width: 140)
                                                .disabled(true)
                                            }
                                            // 显示任务的时间段信息（如果存在）
                                            if let start = task.startHour, let end = task.endHour {
                                                Text("时间段：\(start):00 - \(end):00")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("任务管理")
            // 添加任务弹窗
            .alert("新任务名称", isPresented: Binding<Bool>(
                get: { showingNewTaskAlert != nil },
                set: { if !$0 { showingNewTaskAlert = nil } }
            )) {
                TextField("任务名称", text: $newTaskName)
                Button("添加") {
                    if let folderIndex = taskStore.tasks.firstIndex(where: { $0.id == showingNewTaskAlert }) {
                        if taskStore.tasks[folderIndex].children == nil {
                            taskStore.tasks[folderIndex].children = []
                        }
                        taskStore.tasks[folderIndex].children!.append(Task(name: newTaskName))
                    }
                    newTaskName = ""
                    showingNewTaskAlert = nil
                }
                Button("取消", role: .cancel) {
                    showingNewTaskAlert = nil
                    newTaskName = ""
                }
            }
        }
        // 注入环境对象以在 CalendarView 中使用
        .environmentObject(taskStore)
    }
}

// 日历视图界面
struct CalendarView: View {
    @EnvironmentObject var taskStore: TaskStore
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedDay = Calendar.current.component(.day, from: Date())

    var body: some View {
        VStack(spacing: 20) {
            Text("日历")
                .font(.largeTitle)
                .bold()

            // 年月日选择器
            HStack(spacing: 20) {
                Picker("年", selection: $selectedYear) {
                    ForEach(2020...2030, id: \.self) { year in
                        Text("\(year)年")
                    }
                }
                .frame(width: 100)
                .clipped()

                Picker("月", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(month)月")
                    }
                }
                .frame(width: 80)
                .clipped()

                Picker("日", selection: $selectedDay) {
                    ForEach(1...31, id: \.self) { day in
                        Text("\(day)日")
                    }
                }
                .frame(width: 80)
                .clipped()
            }
            .padding(.horizontal)

            Divider()

            Text("选择的日期：\(selectedYear)-\(selectedMonth)-\(selectedDay)")

            Divider()

            Text("时间段展示")
                .font(.headline)

            ScrollView {
                ZStack(alignment: .top) {
                    // 背景时间线（每小时一格）
                    VStack(spacing: 0) {
                        ForEach(0..<24, id: \.self) { hour in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 40)

                                Text(String(format: "%02d:00", hour))
                                    .font(.caption)
                                    .padding(.leading, 8)
                            }
                        }
                    }

                    // 任务时间块绘制（可视化）
                    ForEach(taskStore.allFlatTasks, id: \.self) { task in
                        if let start = task.startHour, let end = task.endHour {
                            // 计算高度（每小时 40pt）
                            let height = CGFloat(end - start) * 40
                            // 计算纵向偏移位置
                            let yOffset = CGFloat(start) * 40

                            // 渲染任务蓝色块并叠加任务名
                            Rectangle()
                                .fill(Color.blue.opacity(0.6))
                                .cornerRadius(4)
                                .frame(height: height)
                                .overlay(
                                    Text(task.name)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(4),
                                    alignment: .topLeading
                                )
                                .offset(y: yOffset)
                                .padding(.horizontal, 8)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// 统计页面占位
struct StatisticsView: View {
    var body: some View {
        Text("这里是统计页面")
            .font(.title)
            .padding()
    }
}

// 预览
#Preview {
    ContentView()
        .environmentObject(TaskStore())
}
