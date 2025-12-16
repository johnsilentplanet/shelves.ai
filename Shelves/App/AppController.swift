import Foundation
import SwiftUI
import Observation

@Observable
final class AppController {
    var authManager: AuthManager
    var libraryStore: LibraryStore
    
    init() {
        self.authManager = AuthManager()
        self.libraryStore = LibraryStore()
    }
}
