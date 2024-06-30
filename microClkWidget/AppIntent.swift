//
//  AppIntent.swift
//  microClkWidget
//
//  Created by leo on 2024-06-29.
//

import WidgetKit
import AppIntents

enum DisplayStyle: String, Codable, Sendable {
    case auto, light, dark, lcd, led
}

extension DisplayStyle: AppEnum {
    static var caseDisplayRepresentations: [DisplayStyle : DisplayRepresentation] { [
        .auto: "Modern automatic",
        .light: "Modern light",
        .dark: "Modern dark",
        .lcd: "Retro LCD",
        .led: "Retro LED"
    ]}
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(
            name: "Display style",
            numericFormat: "\(placeholder: .int) styles"
        )
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Display Style") var style: DisplayStyle
    
    init(style: DisplayStyle) {
        self.style = style
    }
    
    init() {
        self.style = .auto
    }
}
