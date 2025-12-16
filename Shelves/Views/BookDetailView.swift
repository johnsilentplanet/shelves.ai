import SwiftUI
import SwiftData

struct BookDetailView: View {
    @Bindable var book: Book
    @Environment(LibraryStore.self) private var libraryStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                HStack(alignment: .top) {
                    if let url = book.coverImageUrl {
                        AsyncImage(url: URL(string: url)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 100, height: 150)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Title", text: $book.title)
                            .font(.headline)
                        
                        Text(book.authors.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        let date = book.dateAdded
                        Text("Added \(date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        
                    }
                    .padding(.leading)
                }
                .padding(.vertical)
            }
            
            Section("Status") {
                Picker("Reading Status", selection: $book.readingStatus) {
                    ForEach(ReadingStatus.allCases, id: \.self) { status in
                        Text(status.rawValue.capitalized).tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Progress") {
                HStack {
                    Text("Rating")
                    Spacer()
                    RatingView(rating: $book.rating)
                }
                
                VStack(alignment: .leading) {
                    Text("Pages")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        TextField("Current", value: $book.currentPage, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("/")
                        TextField("Total", value: $book.pageCount, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            
            if let desc = book.descriptionText {
                Section("Description") {
                    Text(desc)
                        .font(.body)
                }
            }
            
            Section {
                Button("Delete Book", role: .destructive) {
                    libraryStore.deleteBook(book)
                    dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RatingView: View {
    @Binding var rating: Int?
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                    .foregroundStyle(.yellow)
                    .onTapGesture {
                        if rating == star {
                            rating = nil
                        } else {
                            rating = star
                        }
                    }
            }
        }
    }
}
