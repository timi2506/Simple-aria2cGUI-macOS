import SwiftUI
import Foundation
import AppKit

struct PathSelectionView: View {
    @Environment(\.presentationMode) var presentationMode // Add this line to control sheet dismissal
    @State private var path: String = ""
    @State private var isShowingFileChooser: Bool = false
    let url: String
    
    var body: some View {
        VStack {
            HStack {
                TextField("Choose Download-Location", text: $path)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Browse") {
                    isShowingFileChooser = true
                }
                .fileImporter(isPresented: $isShowingFileChooser, allowedContentTypes: [.folder]) { result in
                    switch result {
                    case .success(let selectedPath):
                        path = selectedPath.path
                    case .failure(let error):
                        print("Failed to select path: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
            
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss() // Dismiss the sheet to return to the previous window
                }
                
                Button("Done") {
                    copyCommandToClipboard(url: url, path: path)
                    openURLScheme()
                }
                .disabled(path.isEmpty)
            }
            .padding()
        }
        .padding()
        .frame(width: 400, height: 150)
    }
    
    func copyCommandToClipboard(url: String, path: String) {
        let command = "/opt/homebrew/bin/aria2c \"\(url)\" --dir \"\(path)\""
        
        // Copy command to clipboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(command, forType: .string)
        
        print("Command copied to clipboard: \(command)")
    }
    
    func openURLScheme() {
        let urlScheme = "shortcuts://run-shortcut?name=DO-NOT-CHANGE_aria2c_GUI_downloader"
        if let url = URL(string: urlScheme) {
            NSWorkspace.shared.open(url)
        }
    }
}
