//
//  CalendarViewModel.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var selectedYear: Int
    @Published var selectedMonth: Int
    @Published var selectedDay: Int
    
    let taskViewModel: TaskViewModel
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
        
        // 默认为当前日期
        let calendar = Calendar.current
        let today = Date()
        self.selectedYear = calendar.component(.year, from: today)
        self.selectedMonth = calendar.component(.month, from: today)
        self.selectedDay = calendar.component(.day, from: today)
    }
    
    // 获取选定日期的任务
    var tasksForSelectedDate: [Task] {
        // 这里简化处理，实际应用中你需要检查任务的日期
        return taskViewModel.allFlatTasks
    }
    
    // 返回格式化的选定日期
    var formattedSelectedDate: String {
        return "\(selectedYear)-\(selectedMonth)-\(selectedDay)"
    }
}