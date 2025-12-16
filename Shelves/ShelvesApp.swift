import SwiftUI
import SwiftData

@main
struct ShelvesApp: App {
    @State private var appController = AppController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appController)
                .environment(appController.authManager)
                .environment(appController.libraryStore)
        }
        .modelContainer(for: Book.self)
    }
}
