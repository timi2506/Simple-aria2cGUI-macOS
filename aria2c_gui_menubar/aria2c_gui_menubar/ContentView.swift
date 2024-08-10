import SwiftUI
import AppKit

struct ContentView: View {
    @State private var url: String = ""
    @State private var isNextWindowPresented: Bool = false

    var body: some View {
        VStack {
            Text("Paste the URL to download with aria2")
                .font(.headline)
            
            TextField("URL", text: $url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                Button("Continue") {
                    if !url.isEmpty {
                        if let defaultPath = UserDefaults.standard.string(forKey: "defaultPath") {
                            // Use the default path and skip Window 2
                            executeAria2Download(url: url, path: defaultPath)
                        } else {
                            isNextWindowPresented = true
                        }
                    }
                }
                .disabled(url.isEmpty)
            }
            .padding()
        }
        .padding()
        .frame(width: 400, height: 150)
        .sheet(isPresented: $isNextWindowPresented) {
            PathSelectionView(url: url)
        }
    }

    func executeAria2Download(url: String, path: String) {
        let command = "/opt/homebrew/bin/aria2c \"\(url)\" --dir \"\(path)\""
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(command, forType: .string)
        if let shortcutsURL = URL(string: "shortcuts://run-shortcut?name=DO-NOT-CHANGE_aria2c_GUI_downloader") {
            NSWorkspace.shared.open(shortcutsURL)
        }
    }
}
