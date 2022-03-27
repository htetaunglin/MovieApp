// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieTrailerResponse = try? newJSONDecoder().decode(MovieTrailerResponse.self, from: jsonData)

import Foundation

// MARK: - MovieTrailerResponse
struct TrailerResponse: Codable {
    let id: Int?
    let results: [Trailer]?
}

// MARK: - Result
struct Trailer: Codable {
    let iso639_1, iso3166_1, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
