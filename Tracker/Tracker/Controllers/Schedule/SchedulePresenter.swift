//
//  SchedulePresenter.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 20.02.2024.
//  
//

import Foundation

enum WeekDay: String {
    case monday = "Понедельник"
    case thusday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятницa"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}

protocol SchedulePresenterProtocol: AnyObject {
    func setup()
    func saveSchedule()
}

final class SchedulePresenter {
    
    weak var view: ScheduleViewProtocol?
    
    var onSave: (Schedule) -> Void
    
    private var days: [WeekDay] = [.monday, .thusday, .wednesday, .thursday, .friday, .saturday, .sunday]
    private var selectedDays: [Weekday] = []
    
    init(view: ScheduleViewProtocol, onSave: @escaping (Schedule) -> Void) {
        self.view = view
        self.onSave = onSave
    }
    
    private func buildScreenModel() -> ScheduleScreenModel {
        ScheduleScreenModel(
            title: "Расписание",
            tableData: .init(sections: [
                .simple(cells: days.map({
                    let day = $0.toModelWeekday
                    return .switchCell(.init(
                        text: $0.rawValue,
                        isOn: false, //TODO: -
                        onChange: { [ weak self ] isOn in
                            guard let self else { return }
                            if isOn {
                                self.selectedDays.append(day)
                            } //MARK: - TODO - remove days when !isOn
                        }))
                })),
                .simple(cells: [.labledCell(.init(title: "Готово"))])
            ])
        )
    }
    
    private func render() {
        view?.displayData(model: buildScreenModel(), reloadData: true)
    }
}

extension SchedulePresenter: SchedulePresenterProtocol {
    func setup() {
        render()
    }
    
    func saveSchedule() {
        let schedule = Schedule(weekdays: selectedDays)
        onSave(schedule)
    }
}

extension WeekDay {
    var toModelWeekday: Weekday {
        switch self {
        case .monday: return .monday
        case .thusday: return .tuesday
        case .wednesday: return .wednesday
        case .thursday: return .thursday
        case .friday: return .friday
        case .saturday: return .saturday
        case .sunday: return .sunday
        }
    }
}
