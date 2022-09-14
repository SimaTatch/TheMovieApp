
import Foundation

struct MovieResults: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDetailsResults: Codable {
    let statusCode: Int
    let statusMessage: String
    let results: [MovieDetails]
    
    enum CodingKeys: String, CodingKey {
        case results
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
