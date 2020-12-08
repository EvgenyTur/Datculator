//
//  ContentView.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 14.03.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import SwiftUI
import AudioToolbox

public enum EditModes: Int {
    case startDateEdit = 1, daysEdit, endDateEdit
}

struct ContentView: View {
    let cellHeight: CGFloat = 65
    let cellWidth: CGFloat = 300
    
    @ObservedObject var settings = SettingsManager()
    
    // Other views
    @State private var settingsIsShowing = false
    @State private var moreIsShowing = false
    @State private var numberPadOnScreen = false

    // Для keypad-a
    @State private var keyTapped = ""
    
    @State private var resultNumber = 0

    @State private var lastNumber: Int = 0
    @State private var countDigit: Int = 0
    @State private var stackIsOver = false

    // LastMode = currentActive:
    // 1: "add_days" = "Узнать дату, добавив дни к сегодня";
    //    startDate - фикс, today, дни вводим, endDate - считаем (by default)       (= 3) (якорь 1)
    
    // 2: "up_to_date" = "Сколько пройдёт дней от сегодня до нижней даты";
    //    startDate - фикс, today, endDate - крутим, дни - считаем до отпуска       (= 2) (якорь 1)
    
    // 3: "from_date" = "Сколько прошло дней от верхней даты до сегодня";
    //    startDate - крутим (установлена), endDate = today, считаем дни прошедшие  (= 2) (якорь 3)
    
    // 4: "days_between" = "Сколько дней между датами";
    //    startDate - фикс, endDate - крутим, дни - считаем                         (= 2) (якорь 1)
    
    // 5: "add_day" = "Узнать дату, добавив дни к верхней дате";
    //    startDate - фикс, дни - вводим, считаем endDate                           (= 3) (якорь 1)

    @State private var activeField: EditModes = .startDateEdit
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Подсказка сверху
                HStack (alignment: .center) {
//                    Text("\(self.settings.currentActive)")
                    
                    Group {
                        if [1,2].contains(settings.currentActive) {
                            Text("today")
                        } else {
                            Text(self.settings.startDate.toString)
                        }
                    }
                    .layoutPriority(1)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Capsule().stroke(Color("arrowColor"), lineWidth: 1))
                    
                    firstSign()
                    Text("\(self.settings.periodBetween)")
                        .padding(5)
                        .padding(.horizontal, 10)
                        .background(Capsule().stroke([2,3,4].contains(settings.currentActive) ? Color("sumColor") : Color("arrowColor"), lineWidth: 1))
                    
                    secondSign()
                    Group {
                        if [3].contains(settings.currentActive) {
                            Text("today")
                        } else {
                            Text(self.settings.endDate.toString)
                        }
                    }
                    .padding(5)
                    .padding(.horizontal, 10)
                    .background(Capsule().stroke([1,5].contains(settings.currentActive) ? Color("sumColor") : Color("arrowColor"), lineWidth: 1))
                    
                }.font(.footnote)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
//                Divider()
                
                Spacer()
                
                // MARK: - Верхняя дата
                ZStack {
                    // светлое поле
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor([0].contains(settings.currentActive) ? Color(.systemBackground) : .clear)
                    
                    // Красная рамка
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("arrowColor"), lineWidth: 2)
                        .frame(width: cellWidth, height: cellHeight, alignment: .center)
                        .overlay(
                            Text(self.settings.startDate.toShortString)
                                .font(.system(size: 22))
                                .fontWeight(self.activeField == .startDateEdit ? .medium : .regular)
                                .foregroundColor(self.activeField == .startDateEdit ? Color("arrowColor") : Color("contrastLabelColor"))
                                .padding(4)
                    )
                        
                        .onTapGesture {
                            AudioServicesPlaySystemSound(SystemSoundID(1104))
                            self.activeField = .startDateEdit
//                            self.settings.lastActiveField = 1
                            self.settings.endEditMode = false
                            // Если режим 3: то ничего не меняю
                            if self.settings.currentActive != 3 {
                                self.settings.currentActive = self.settings.startDate.isToday ? 1 : 5
                            }
                    }
                    // Флажок Сегодня
                    ZStack (alignment: .topLeading) {
                        Text("today")
                            .font(.caption)
                            .foregroundColor(Color("arrowColor"))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .opacity(settings.startDate.isToday ? 1 : 0)
                        .padding(4)
                        
                    }.frame(width: cellWidth, height: cellHeight, alignment: .topLeading)
                    
                    ZStack {
//                        TriangleFrame(conturColor: Color("arrowColor"))
//                            .rotationEffect(.init(degrees: 180), anchor: .center)
//                            .offset(y: self.settings.correctionMode == 1 ? -10 : 10)
                        VStack {
                            Button(action: {
                                settings.correctionMode = 0
                            }, label: {
                                TriangleFrame(active: [0].contains(settings.correctionMode), conturColor: Color("arrowColor"))
                                    .rotationEffect(.init(degrees: 180), anchor: .center)
                            })
                            .offset(y: -9)
                            
                            Spacer()
                            
                            Button(action: {
                                settings.correctionMode = 1
                            }, label: {
                                TriangleFrame(active: [1].contains(settings.correctionMode), conturColor: Color("arrowColor"))
                                    .rotationEffect(.init(degrees: 180), anchor: .center)
                            })
                            .offset(y: 9)
                        }
                    }.frame(width: cellWidth, height: cellHeight)
