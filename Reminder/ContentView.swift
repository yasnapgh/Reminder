//
//  ContentView.swift
//  Reminder
//
//  Created by Yasna Pourgholamhosseini on 22/11/23.
// ALIII

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let number: Int
}

struct ContentView: View {
    let items: [Item] = [
        Item(symbol: "📅", title: "Today", number: 2),
        Item(symbol: "🗓", title: "Scheduled", number: 3),
        Item(symbol: "🚩", title: "Flagged", number: 8),
        Item(symbol: "📌", title: "Assigned", number: 16)
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
                                    .accessibilityLabel("\(items[index].title) \(items[index].number) items")
                            }
                            .accessibility(identifier: "item_\(index)")
                        }
                    }
                }
            }
            .navigationTitle("Reminder")
            .navigationBarItems(trailing: NavigationLink(destination: MyReminderView()) {
                Text("My Reminder")
                    .foregroundColor(.blue)
                    .accessibilityLabel("My Reminder")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle()) // To fix accessibility issues with navigation links
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
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(10)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title) \(item.number)")
    }
}

struct DetailView: View {
    let item: Item

    var body: some View {
        GridItemView(item: item)
            .navigationTitle(item.title)
            .accessibilityLabel("\(item.title) \(item.number)")
    }
}

struct myReminderView: View {
    var body: some View {
        Text("My Reminder")
            .navigationTitle("My Reminder")
            .accessibilityLabel("My Reminder")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
