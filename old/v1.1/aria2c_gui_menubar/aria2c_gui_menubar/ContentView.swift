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
                    NSApplication.shared.terminate(nil) // Terminate the application
                }
                Button("Continue") {
                    if !url.isEmpty {
                        isNextWindowPresented = true
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
}
