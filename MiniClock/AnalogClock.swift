//
//  ContentView.swift
//  MiniClock
//
//  Created by Wangyiwei on 2021/12/30.
//

import SwiftUI

struct AnalogClockView: View {
    //@Binding var clockType: ClockType
    @Binding var configMode: Bool
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmmss"
        return formatter
    }()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let colors: [Color] = [
        .red, .green, .blue, .gray, .primary, .purple, .orange, .yellow
    ]
    //@State var currentColor: Color = .red
    @State var currentColorIndex: Int = Settings.shared.analogColorIndex
    
    @State var secRound = 0
    @State var minRound = 0
    @State var hrRound = 0
    
    @State var secNum: Int = 0
    @State var minNum: Int = 0
    @State var hrNum: Int = 0
    @State var holded: Bool = false
    
    var secDeg: Int {secNum + 60 * secRound}
    var minDeg: Int {minNum + 60 * minRound}
    var hrDeg: Int {hrNum + 12 * hrRound}
    
    @State var response: Double = Settings.shared.analogSpringResonse < 0.01 ? 0.1 : Settings.shared.analogSpringResonse
    @State var damping: Double = Settings.shared.analogSpringDamping < 0.01 ? 0.4 : Settings.shared.analogSpringDamping
    var ani: Animation {
        Animation.interactiveSpring(
            response: response, dampingFraction: damping, blendDuration: 0.5
        )
    }
    
    var hwRatio: CGFloat {UIScreen.main.bounds.height / UIScreen.main.bounds.width}
    var clockConfigContainerWidth: CGFloat {min(min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) * 0.9, 420)}
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill().foregroundColor(.background)
//                .scaleEffect(CGSize(width: 0.9, height: 0.9 / hwRatio))
                .shadow(radius: configMode ? 20 : 0)
                .frame(
                    width: configMode ? clockConfigContainerWidth : UIScreen.main.bounds.width,
                    height: configMode ? clockConfigContainerWidth : UIScreen.main.bounds.height
                ).offset(y: configMode ? -50 : 0)
                .ignoresSafeArea()
                .onLongPressGesture(minimumDuration: 1.0, maximumDistance: 30) {pressedWaitingOneSecond in
//                    print(pressedWaitingOneSecond)
                } perform: {
                    editHaptic.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configMode.toggle()
                    }
                    Settings.shared.userLearntLongPress = true
                }

            Group {
                MinuteRing()
                HourNumbers()
                ClockHands()
            }
            .offset(y: configMode ? -60 : 0)
            .scaleEffect(configMode ? 0.8 : 1.0)
            .ignoresSafeArea()
            
            if configMode {
                DoneButton()
            }
            VStack {
                Spacer()
                if configMode {
                    VStack {
                        SpringSliders()
                        ColorConfig()
                    }.font(.system(size: 20, design: .monospaced))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill()
                            .foregroundColor(.background)
                            .shadow(color: Color(UIColor(white: 0, alpha: 0.3)), radius: 6, x: 0, y: 4)
                    )
                    .padding()
                .transition(.move(edge: .bottom))
                }
            }
        }
        .onReceive(timer) {_ in
            if holded {return}
            let timeNum = Int(dateFormatter.string(from: Date()))!
            let new_secNum = timeNum % 100
            if new_secNum < secNum {
                secRound += 1
            }
            secNum = new_secNum
            let new_minNum = (timeNum / 100) % 100
            if new_minNum < minNum {
                minRound += 1
            }
            minNum = new_minNum
            let new_hrNum = timeNum / 10000
            if new_hrNum < hrNum {
                hrRound += 1
            }
            hrNum = new_hrNum
        }
    }
    
    @ViewBuilder
    func MinuteRing() -> some View {
        ForEach(0...59, id: \.self) {index in
            Capsule().fill().foregroundColor(index == minNum ? colors[currentColorIndex] : (index % 5 == 0 ? .gray : .adaptiveGray(5)))
                .frame(width: 8, height: minNum == index ? 30 : 20).offset(y: -180)
                .rotationEffect(Angle(degrees: Double(index * 6)))
                .animation(.linear)
        }
    }
    
    @ViewBuilder
    func HourNumbers() -> some View {
        ForEach(1...12, id: \.self) {hr in
            Text("\(hr)").font(.system(size: 42, weight: .semibold, design: .monospaced))
                .foregroundColor(hr % 12 == hrNum % 12 ? .gray : .adaptiveGray(6))
                .rotationEffect(Angle(degrees: Double(hr % 12 * -30)))
                .offset(y: -130)
                .rotationEffect(Angle(degrees: Double(hr % 12 * 30)))
        }
    }
    
    @ViewBuilder
    func ClockHands() -> some View {
        Capsule(style: .continuous).fill()
            .foregroundColor(.adaptiveGray(3))
            .frame(width: 12, height: 80).offset(y: -40)
            .rotationEffect(Angle(degrees: Double(hrDeg * 30 + minDeg / 2)))
            .animation(ani)
            .shadow(color: Color(UIColor(white: 0, alpha: 0.4)), radius: 2, x: 0, y: 2)
//                    .simultaneousGesture(
//                        DragGesture()
//                            .onChanged {ges in
//                                let x = ges.location.x
//                                let y = -ges.location.y
//                                let deg = atan(Double(x) / Double(y)) * 180 / .pi
//                                print(x, y, deg)
//                                holded = true
//                            }
//                            .onEnded{ges in
//                                let timeNum = Int(dateFormatter.string(from: Date()))!
//                                secNum = timeNum % 100
//                                minNum = (timeNum / 100) % 100
//                                hrNum = timeNum / 10000
//                                holded = false
//                            }
//                    )
        Capsule(style: .continuous).fill()
            .foregroundColor(.adaptiveGray(2))
            .frame(width: 10, height: 120).offset(y: -60)
            .rotationEffect(Angle(degrees: Double(minDeg * 6/* + secDeg / 10*/)))
            .animation(ani)
            .shadow(color: Color(UIColor(white: 0, alpha: 0.4)), radius: 3, x: 0, y: 3)
        Capsule(style: .continuous).fill()
            .foregroundColor(colors[currentColorIndex])
            .frame(width: 6, height: 160).offset(y: -80)
            .rotationEffect(Angle(degrees: Double(secDeg * 6)))
            .animation(ani)
            .shadow(color: Color(UIColor(white: 0, alpha: 0.4)), radius: 4, x: 0, y: 4)
        Circle().fill().foregroundColor(.adaptiveGray(4))
            .frame(width: 16, height: 16)
            .shadow(color: Color(UIColor(white: 0, alpha: 0.2)), radius: 3, x: 0, y: 4)
    }
    
    @ViewBuilder
    func SpringSliders() -> some View {
        HStack {
            Text("Response .\(Int(response * 10))")
            Slider(
                value: $response,
                in: ClosedRange<Double>(uncheckedBounds: (lower: 0.1, upper: 0.9)),
                step: 0.1
            ) {holded in
                if holded {configHaptic.impactOccurred()}
                else {Settings.shared.analogSpringResonse = response}
            }.accentColor(.gray)
        }
        HStack {
            Text("Damping  .\(Int(damping * 10))")
            Slider(
                value: $damping,
                in: ClosedRange<Double>(uncheckedBounds: (lower: 0.1, upper: 0.9)),
                step: 0.1
            ) {holded in
                if holded {configHaptic.impactOccurred()}
                else {Settings.shared.analogSpringDamping = damping}
            }.accentColor(.gray)
        }
    }
    
    @ViewBuilder
    func ColorConfig() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<colors.count) {index in
                    Button {
                        configHaptic.impactOccurred()
                        withAnimation {
                            currentColorIndex = index
                        }
                        Settings.shared.analogColorIndex = index
                    } label: {
                        ZStack {
                            Circle().fill().foregroundColor(colors[index])
                                .frame(width: 36, height: 36)
                            if currentColorIndex == index {
                                Circle().fill().foregroundColor(.background)
                                    .frame(width: 16, height: 16)
                            }
                        }
                    }
                }
            }.frame(height: 40)
        }
    }
    
    @ViewBuilder
    func DoneButton() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    Settings.shared.userDefaultClockType = 0
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configMode = false
                    }
                } label: {
                    Text("Done")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            Spacer()
        }.transition(.opacity)
    }
}
