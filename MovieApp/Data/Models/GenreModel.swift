//
//  GenreModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol GenreModel {
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
}

class GenreModelImpl: BaseModel, GenreModel {
    static let shared = GenreModelImpl()
    private override init(){}
    
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void){
        networkAgent.getGenreList(completion: completion)
    }
}
