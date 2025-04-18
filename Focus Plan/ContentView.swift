//
//  ContentView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 18.04.25.
//

import SwiftUI

struct ContentView: View {
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
    }
}

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var children: [Task]? = nil
    var isUsingPomodoro: Bool = true
}

struct TaskView: View {
    @State private var tasks: [Task] = [
        Task(name: "学习", children: [
            Task(name: "数学"),
            Task(name: "英语")
        ]),
        Task(name: "工作")
    ]
    @State private var newFolderName: String = ""
    @State private var showingNewTaskAlert: UUID? = nil
    @State private var newTaskName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("新文件夹名称", text: $newFolderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("添加文件夹") {
                        guard !newFolderName.isEmpty else { return }
                        tasks.append(Task(name: newFolderName, children: []))
                        newFolderName = ""
                    }
                    .padding(.trailing)
                }
                .padding(.top)

                List {
                    ForEach($tasks) { $folder in
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
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("任务管理")
            .alert("新任务名称", isPresented: Binding<Bool>(
                get: { showingNewTaskAlert != nil },
                set: { if !$0 { showingNewTaskAlert = nil } }
            )) {
                TextField("任务名称", text: $newTaskName)
                Button("添加") {
                    if let folderIndex = tasks.firstIndex(where: { $0.id == showingNewTaskAlert }) {
                        if tasks[folderIndex].children == nil {
                            tasks[folderIndex].children = []
                        }
                        tasks[folderIndex].children!.append(Task(name: newTaskName))
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
    }
}

struct CalendarView: View {
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedDay = Calendar.current.component(.day, from: Date())

    var body: some View {
        VStack(spacing: 20) {
            Text("日历")
                .font(.largeTitle)
                .bold()

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
                VStack(spacing: 8) {
                    ForEach(0..<24, id: \.self) { hour in
                        HStack {
                            Text(String(format: "%02d:00", hour))
                                .frame(width: 60, alignment: .leading)
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 30)
                                .overlay(
                                    Text("任务待填").font(.footnote).foregroundColor(.gray), alignment: .leading
                                )
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
    }
}

struct StatisticsView: View {
    var body: some View {
        Text("这里是统计页面")
            .font(.title)
            .padding()
    }
}

#Preview {
    ContentView()
}
