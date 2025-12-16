import Foundation
import SwiftData

enum ReadingStatus: String, Codable, CaseIterable {
    case unread
    case reading
    case read
    case abandoned
}

@Model
final class Book {
    @Attribute(.unique) var id: String
    var title: String
    var authors: [String]
    var isbn: String?
    var coverImageUrl: String?
    var descriptionText: String?
    var locationId: String?
    var dateAdded: Date
    
    // Marketing & Retention
    var readingStatus: ReadingStatus = ReadingStatus.unread
    var currentPage: Int = 0
    var pageCount: Int = 0
    var rating: Int?
    
    // Loaning
    var isLoaned: Bool = false
    var loaneeName: String?
    var loanDate: Date?
    var dueDate: Date?

    init(
        id: String = UUID().uuidString,
        title: String,
        authors: [String] = [],
        isbn: String? = nil,
        coverImageUrl: String? = nil,
        descriptionText: String? = nil,
        locationId: String? = nil,
        dateAdded: Date = Date(),
        readingStatus: ReadingStatus = .unread,
        currentPage: Int = 0,
        pageCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.authors = authors
        self.isbn = isbn
        self.coverImageUrl = coverImageUrl
        self.descriptionText = descriptionText
        self.locationId = locationId
        self.dateAdded = dateAdded
        self.readingStatus = readingStatus
        self.currentPage = currentPage
        self.pageCount = pageCount
    }
}
