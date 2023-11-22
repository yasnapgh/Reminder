//
//  ContentView.swift
//  Reminder
//
//  Created by Yasna Pourgholamhosseini on 22/11/23.
// ALI

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let number: Int
}

struct ContentView: View {
    let items: [Item] = [
        Item(symbol: "📅", title: "Today", number: 10),
        Item(symbol: "", title: "Scheduled", number: 25),
        Item(symbol: "", title: "Flagged", number: 8),
        Item(symbol: "", title: "Assigned", number: 16),
        Item(symbol: "", title: "Completed", number: 20),
        Item(symbol: "🔒", title: "", number: 12)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(0..<items.count / 2, id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<2, id: \.self) { colIndex in
                            let index = rowIndex * 2 + colIndex
                            NavigationLink(destination: DetailView(item: items[index])) {
                                GridItemView(item: items[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Reminder")
            .navigationBarItems(trailing: NavigationLink(destination: MyReminderView()) {
                Text("My Reminder")
                    .foregroundColor(.blue)
            })
        }
    }
}

struct GridItemView: View {
    let item: Item

    var body: some View {
        VStack {
            Text(item.symbol)
                .font(.largeTitle)
                .padding()

            Text(item.title)
                .font(.headline)
                .padding(.bottom, 5)

            Text("\(item.number)")
                .font(.body)
                .foregroundColor(.black)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: 150, maxHeight: 150)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(10)
    }
}

struct DetailView: View {
    let item: Item

    var body: some View {
        GridItemView(item: item)
            .navigationTitle(item.title)
    }
}

struct contentView: View {
    var body: some View {
        Text("My Reminder")
            .navigationTitle("My Reminder")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
