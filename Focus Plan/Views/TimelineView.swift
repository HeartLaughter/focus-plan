//
//  TimelineView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//

import SwiftUI

struct TimelineView: View {
    let tasks: [Task]
    
    var body: some View {
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
                ForEach(tasks, id: \.self) { task in
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
}
