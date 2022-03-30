//
//  ContentView.swift
//  MiniClock
//
//  Created by Wangyiwei on 2022/1/1.
//

import SwiftUI

//enum ClockType: Int {
//    case analog, digital
//}
let editHaptic = UIImpactFeedbackGenerator(style: .soft) //on long press
let configHaptic = UIImpactFeedbackGenerator(style: .light) //on color change
let sliderHaptic = UIImpactFeedbackGenerator() //on slider

struct ContentView: View {
    //@State var clockType: ClockType = .analog
    @State var clockType: Int = Settings.shared.userDefaultClockType
    @State var configMode: Bool = false
    let leftScreen = AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    let rightScreen = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    
    var body: some View {
        ZStack {
            switch clockType {
            case 0:
                AnalogClockView(configMode: $configMode)
                    .transition(leftScreen)
            case 1:
                DigitalClockView(configMode: $configMode)
                    .transition(rightScreen)
            default: fatalError()
            }
            VStack {
                if configMode {
                    ADSwitch()
                }
                Spacer()
                if !configMode && !Settings.shared.userLearntLongPress {
                    Text("Long press = CONFIG")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                        .padding(40)
                }
            }
        }
    }
    
    @ViewBuilder
    func ADSwitch() -> some View {
        HStack {
            Button {
                withAnimation() {clockType = 0}
            } label: {
                Text(localized("Analog")).foregroundColor(.primary)
            }
            .padding(.horizontal).padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill().foregroundColor(clockType == 0 ? .adaptiveGray(6) : .adaptiveGray(3))
            )
            Button {
                withAnimation() {clockType = 1}
            } label: {
                Text(localized("Digital")).foregroundColor(.primary)
            }
            .padding(.horizontal).padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill().foregroundColor(clockType == 1 ? .adaptiveGray(6) : .adaptiveGray(3))
            )
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill().foregroundColor(.gray)
                .shadow(color: Color(UIColor(white: 0, alpha: 0.3)), radius: 4, x: 0, y: 2)
        ).padding(20)
        .transition(.move(edge: .top))
    }
}
