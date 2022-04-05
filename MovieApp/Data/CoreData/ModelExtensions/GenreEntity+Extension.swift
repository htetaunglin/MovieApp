//
//  GenreEntityX.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation

extension GenreEntity {
    func toMovieGenre() -> MovieGenre {
       return MovieGenre(id: Int(self.id), name: self.name ?? "")
    }
}
