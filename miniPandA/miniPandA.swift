//
//  miniPandA.swift
//  miniPandA
//
//  Created by das08 on 2020/10/02.
//

import WidgetKit
import SwiftUI

struct KadaiEntry: TimelineEntry {
    let date: Date
    let kadai: [Kadai]
}

struct Provider: TimelineProvider {
//    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
//    var kadaiList: Data = Data()
//    var kadaiList = getKadaiFromPandA()
    let kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList())
    
    
    func getSnapshot(in context: Context, completion: @escaping (KadaiEntry) -> Void) {
//        guard let kadai = try? JSONDecoder().decode(Kadai.self, from:kadaiList) else { return }
        let entry = KadaiEntry(date: Date(), kadai: kadaiList)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<KadaiEntry>) -> Void) {
//        guard let kadai = try? JSONDecoder().decode(Kadai.self, from:kadaiList) else { return }
        
        var entries = [KadaiEntry]()
        let currentDate = Date()
//        let nextLoadDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        // Create Timeline object for an hour
        for offset in 0 ..< 2 {
            let entryDate: Date = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
            var dispDateModified_kadaiList = [Kadai]()
//            let kadaiList2 = getKadaiFromPandA()
            let kadaiList2 = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList())
            for var entry in kadaiList2 {
                entry.dispDate = entryDate
                dispDateModified_kadaiList.append(entry)
            }
            entries.append(KadaiEntry(date: entryDate, kadai:dispDateModified_kadaiList))
        }

//        let timeline = Timeline(entries: entries, policy: .after(nextLoadDate))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> KadaiEntry {
        let placeholder = Kadai(id: "001", lectureName: "Lec1", assignmentInfo: "Quiz1", dueDate: Date(), isFinished: false)
        return KadaiEntry(date: Date(), kadai: [placeholder, placeholder])
    }
    
}


struct WidgetEntryView: View {
    let entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
//        case .systemMedium:
//            KadaiView(kadai: entry.kadai)
//
        default:
            KadaiViewLarge(kadaiList: entry.kadai)
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
        .supportedFamilies([.systemLarge])
    }
}
