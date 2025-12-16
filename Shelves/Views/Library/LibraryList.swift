import SwiftUI
import SwiftData
import VisionKit

struct LibraryList: View {
    @Query(sort: \Book.dateAdded, order: .reverse) private var books: [Book]
    @Environment(\.modelContext) private var modelContext
    @Environment(LibraryStore.self) private var libraryStore
    
    @State private var isShowingScanner = false
    @State private var scannedIsbn: String?
    
    // API
    private let api = GoogleBooksAPI()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        HStack {
                            if let url = book.coverImageUrl {
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 40, height: 60)
                                .cornerRadius(4)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 40, height: 60)
                                    .cornerRadius(4)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.authors.joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "barcode.viewfinder")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addItem) {
                        Label("Add Manually", systemImage: "plus")
                    }
                }
            }
            .overlay {
                if books.isEmpty {
                    ContentUnavailableView(
                        "No Books Yet",
                        systemImage: "books.vertical",
                        description: Text("Scan your first book to get started.")
                    )
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                if DataScannerViewController.isSupported {
                    VisionScannerView { code in
                        print("Scanned: \(code)")
                        isShowingScanner = false
                        fetchAndAddBook(isbn: code)
                    }
                } else {
                    Text("Scanner not supported on this device.")
                }
            }
        }
    }
    
    private func fetchAndAddBook(isbn: String) {
        Task {
            do {
                if let book = try await api.fetchBook(isbn: isbn) {
                    libraryStore.addBook(book)
                } else {
                    print("Book not found")
                }
            } catch {
                print("Error fetching book: \(error)")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Book(title: "Manual Book \(Date())", authors: ["Me"])
            libraryStore.addBook(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                libraryStore.deleteBook(books[index])
            }
        }
    }
}
