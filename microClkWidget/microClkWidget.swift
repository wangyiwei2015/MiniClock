//
//  microClkWidget.swift
//  microClkWidget
//
//  Created by leo on 2024-06-29.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for secOffset in 0 ..< 3600 * 6 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct microClkWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetFamily) var widgetFamily
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    var timeStr: (String, String) {
        let raw = dateFormatter.string(from:entry.date)
        let elements = raw.split(separator: ":")
        return (String(elements[0]), String(elements[1]))
    }
    
    var seperater: String {
        switch widgetFamily {
        case .systemSmall, .systemLarge:
            return "\n"
        case .systemMedium, .systemExtraLarge, .accessoryRectangular:
            return ":"
        default:
            return "|"
        }
    }
    
    var bgColor: Color {
        if widgetFamily == .accessoryRectangular { return .black }
        switch entry.configuration.style {
        case .auto: return Color(UIColor.systemBackground)
        case .light: return Color.white
        case .dark: return Color.black
        case .lcd: return Color("LCD_green")
        case .led: return Color.black
        }
    }
    
    var foreColor: Color {
        if widgetFamily == .accessoryRectangular { return .white }
        switch entry.configuration.style {
        case .auto: return Color.primary
        case .light: return Color.black
        case .dark: return Color.white
        case .lcd: return Color("LCD_darkgreen")
        case .led: return Color.green
        }
    }
    
    var fontSize: CGFloat {
        switch widgetFamily {
        case .systemSmall: return 50
        case .systemMedium: return 64
        case .systemLarge: return 100
        case .systemExtraLarge: return 130
        case .accessoryRectangular: return 30
        default: fatalError("Unknown widget family")
        }
    }

    var body: some View {
        let (hh, mm) = timeStr
        return ZStack {
            bgColor
            Text("\(hh)\(seperater)\(mm)")
                .font(.custom("E1234", size: fontSize))
                .foregroundColor(foreColor)
                .shadow(color: Color(UIColor(white: 0, alpha: 0.4)), radius: 2, x: 0, y: 3)
        }
    }
}

struct microClkWidget: Widget {
    let kind: String = "microClkWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            microClkWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("display name")
        .contentMarginsDisabled()
        .supportedFamilies([.accessoryRectangular, .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        //.disfavoredLocations([.], for: [])
    }
}

extension ConfigurationAppIntent { // for Preview
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.style = .auto
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.style = .lcd
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    microClkWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
