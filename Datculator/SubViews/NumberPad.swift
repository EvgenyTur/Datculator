//
//  NumberPad.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 03.04.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import SwiftUI

struct RoundedButton<ButtProtocol: View>: View {
    let action: () -> Void
    let content: ButtProtocol
    let buttonColor: Color
    init(action: @escaping () -> Void, @ViewBuilder content: () -> ButtProtocol, buttonColor: Color) {
        self.action = action
        self.content = content()
        self.buttonColor = buttonColor
    }
    var body: some View {
        Button(action: action) {
            content
                .padding(.vertical, 10)
                .frame(maxWidth: 90)
                .background(Capsule().fill(buttonColor))
                .foregroundColor(.white)
        }
    }
}

struct NumberPad: View {
    let buttonAction: (_ tag: Int) -> ()
    
    init(buttonAction: @escaping (_ tag: Int) -> ()) {
        self.buttonAction = buttonAction
    }
        
    var body: some View {
        VStack {
            HStack {
                RoundedButton(action: { self.buttonAction(7)}, content: {
                    Text("7")
                }, buttonColor: Color.init("buttonColor"))
                
                RoundedButton(action: { self.buttonAction(8) }, content: {
                    Text("8")
                }, buttonColor: Color.init("buttonColor"))
                
                RoundedButton(action: { self.buttonAction(9) }, content: {
                    Text("9")
                }, buttonColor: Color.init("buttonColor"))
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            
            HStack {
                RoundedButton(action: { self.buttonAction(4)}, content: {
                    Text("4")
                }, buttonColor: Color.init("buttonColor"))
                
                RoundedButton(action: { self.buttonAction(5) }, content: {
                    Text("5")
                }, buttonColor: Color.init("buttonColor"))
                
                RoundedButton(action: { self.buttonAction(6) }, content: {
                    Text("6")
                }, buttonColor: Color.init("buttonColor"))
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)

            HStack {
                RoundedButton(action: { self.buttonAction(1)}, content: {
                    Text("1")
                }, buttonColor: Color.init("buttonColor"))
                
                RoundedButton(action: { self.buttonAction(2) }, content: {
                    Text("2")
                }, buttonColor: Color.init("buttonColor"))
                
                RoundedButton(action: { self.buttonAction(3) }, content: {
                    Text("3")
                }, buttonColor: Color.init("buttonColor"))
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)

            HStack {
                RoundedButton(action: { self.buttonAction(0)}, content: {
                    Text("0")
                }, buttonColor: Color.init("buttonColor"))
                
                RoundedButton(action: { self.buttonAction(-20) }, content: {
                    Text("+/-")
                    }, buttonColor: Color.init("buttonColor"))

                RoundedButton(action: { self.buttonAction(-10) }, content: {
                    Text("AC")
                }, buttonColor: .red)

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
        .background(Color.init("backColor"))
    }
}

struct NumberPad_Previews: PreviewProvider {
    static var previews: some View {
        NumberPad(buttonAction: { _ in print(" _")})
    }
}
