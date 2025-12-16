import Foundation

struct GoogleBookResponse: Codable {
    let items: [GoogleBookItem]?
}

struct GoogleBookItem: Codable {
    let volumeInfo: GoogleBookVolumeInfo
}

struct GoogleBookVolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: GoogleBookImageLinks?
}

struct GoogleBookImageLinks: Codable {
    let thumbnail: String?
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

actor GoogleBooksAPI {
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    
    func fetchBook(isbn: String) async throws -> Book? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: "isbn:\(isbn)")
        ]
        
        guard let url = components?.url else { throw NetworkError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let result = try? decoder.decode(GoogleBookResponse.self, from: data)
        
        guard let item = result?.items?.first else { return nil }
        
        let info = item.volumeInfo
        
        return Book(
            title: info.title,
            authors: info.authors ?? ["Unknown"],
            isbn: isbn,
            coverImageUrl: info.imageLinks?.thumbnail,
            descriptionText: info.description
        )
    }
}
