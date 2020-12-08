//
//  SettingsManager.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 11.04.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    // Режим показа дней
    // 0 - только дни
    // 1 - показывать ешё и недели
    // 2 - показывать дни и годы / месяцы
    @SettingsDefaults(key: "showDaysMode", defaultValue: 0)
    var showDaysMode: Int {
        willSet {
            objectWillChange.send()
        }
    }

    // Это указывет - последняя дата или первая
    @SettingsDefaults(key: "endEditMode", defaultValue: false)
    var endEditMode: Bool {
        willSet {
            objectWillChange.send()
        }
    }
 
    // LastMode = currentActive:
    // 1: "add_days" = "Узнать дату, добавив дни к сегодня";
    //    startDate - фикс & today, дни вводим, endDate - считаем (by default)       (= 3) (якорь 1)
    
    // 2: "up_to_date" = "Сколько пройдёт дней от сегодня до нижней даты";
    //    startDate - фикс & today, endDate - крутим, дни - считаем до отпуска       (= 2) (якорь 1)
    
    // 3: "from_date" = "Сколько прошло дней от верхней даты до сегодня";
    //    startDate - крутим (установлена), endDate = today, считаем дни прошедшие  (= 2) (якорь 3)
    
    // 4: "days_between" = "Сколько дней между датами";
    //    startDate - фикс, endDate - крутим, дни - считаем                         (= 2) (якорь 1)
    
    // 5: "add_day" = "Узнать дату, добавив дни к верхней дате";
    //    startDate - фикс, дни - вводим, считаем endDate                           (= 3) (якорь 1)

    @SettingsDefaults(key: "currentActive", defaultValue: 1)
    var currentActive: Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    @SettingsDefaults(key: "startDate", defaultValue: Date())
    var startDate: Date {
        willSet {
            objectWillChange.send()
        }
        didSet {
            print("start date changed")
            if currentActive == 3 {
                periodBetween = correctedDays(period: endDate.days(from: startDate))
            } else if currentActive != 2 {
                endDate = startDate.addToDate(days: correctedPeriod(period: periodBetween))
                currentActive = startDate.isToday ? 1 : 5
            }
        }
    }
    @SettingsDefaults(key: "endDate", defaultValue: Date())
    var endDate: Date {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if [2, 4].contains(currentActive) {
                periodBetween = correctedDays(period: endDate.days(from: startDate))
                currentActive = startDate.isToday ? 2 : 4
            }
        }
    }
    @SettingsDefaults(key: "periodBetween", defaultValue: 0)
    var periodBetween: Int {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if [1, 5].contains(currentActive)  {
                endDate = startDate.addToDate(days: correctedPeriod(period: periodBetween))
                currentActive = startDate.isToday ? 1 : 5
            }
        }
    }

    @SettingsDefaults(key: "correctionMode", defaultValue: 0)
    // 0: без коррекции
    // 1: считать первый день
    // 2: не считать последний день
    var correctionMode: Int {
        willSet {
            objectWillChange.send()
        }
        didSet {
            calculateDates()
        }
    }

    @SettingsDefaults(key: "signMode", defaultValue: 1)
    // 1: +  0: -
    var signMode: Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    // MARK: - Methods
    func sign() -> Int {
        return signMode == 1 ? 1 : -1
    }
    
    func correctedDays(period: Int) -> Int {
        var correctPeriod = period
        if correctionMode == 1 {
            // Считаю и первый день тоже
            correctPeriod = period.absolute() + 1
        } else if correctionMode == 2 {
            // Не считаю последний
            if period.absolute() <= 1 {
                correctPeriod = 0
            } else if period < 0 {
                correctPeriod = period + 1
            } else if period > 0 {
                correctPeriod = period - 1
            }
        }
        return correctPeriod
    }

    func correctedPeriod(period: Int) -> Int {
        var correctPeriod = period
        if correctionMode == 1 {
            // Считаю и первый день тоже
            if period == 0 {
                correctPeriod = 1
            } else if period < 0 {
                correctPeriod = period + 1
            } else {
                correctPeriod = period - 1
            }
        } else if correctionMode == 2 {
            // Не считаю последний
            if period.absolute() < 1 {
                correctPeriod = 0
            } else if period < 0 {
                correctPeriod = period - 1
            } else if period > 0 {
                correctPeriod = period + 1
            }
        }
        return correctPeriod
    }

    func calculateDates() {
        print("Calculate dates, current active: \(currentActive)")
        switch currentActive {
        case 1:
            startDate = Date()
            endDate = startDate.addToDate(days: correctedPeriod(period: periodBetween))
        case 2:
            startDate = Date()
            periodBetween = correctedDays(period: endDate.days(from: startDate))
        case 3:
            endDate = Date()
            periodBetween = correctedDays(period: endDate.days(from: startDate))
        case 4:
            periodBetween = correctedDays(period: endDate.days(from: startDate))
        case 5:
            endDate = startDate.addToDate(days: correctedPeriod(period: periodBetween))
        default:
            print("wrong LastActive")
        }
    }
    
    
    // Тут храним 1 2 или 3 = последнее активное поле
    //    @SettingsDefaults(key: "lastActiveField", defaultValue: 1)
    //    var lastActiveField: Int {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }
    //    @SettingsDefaults(key: "lastMode", defaultValue: 1)
    //    var lastActive: Int {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }

}
