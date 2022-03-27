//
//  Genre.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 19/03/2022.
//

import Foundation

var movieGenres = [MovieGenre]()

struct MovieGenreList : Codable{
    let genres : [MovieGenre]
}

struct MovieGenre : Codable {
    let id: Int
    let name : String
    
    func convertToGenreVo() -> GenreVo{
        let vo = GenreVo(id: id, name: name, isSelected: false)
        return vo
    }
}
