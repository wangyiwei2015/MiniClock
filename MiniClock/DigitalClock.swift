//
//  DigitalClock.swift
//  MiniClock
//
//  Created by Wangyiwei on 2022/1/1.
//

import SwiftUI

struct DigitalClockView: View {
    //@Binding var clockType: ClockType
    @Binding var configMode: Bool
    
    @State var timeString: String = "--:--:--"
    @State var currentFont: Int = 0//Settings.shared.digitalFontIndex
    @State var colorIndex: Int = Settings.shared.digitalColorIndex
    @State var displaySize: CGFloat = Settings.shared.digitalSize < 0.5 ? 1.0 : Settings.shared.digitalSize
    @State var isSettingSize: Bool = false
    
    let fonts: [String] = [
        // maybe more fonts?
        "Datdot",
        "E1234",
        "Electronic Highway Sign",
        "DatCub",
        "DSEG7 Classic",
        "DSEG14 Classic",
    ]
    let fontSizeScales: [CGFloat] = [
//        1.0, 1.0, 0.6,
        0.8, 0.55, 0.7, 0.8, 0.6, 0.6,
    ]
    let foreColors: [Color] = [
        .primary,
        .green,
        .white,
        .adaptiveGray(4),
        Color("LCD_darkgreen"),
        .black
    ]
    let backColors: [Color] = [
        .background,
        .black,
        Color("LCD_blue"),
        Color("LCD_purpleblue"),
        Color("LCD_green"),
        Color("LCD_greengray")
    ]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Rectangle().fill()
                .foregroundColor(backColors[colorIndex])
                .ignoresSafeArea()
                .onLongPressGesture(minimumDuration: 1.0, maximumDistance: 30) {pressedWaitingOneSecond in
//                    print(pressedWaitingOneSecond)
                } perform: {
                    editHaptic.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configMode.toggle()
                    }
                }
            Text(timeString).font(.custom(fonts[currentFont], fixedSize: 100 * fontSizeScales[currentFont]))
                .foregroundColor(foreColors[colorIndex])
                .shadow(color: Color(UIColor(white: 0, alpha: 0.4)), radius: 4, x: 0, y: 4)
                .scaleEffect(configMode && !isSettingSize ? 0.8 : displaySize)
            
            //Done button
            if configMode {
                DoneButton()
            }
            
            //config views
            VStack {
                Spacer()
                if configMode {
                    VStack {
                        FontConfig()
                        ColorConfig()
                        SizeConfig()
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
            timeString = dateFormatter.string(from: Date())
        }
    }
    
    @ViewBuilder
    func DoneButton() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    Settings.shared.userDefaultClockType = 1
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configMode = false
                    }
                } label: {
                    Text("Done")
                        .font(.system(size: 28))
                        .foregroundColor(foreColors[colorIndex])
                        .padding()
                }
            }
            Spacer()
        }.transition(.opacity)
    }
    
    @ViewBuilder
    func FontConfig() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<fonts.count, id: \.self) {index in
                    Button {
                        configHaptic.impactOccurred()
                        withAnimation {
                            currentFont = index
                        }
                        Settings.shared.digitalFontIndex = index
                    } label: {
                        ZStack {
                            Circle().fill().foregroundColor(currentFont == index ? .primary : .clear)
                                .frame(width: 38, height: 38)
                            Circle().fill().foregroundColor(backColors[colorIndex])
                                .frame(width: 32, height: 32)
                            Text("8").font(.custom(fonts[index], fixedSize: 25 * fontSizeScales[index]))
                                .foregroundColor(foreColors[colorIndex])
                        }
                    }
                }
            }.frame(height: 40)
        }
    }
    
    @ViewBuilder
    func ColorConfig() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<backColors.count, id: \.self) {index in
                    Button {
                        configHaptic.impactOccurred()
                        withAnimation {
                            colorIndex = index
                        }
                        Settings.shared.digitalColorIndex = index
                    } label: {
                        ZStack {
                            Circle().fill().foregroundColor(colorIndex == index ? .primary : .clear)
                                .frame(width: 38, height: 38)
                            Circle().fill().foregroundColor(backColors[index])
                                .frame(width: 32, height: 32)
                            Circle().fill().foregroundColor(foreColors[index])
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }.frame(height: 40)
        }
    }
    
    @ViewBuilder
    func SizeConfig() -> some View {
        HStack {
            Text("\(localized("Size")) \(String(format:"%.1f", displaySize))")
            Slider(
                value: $displaySize,
                in: ClosedRange<CGFloat>(uncheckedBounds: (lower: 0.5, upper: 3.0)),
                step: 0.1
            ) {holded in
                if holded {
                    configHaptic.impactOccurred()
                    withAnimation {isSettingSize = true}
                } else {
                    Settings.shared.digitalSize = displaySize
                    withAnimation {isSettingSize = false}
                }
            }.accentColor(.gray)
        }
    }
}

#Preview {
    DigitalClockView(configMode: .constant(true))
}
