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
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> KadaiEntry {
        let placeholder = Kadai(id: "001", lectureName: "Lec1", assignmentInfo: "Quiz1", dueDate: Date(), isFinished: false)
        return KadaiEntry(kadai: placeholder)
    }
    
}


struct WidgetEntryView: View {
    let entry: Provider.Entry
    
    var body: some View {
        KadaiView(kadai: entry.kadai)
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
        }
    }
}
