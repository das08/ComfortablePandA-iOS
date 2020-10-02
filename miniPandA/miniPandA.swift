//
//  miniPandA.swift
//  miniPandA
//
//  Created by das08 on 2020/10/02.
//

import WidgetKit
import SwiftUI

struct KadaiEntry: TimelineEntry {
    let date = Date()
    let kadai: Kadai
}

struct Provider: TimelineProvider {
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    var kadaiList: Data = Data()
    
    func getSnapshot(in context: Context, completion: @escaping (KadaiEntry) -> Void) {
        guard let kadai = try? JSONDecoder().decode(Kadai.self, from:kadaiList) else { return }
        let entry = KadaiEntry(kadai: kadai)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<KadaiEntry>) -> Void) {
        guard let kadai = try? JSONDecoder().decode(Kadai.self, from:kadaiList) else { return }
        
        let entry = KadaiEntry(kadai: kadai)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> KadaiEntry {
        let placeholder = Kadai(id: "001", lectureName: "Lec1", assignmentInfo: "Quiz1", dueDate: Date(), isFinished: false)
        return KadaiEntry(kadai: placeholder)
    }
    
}


struct WidgetEntryView: View {
    let entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            KadaiView(kadai: entry.kadai)
        
        default:
            let kadais = [
                Kadai(id: "001", lectureName: "電気電子工学基礎実験", assignmentInfo: "Quiz1", dueDate: Date(), isFinished: false),
                Kadai(id: "002", lectureName: "Lec2", assignmentInfo: "Quiz2", dueDate: Date(), isFinished: false),
                Kadai(id: "003", lectureName: "Lec3", assignmentInfo: "Quiz3", dueDate: Date(), isFinished: false),
                Kadai(id: "004", lectureName: "Lec3", assignmentInfo: "Quiz3", dueDate: Date(), isFinished: false)
            ]
            KadaiViewLarge(kadaiList: kadais)
        }
        
    }
}

@main
struct miniPandAWidget: Widget {
    private let kind = "miniPandA"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) {entry in
            WidgetEntryView(entry: entry)
                .background(Color(red: 200/255 , green: 200/255, blue: 200/255))
        }
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}
