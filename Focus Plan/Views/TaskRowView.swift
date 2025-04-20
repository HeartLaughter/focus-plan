//
//  TaskRowView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    
    var body: some View {
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