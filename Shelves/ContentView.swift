import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(LibraryStore.self) var libraryStore
    @Environment(\.modelContext) var modelContext

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                LibraryList()
            } else {
                LoginScreen()
            }
        }
        .animation(.default, value: authManager.isAuthenticated)
        .onAppear {
            libraryStore.setModelContext(modelContext)
        }
    }
}
