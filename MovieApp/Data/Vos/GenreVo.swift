//
//  GenreVo.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import Foundation

public class GenreVo{
    var id: Int = 0
    var name: String = "ACTION"
    var isSelected: Bool = false
    
    init(id: Int = 0, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}
