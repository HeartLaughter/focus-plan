//
//  CalenderView.swift
//  Focus Plan
//
//  Created by ZHIFAN YU on 19.04.25.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("日历")
                .font(.largeTitle)
                .bold()

            // 年月日选择器
            HStack(spacing: 20) {
                Picker("年", selection: $viewModel.selectedYear) {
                    ForEach(2020...2030, id: \.self) { year in
                        Text("\(year)年")
                    }
                }
                .frame(width: 100)
                .clipped()

                Picker("月", selection: $viewModel.selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(month)月")
                    }
                }
                .frame(width: 80)
                .clipped()

                Picker("日", selection: $viewModel.selectedDay) {
                    ForEach(1...31, id: \.self) { day in
                        Text("\(day)日")
                    }
                }
                .frame(width: 80)
                .clipped()
            }
            .padding(.horizontal)

            Divider()

            Text("选择的日期：\(viewModel.formattedSelectedDate)")

            Divider()

            Text("时间段展示")
                .font(.headline)

            TimelineView(tasks: viewModel.tasksForSelectedDate)
        }
        .padding()
    }
}