//                    , alignment: self.settings.correctionMode == 1 ? .top : .bottom)
                    
                    FixedTriangles(width: cellWidth, height: cellHeight)
                        .opacity([1, 2, 4, 5].contains(settings.currentActive) ? 1.0 : 0)
                    
                    
                    
                }.frame(width: cellWidth, height: cellHeight, alignment: .center)
                
                Spacer()
                // MARK: - Цифра Период
                ZStack {
                    // Светлое поле
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(.systemBackground))
                        .onTapGesture {
                            AudioServicesPlaySystemSound(SystemSoundID(1104))
                            self.activeField = .daysEdit
//                            self.settings.lastActiveField = 2
                            self.settings.endEditMode = false
                            self.settings.currentActive = self.settings.startDate.isToday ? 1 : 5
                            self.resetAll()
                    }

                    // Красная рамка
                    RoundedRectangle(cornerRadius: 10)
                        .stroke([2,3,4].contains(settings.currentActive) ? Color("sumColor") : Color("arrowColor"), lineWidth: 2)
                        .frame(width: cellWidth, height: cellHeight, alignment: .center)
                        .overlay(
                            VStack (alignment: .center) {
                                
                                HStack (alignment: .firstTextBaseline) {
                                    Text("\(self.settings.periodBetween)")
                                        .font(.system(size: 24))
                                        .fontWeight(self.activeField == .daysEdit ? .semibold : .regular)
                                    Text(daysCorrected(days: self.settings.periodBetween))
                                        .font(.footnote)
                                }
                                .foregroundColor(self.activeField == .daysEdit ? Color("arrowColor") : Color("contrastLabelColor"))
//                                .padding()
                            }.offset(x: 0)

                    )

                    HStack {
                        // Дни в недели
                        if self.settings.showDaysMode == 1 {
                            daysToWeeksText()
                        }
                        // Дни в годы
                        if self.settings.showDaysMode == 2 {
                            yearMonthsText()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Color("contrastLabelColor"))
                    .offset(x: 0, y: 20)


                    FixedTriangles(width: cellWidth, height: cellHeight)
                        .opacity([0].contains(settings.currentActive) ? 1.0 : 0)

                    
                }.frame(width: cellWidth, height: cellHeight, alignment: .center)
                
                Spacer()
                
                // MARK: - Нижняя дата
                ZStack {
                    // Светлое поле
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(.systemBackground))
                    // красная рамка
                    RoundedRectangle(cornerRadius: 10)
                        .stroke([1,5].contains(settings.currentActive) ? Color("sumColor") : Color("arrowColor"), lineWidth: 2)
                        .frame(width: cellWidth, height: cellHeight, alignment: .center)
                        .overlay(
                            Text(self.settings.endDate.toShortString)
                                .font(.system(size: 22))
                                .fontWeight(self.activeField == .endDateEdit ? .medium : .regular)
                                .foregroundColor(self.activeField == .endDateEdit ? Color("arrowColor") : Color("contrastLabelColor"))

                                .padding(4)
                                )
                        
                        .onTapGesture {
                            AudioServicesPlaySystemSound(SystemSoundID(1104))
                            self.activeField = .endDateEdit
//                            self.settings.lastActiveField = 3
                            self.settings.endEditMode = true
                            self.settings.currentActive = self.settings.startDate.isToday ? 2 : 4
                    }

                    
                    // Флажок Сегодня
                    ZStack {
                        Text("today")
                            .font(.caption)
                            .foregroundColor(Color("arrowColor"))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
//                            .background(Color("arrowColor").opacity(0.8))
//                            .cornerRadius(.infinity)
                            .opacity(settings.endDate.isToday ? 1 : 0)
                            .padding(4)
                        
                    }.frame(width: cellWidth, height: cellHeight, alignment: .bottomLeading)
                    
                    ZStack {
//                        TriangleFrame(conturColor: [1,5].contains(settings.currentActive) ? Color("sumColor") : Color("arrowColor"))
//                            .offset(y: self.settings.correctionMode != 2 ? 10 : -10)
                        
                        VStack {
                            Button(action: {
                                settings.correctionMode = 0
                            }, label: {
                                TriangleFrame(active: [0].contains(settings.correctionMode), conturColor: Color("arrowColor"))
//                                    .rotationEffect(.init(degrees: 180), anchor: .center)
                            })
                            .offset(y: -9)
                            
                            Spacer()
                            
                            Button(action: {
                                settings.correctionMode = 1
                            }, label: {
                                TriangleFrame(active: [1].contains(settings.correctionMode), conturColor: Color("arrowColor"))
//                                .rotationEffect(.init(degrees: 180), anchor: .center)
                            })
                            .offset(y: 9)
                        }

                        
                        
                        
                    }.frame(width: cellWidth, height: cellHeight)
