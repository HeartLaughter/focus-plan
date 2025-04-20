//
//  TaskView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingNewTaskAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 顶部添加文件夹栏
                HStack {
                    TextField("新文件夹名称", text: $viewModel.newFolderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("添加文件夹") {
                        viewModel.addFolder()
                    }
                    .padding(.trailing)
                }
                .padding(.top)

                // 文件夹和任务列表
                List {
                    ForEach(viewModel.folders) { folder in
                        Section(header:
                            HStack {
                                Text(folder.name).font(.headline)
                                Spacer()
                                Button(action: {
                                    viewModel.selectedFolderID = folder.id
                                    showingNewTaskAlert = true
                                }) {
                                    Image(systemName: "plus.circle")
                                }
                            }) {
                                if let children = folder.children {
                                    ForEach(children) { task in
                                        TaskRowView(task: task)
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("任务管理")
            // 添加任务弹窗
            .alert("新任务名称", isPresented: $showingNewTaskAlert) {
                TextField("任务名称", text: $viewModel.newTaskName)
                Button("添加") {
                    if let folderID = viewModel.selectedFolderID {
                        viewModel.addTask(to: folderID)
                    }
                    showingNewTaskAlert = false
                }
                Button("取消", role: .cancel) {
                    showingNewTaskAlert = false
                    viewModel.newTaskName = ""
                }
            }
        }
    }
}