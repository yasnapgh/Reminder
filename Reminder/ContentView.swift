import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let number: Int
    let category: String // New property to represent category
}

enum ReminderCategory: String {
    case today = "Today"
    case scheduled = "Scheduled"
    case flagged = "Flagged"
    case assigned = "Assigned"
}

struct ContentView: View {
    let items: [Item] = [
        Item(symbol: "📅", title: "Today", number: 2, category: ReminderCategory.today.rawValue),
        Item(symbol: "🗓", title: "Scheduled", number: 3, category: ReminderCategory.scheduled.rawValue),
        Item(symbol: "🚩", title: "Flagged", number: 1, category: ReminderCategory.flagged.rawValue),
        Item(symbol: "📌", title: "Assigned", number: 0, category: ReminderCategory.assigned.rawValue)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        GridItemView(item: item)
                            .accessibilityLabel("\(item.title) \(item.number) items")
                    }
                    .accessibility(identifier: "item_\(item.id)")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Reminder")
            .navigationBarItems(trailing: NavigationLink(destination: MyReminderView()) {
                Text("My Reminder")
                    .foregroundColor(.blue)
                    .accessibilityLabel("My Reminder")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
