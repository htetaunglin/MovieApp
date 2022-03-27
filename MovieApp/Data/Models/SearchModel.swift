//
//  SearchModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol SearchModel {
    func searchMovie(_ text: String, page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
}

class SearchModelImpl: BaseModel, SearchModel {
    static let shared = SearchModelImpl()
    private override init(){}
    
    func searchMovie(_ text: String, page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.searchMovie(text, page: page, completion: completion)
    }
}
