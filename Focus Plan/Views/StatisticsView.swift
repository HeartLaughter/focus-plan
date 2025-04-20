//
//  StatisticsView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel
    
    var body: some View {
        VStack {
            Text("这里是统计页面")
                .font(.title)
                .padding()
            
            // 这里可以添加基于 viewModel 的统计内容
            Text("总任务数: \(viewModel.taskViewModel.allFlatTasks.count)")
                .padding()
        }
    }
}
