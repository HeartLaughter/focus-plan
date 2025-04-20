//
//  TaskViewModel.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//
import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var folders: [Task] = []
    @Published var newFolderName: String = ""
    @Published var newTaskName: String = ""
    @Published var selectedFolderID: UUID? = nil
    
    // 获取所有扁平化的任务（即 children 任务）
    var allFlatTasks: [Task] {
        folders.flatMap { $0.children ?? [] }.filter { $0.startHour != nil && $0.endHour != nil }
    }
    
    init() {
        // 初始化一些示例数据
        folders = [
            Task(name: "学习", children: [
                Task(name: "数学", startHour: 10, endHour: 12),
                Task(name: "英语", startHour: 14, endHour: 15)
            ]),
            Task(name: "工作", children: [
                Task(name: "项目 A", startHour: 16, endHour: 18)
            ])
        ]
    }
    
    // 添加文件夹
    func addFolder() {
        guard !newFolderName.isEmpty else { return }
        folders.append(Task(name: newFolderName, children: []))
        newFolderName = ""
    }
    
    // 添加任务到指定文件夹
    func addTask(to folderID: UUID) {
        guard !newTaskName.isEmpty,
              let folderIndex = folders.firstIndex(where: { $0.id == folderID }) else { return }
        
        if folders[folderIndex].children == nil {
            folders[folderIndex].children = []
        }
        
        folders[folderIndex].children!.append(Task(name: newTaskName))
        newTaskName = ""
        selectedFolderID = nil
    }
}
