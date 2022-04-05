//
//  SpokenLanguagesEntityX.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation

extension SpokenLanguageEntity {
    func toSpokenLanguage() -> SpokenLanguage {
        return SpokenLanguage(englishName: self.englishName, iso639_1: self.iso639_1, name: self.name)
    }
}
