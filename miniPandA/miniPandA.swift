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
                Kadai(id: "001", lectureName: "電気電子工学基礎実験", assignmentInfo: "第２週予習課題（19~21班）", dueDate: generateDate(y: 2020, mo: 10, d: 3, h: 9, min: 0), isFinished: false),
                Kadai(id: "002", lectureName: "電気電子数学1", assignmentInfo: "Assignment 1", dueDate: generateDate(y: 2020, mo: 10, d: 6, h: 9, min: 0), isFinished: false),
                Kadai(id: "003", lectureName: "電気電子計測", assignmentInfo: "第1回レポート", dueDate: generateDate(y: 2020, mo: 10, d: 10, h: 9, min: 0), isFinished: false),
                Kadai(id: "004", lectureName: "電気電子計測", assignmentInfo: "第1回レポート", dueDate: generateDate(y: 2020, mo: 10, d: 10, h: 9, min: 0), isFinished: false),
                Kadai(id: "005", lectureName: "電磁気学1", assignmentInfo: "確認問題１", dueDate: generateDate(y: 2020, mo: 10, d: 20, h: 9, min: 0), isFinished: false)
            ]
            KadaiViewLarge(kadaiList: kadais)
        }
        
    }
}

@main
struct miniPandAWidget: Widget {
    private let kind = "miniPandA"
    let mpColor = miniPandAColor()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) {entry in
            WidgetEntryView(entry: entry)
                .background(mpColor.background)
        }
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}
