//
//  MyReminderView.swift
//  Reminder
//
//  Created by Yasna Pourgholamhosseini on 22/11/23.
//

import SwiftUI

struct MyReminderView: View {
    @State var text: Array<String> = []
    @State var showsheet = false
    @State var textitemtemp = ""

    var body: some View {
        NavigationView {
            Group {
                if text.isEmpty {
                    Text("No reminder")
                        .accessibilityLabel(Text("No reminders"))
                } else {
                    List {
                        ForEach(text.indices, id: \.self) { i in
                            ReminderRowView(text: $text[i], onDelete: {
                                deleteItem(at: i)
                            })
                            .accessibilityLabel(Text("\(text[i])"))
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
                    Image(systemName: "plus")
                        .accessibilityLabel(Text("Add a new reminder"))
                })
            }
            .onChange(of: text) { _ in
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

    func deleteItem(at index: Int) {
        if text.indices.contains(index) {
            text.remove(at: index)
            save()
        }
    }

    func addReminder() {
        text.append(textitemtemp)
        showsheet.toggle()
        save()
    }

    func save() {
        let temp = text.joined(separator: "/[split]/")
        UserDefaults.standard.setValue(temp, forKey: "text")
    }

    func load() {
        let temp = UserDefaults.standard.string(forKey: "text") ?? ""
        let temparray = temp.components(separatedBy: "/[split]/")
        text = temparray
    }
}




struct ReminderRowView: View {
    @Binding var text: String
    var onDelete: () -> Void

    var body: some View {
        HStack {
            Text(text)
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
            .navigationTitle("New Reminder")
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