//                    .frame(width: cellWidth, height: cellHeight, alignment: self.settings.correctionMode != 2 ? .bottom : .top)
                    
                    FixedTriangles(width: cellWidth, height: cellHeight)
                        .opacity([3].contains(settings.currentActive) ? 1.0 : 0)
                    
                    
                }.frame(width: cellWidth, height: cellHeight, alignment: .center)

                                
                Spacer()
                
                // MARK: - Нижняя часть
                ZStack {
                    // Барабан
                    DatePicker("", selection: activeField == .startDateEdit ? $settings.startDate : $settings.endDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                    // Кнопка Сегодня
                    ZStack {
                        if activeField != .daysEdit {
                            // Today button action
                            VStack {
                                Button(action: {
                                    AudioServicesPlaySystemSound(SystemSoundID(1104))
                                    if self.settings.endEditMode {
                                        self.settings.endDate = Date()
                                        // Только тут ставится режим 3
                                        self.settings.currentActive = 3
                                        
                                    } else {
                                        self.settings.startDate = Date()
                                        self.settings.currentActive = 1
                                    }
                                }) {
                                    Group {
                                        HStack {
                                            Text("today")
                                            Text(Date().toString)
                                        }
                                        .font(.footnote)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    .background(Color("buttonColor"))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                }
                            }
                        }
                    }.frame(height: 216, alignment: .top)
                    
                    // Клавиатура
                    NumberPad(buttonAction: { tag in self.tapped(keyTag: tag) })
                        .offset(x: 0, y: activeField == .daysEdit ? 0 : 260)
//                        .animation(.default)
                    
                }.frame(height: 216, alignment: .bottom)
            }
            .background(Color("backColor"))
            .animation(.none)

            .onTapGesture {
                print("tap")
            }
            .navigationBarTitle("main_title", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.moreIsShowing.toggle()
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 22))
                            .foregroundColor(Color("contrastLabelColor"))
                    })
                    .frame(width: 40, height: 40)
//                    .background(Color.yellow)
                    .padding(.leading, -16.0)
                    .sheet(isPresented: $moreIsShowing) {
                        MoreView()
                    },
                
                trailing:
                    Button(action: {
                        self.settingsIsShowing.toggle()
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 22))
                            .foregroundColor(Color("contrastLabelColor"))
                        
                    })
                    .frame(width: 40, height: 40)
