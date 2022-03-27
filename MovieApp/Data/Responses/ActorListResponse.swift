//
//  ActorListResponse.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 20/03/2022.
//

import Foundation

public struct ActorListResponse : Codable {
    let dates: Dates?
    let page: Int
    let results: [ActorInfoResponse]?
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

public struct ActorInfoResponse : Codable {
    let adult: Bool?
    let gendre: Int?
    let id: Int?
    let knownFor: [MovieResult]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, gendre, id, name, popularity
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
    
}
