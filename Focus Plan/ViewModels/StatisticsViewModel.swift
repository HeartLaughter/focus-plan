//
//  StatisticsViewModel.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//

import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    let taskViewModel: TaskViewModel
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
    }
    
    // 这里可以添加统计数据计算方法
}