//                    .background(Color.yellow)
                    .padding(.trailing, -16)
                    .sheet(isPresented: $settingsIsShowing) {
                        SettingsView()
                    })
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            print("on appear: active = \(self.settings.currentActive)")
            switch self.settings.currentActive {
            case 1,5:
                self.activeField = .daysEdit
                self.settings.endEditMode = false
            case 2,4:
                self.activeField = .endDateEdit
                self.settings.endEditMode = true
            case 3:
                self.activeField = .startDateEdit
                self.settings.endEditMode = false
            default:
                print("Wrong current active while onAppear")
            }
            settings.calculateDates()
        }
    }

    // New app launching
    func updateToday() {
        self.settings.calculateDates()
    }
    
    // MARK: - Key processors
    func tapped(keyTag: Int) {
        AudioServicesPlaySystemSound(SystemSoundID(1104))
        
        switch keyTag {
        case (0...9):
            onPressedKey(keyNum: keyTag)
        case -20:
            toggleSign()
        case -10:
            resetAll()
        default:
            print("tapped \(keyTag)")
        }
        
    }
    
    func onPressedKey(keyNum: Int) {
        // last pressed key
        if !stackIsOver {
            lastNumber = keyNum;
            countDigit += 1
            if (countDigit <= 5) {
                if settings.signMode == 1 {
                    resultNumber = resultNumber * 10 + lastNumber
                } else {
                    resultNumber = resultNumber * 10 - lastNumber
                }
            }
            if (countDigit >= 5) {
                countDigit = 5
                stackIsOver = true
            }
        }
        settings.periodBetween = resultNumber
    }
    
    private func toggleSign() {
        resultNumber *= -1
        settings.signMode = 1 - settings.signMode
        settings.periodBetween = resultNumber
    }
    
    private func resetAll() {
        resultNumber = 0
        countDigit = 0
        settings.periodBetween = 0
        settings.signMode = 1
        stackIsOver = false
    }
    
    // Первый знак в подсказке
    private func firstSign() -> Image {
        var signImage = Image(systemName: "plus")
        switch settings.currentActive {
        case 1,5:
            break
        case 2,3,4:
            signImage = Image(systemName: "arrow.left")
        default:
            break
        }
        return signImage
    }
    // Второй знак в подсказке
    private func secondSign() -> Image {
        var signImage = Image(systemName: "equal")
        switch settings.currentActive {
        case 1,5:
            break
        case 2,3,4:
            signImage = Image(systemName: "arrow.right")
        default:
            break
        }
        return signImage
    }

    // Склоняет дни: день, дня, дней
    private func daysCorrected(days: Int) -> LocalizedStringKey {
        let lastDigit = (days - (days / 10) * 10).absolute()
        let lastTwoDigits = (days - (days / 100) * 100).absolute()
        let oneDay = LocalizedStringKey("1day")
        let twoDays = LocalizedStringKey("2days")
        let fiveDays = LocalizedStringKey("days")
        var correct = LocalizedStringKey("")
        if Locale.current.identifier == "ru_RU" {
            switch lastDigit {
            case 1:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? oneDay : fiveDays
            case 2, 3, 4:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? twoDays : fiveDays
            default:
                correct = fiveDays
            }
        } else {
            correct = days.absolute() > 1 ? fiveDays : oneDay
        }
        if days == 0 {
            correct = LocalizedStringKey("")
        }
        return correct
    }


    // Конвертирует дни в годы
    private func yearMonthsText() -> Text {
        var phraseText = Text(verbatim: "")
        let yearStart = settings.startDate.yearInt
        let yearEnd = settings.endDate.yearInt
        let monthStart = settings.startDate.monthInt
        let monthEnd = settings.endDate.monthInt
        let dayStart = settings.startDate.dayInt
        let dayEnd = settings.endDate.dayInt

        if settings.periodBetween > 28 {
            var years = yearEnd - yearStart
            var months = monthEnd - monthStart
            var days = dayEnd - dayStart

            if months < 0 || (months == 0 && days < 0) {
                years -= 1
                months = 12 + months
            }
            if days < 0 {
                months -= 1
                days = 30 + days
            }
            
            if years > 0 {
                phraseText = phraseText + Text("\(years)") + Text(" ") + Text(yearsCorrected(years: years)).foregroundColor(.gray) + Text("  ")
            }
            if months > 0 {
                phraseText = phraseText + Text("\(months)") + Text(" ") + Text(monthsCorrected(months: months)).foregroundColor(.gray) + Text("  ")

            }
            if years > 0 || months > 0 {
                if days > 0 {
                    phraseText = phraseText + Text("\(days)") + Text(" ") + Text(daysCorrected(days: days)).foregroundColor(.gray)
                }
            }
        }
        
        return phraseText
    }
    
    // Конвертирует дни в недели
    private func daysToWeeksText() -> Text {
        var phraseText = Text(verbatim: "")
        if settings.periodBetween > 6 {
//            if settings.periodBetween > 28 {
//                phraseText = phraseText + Text("/ ")
//            }
            
            let weeksTotal = settings.periodBetween / 7
            let additionalDays = settings.periodBetween - Int(weeksTotal) * 7
            
            phraseText = phraseText + Text("\(weeksTotal)") + Text(" ") + Text(weeksCorrected(weeks: weeksTotal)).foregroundColor(.gray)

            if additionalDays > 0 {
                phraseText = phraseText + Text(" ") + Text("\(additionalDays)") + Text(" ") + Text(daysCorrected(days: additionalDays)).foregroundColor(.gray)
            }
        }
        
        return phraseText
    }

    
    // Convertors
    // Склоняет годы: год, года, лет
    private func yearsCorrected(years: Int) -> LocalizedStringKey {
        let lastDigit = (years - (years / 10) * 10).absolute()
        let lastTwoDigits = (years - (years / 100) * 100).absolute()
        let oneDay = LocalizedStringKey("y1")
        let twoDays = LocalizedStringKey("y2")
        let fiveDays = LocalizedStringKey("ys")
        var correct = LocalizedStringKey("")
        if Locale.current.identifier == "ru_RU" {
            switch lastDigit {
            case 1:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? oneDay : fiveDays
            case 2, 3, 4:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? twoDays : fiveDays
            default:
                correct = fiveDays
            }
        } else {
            correct = years.absolute() > 1 ? fiveDays : oneDay
        }
        if years == 0 {
            correct = LocalizedStringKey("")
        }
        return correct
    }

    // Склоняет месяцы: месяц, месяца, месяцев
    private func monthsCorrected(months: Int) -> LocalizedStringKey {
        let lastDigit = (months - (months / 10) * 10).absolute()
        let lastTwoDigits = (months - (months / 100) * 100).absolute()
        let oneDay = LocalizedStringKey("m1")
        let twoDays = LocalizedStringKey("m2")
        let fiveDays = LocalizedStringKey("ms")
        var correct = LocalizedStringKey("")
        if Locale.current.identifier == "ru_RU" {
            switch lastDigit {
            case 1:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? oneDay : fiveDays
            case 2, 3, 4:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? twoDays : fiveDays
            default:
                correct = fiveDays
            }
        } else {
            correct = months.absolute() > 1 ? fiveDays : oneDay
        }
        if months == 0 {
            correct = LocalizedStringKey("")
        }
        return correct
    }

    // Склоняет недели: неделя, недели, недель
    private func weeksCorrected(weeks: Int) -> LocalizedStringKey {
        let lastDigit = (weeks - (weeks / 10) * 10).absolute()
        let lastTwoDigits = (weeks - (weeks / 100) * 100).absolute()
        let oneDay = LocalizedStringKey("w1")
        let twoDays = LocalizedStringKey("w2")
        let fiveDays = LocalizedStringKey("ws")
        var correct = LocalizedStringKey("")
        if Locale.current.identifier == "ru_RU" {
            switch lastDigit {
            case 1:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? oneDay : fiveDays
            case 2, 3, 4:
                correct = (lastTwoDigits < 10 || lastTwoDigits > 20) ? twoDays : fiveDays
            default:
                correct = fiveDays
            }
        } else {
            correct = weeks.absolute() > 1 ? fiveDays : oneDay
        }
        if weeks == 0 {
            correct = LocalizedStringKey("")
        }
        return correct
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Subviews
struct TriangleFrame: View {
    var active: Bool
    var conturColor: Color  //("arrowColor")
    var body: some View {
        ZStack {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(Color.gray)
                

            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(.systemBackground))
            Image(systemName: "triangle")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(active ? conturColor : .clear)
                .offset(y: -2)
        }
        .frame(width: 40, height: 40)
//        .background(Color.gray)

    }
}

struct FixedTriangles: View {
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        Group {
            ZStack {
                Image(systemName: "triangle.fill")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color("arrowColor"))
                    .rotationEffect(.init(degrees: 90), anchor: .center)
                    .padding(.leading, -1)
            }.frame(width: width, height: height, alignment: .leading)
            ZStack {
                Image(systemName: "triangle.fill")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color("arrowColor"))
                    .rotationEffect(.init(degrees: -90), anchor: .center)
                    .padding(.trailing, -1)
            }.frame(width: width, height: height, alignment: .trailing)
        }
    }
}

//struct TriangleFrame_Previews: PreviewProvider {
//    static var previews: some View {
//        TriangleFrame()
//    }
//}


//extension View {
//  func endTextEditing() {
//    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
//                                    to: nil, from: nil, for: nil)
//  }
//}
