import SwiftUI

struct ReminderItem: Identifiable , Codable, Equatable {
    let id = UUID()
    var text: String
    var date: Date
}

struct MyReminderView: View {
    @State var reminders: [ReminderItem] = []
    @State var showsheet = false
    @State var textitemtemp = ""

    var body: some View {
        NavigationView {
        
            Group {
                if reminders.isEmpty {
                    Text("No reminder")
                        .accessibilityLabel(Text("No reminders"))
                } else {
                    List {
                        ForEach(reminders) { reminder in
                            ReminderRowView(reminder: reminder, onDelete: {
                                deleteItem(reminder)
                            })
                            .accessibilityLabel(Text("\(reminder.text)"))
                            .accessibilityHint(Text("Double-tap to delete"))
                        }
                    }
                }
            }
           
            .navigationTitle("My Reminders")
            .toolbar {
               
                Button(action: {
                    showsheet.toggle()
                    textitemtemp = ""
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel(Text("Add a new reminder"))
                })
            
               
            }
            .onChange(of: reminders) { _ in
                save()
                load()
            }
            .onAppear() {
                load()
            }
            .refreshable {
                load()
            }
        }
        .sheet(isPresented: $showsheet) {
            NewReminderView(textitemtemp: $textitemtemp, showsheet: $showsheet, addReminder: addReminder)
        }
    }

    func deleteItem(_ reminder: ReminderItem) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders.remove(at: index)
            save()
        }
    }

    func addReminder() {
        let newReminder = ReminderItem(text: textitemtemp, date: Date())
        reminders.append(newReminder)
        showsheet.toggle()
        save()
    }

    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: "reminders")
        }
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: "reminders") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ReminderItem].self, from: data) {
                reminders = decoded
            }
        }
    }
}

struct ReminderRowView: View {
    var reminder: ReminderItem
    var onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.text)
                Text("\(formattedDate(reminder.date))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.gray)
            }
        }
        .contextMenu {
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct NewReminderView: View {
    @Binding var textitemtemp: String
    @Binding var showsheet: Bool
    var addReminder: () -> Void

    var body: some View {
        NavigationView {
            List {
                TextField("New Reminder", text: $textitemtemp)
            }
            .navigationTitle ("New Reminder")
            .toolbar {
                Button("Add") {
                    addReminder()
                }
            }
        }
    }
}

struct MyReminderView_Preview: PreviewProvider {
    static var previews: some View {
        MyReminderView()
    }
}
