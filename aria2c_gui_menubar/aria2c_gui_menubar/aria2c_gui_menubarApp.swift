import SwiftUI

@main
struct Aria2cGuiMenubarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            EmptyView() // Ensures no visible window
        }
        .commands {
            CommandGroup(replacing: .appTermination) {
                Button("Quit") {
                    NSApp.terminate(nil)
                }
            }
        }
    }
}
