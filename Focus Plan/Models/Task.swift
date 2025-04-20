import Foundation

struct Task: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var children: [Task]? = nil
    var isUsingPomodoro: Bool = true
    var startHour: Int? = nil
    var endHour: Int? = nil
}
