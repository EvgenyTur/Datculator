//
//  SettingsView.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 11.04.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    //    var delegate: RefreshingDelegate
    //    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var settings = SettingsManager()
//    @Binding var sett: SettingsManager?
    @State private var showText = false
    
    let dayCorrections = ["0", "+1", "-1"]
    // Режим подсчёта
//    let corrections = [LocalizedStringKey("without_correction"),
//                       LocalizedStringKey("add_today"),
//                       LocalizedStringKey("remove_day")]
    let hints = [LocalizedStringKey("hint0"),
                 LocalizedStringKey("hint1"),
                 LocalizedStringKey("hint2")]
    // Режим отображения дней
    let showModes = [LocalizedStringKey("days_only"),
                     LocalizedStringKey("weeks"),
                     LocalizedStringKey("years")]
    
    var body: some View {
    
        VStack {
            // Полоска вверху
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 80, height: 4, alignment: .center)
                .foregroundColor(.gray)
                .padding(.top)
            
            GeometryReader { gr in
                ZStack {
                    // Заголовок
                    Text("title_text")
                        .font(.subheadline)
                    // Info button
                    HStack {
                        Spacer()
                        Image(systemName: "info.circle")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                            .padding()
                            .onTapGesture {
                                self.showText.toggle()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }.frame(height: 44)
            
            ScrollView {
                // Текст About
                if self.showText {
                    Text(self.aboutText())
                        .font(.callout)
                        .padding(.horizontal)
//                        .layoutPriority(0)
                }
                
                // Краткое описание
                VStack (alignment: .leading, spacing: 12) {
                    Text("description1")
                    Text("description2")
                    Text("description3")
                    Text("description4")
                }
                .padding(.horizontal)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 0)
                
                VStack {
                    Text("choose_method")
                        .font(.callout)
                        .bold()
                        .padding(.top, 30)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                
                ZStack (alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemFill).opacity(0.5))
                        .frame(maxWidth: .infinity)
                    .frame(height: 70)
                        .padding(.horizontal)
                    VStack {

                        Text(hints[settings.correctionMode])
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                        
//                        Picker("", selection: $settings.correctionMode) {
//                            ForEach(0..<dayCorrections.count) { index in
//                                Text(self.dayCorrections[index])
//                            }
//                        }
                        Picker("", selection: Binding(get: {
                            settings.correctionMode
                        }, set: { (newValue) in
                            settings.correctionMode = newValue
                            settings.calculateDates()
                        }), content: {
                            ForEach(0..<dayCorrections.count) { index in
                                Text(self.dayCorrections[index])
                            }

                        })
                        .pickerStyle(SegmentedPickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                    }

                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack {
                    Text("days_mode")
                        .font(.callout)
                        .bold()
                        .padding(.top, 30)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                Picker("", selection: $settings.showDaysMode) {
                    ForEach(0..<showModes.count) { index in
                        Text(self.showModes[index])
                    }
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Spacer()
            }
            .animation(.easeOut(duration: 0.4))
        }
        
    }
    
    private func aboutText() -> String {
        let txtFilePath = Bundle.main.path(forResource: "About", ofType: "txt")
        var howToText = ""
        if let textHowTo = try? String(contentsOfFile: txtFilePath!, encoding: String.Encoding.utf8) {
            howToText = textHowTo
        } else {
            print("Error in getting how to")
        }
        return howToText
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
