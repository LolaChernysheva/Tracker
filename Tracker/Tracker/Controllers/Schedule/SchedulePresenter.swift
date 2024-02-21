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
}

final class SchedulePresenter {
    
    weak var view: ScheduleViewProtocol?
    
    private var days: [WeekDay] = [.monday, .thusday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    init(view: ScheduleViewProtocol) {
        self.view = view
    }
    
    private func buildScreenModel() -> ScheduleScreenModel {
        ScheduleScreenModel(
            title: "Расписание",
            tableData: .init(sections: [
                .simple(cells: days.map({
                    .switchCell(.init(
                        text: $0.rawValue,
                        isOn: false, //TODO: -
                        onChange: {_ in}))  //TODO: -
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
}
