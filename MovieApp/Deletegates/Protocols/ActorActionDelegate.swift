//
//  ActorActionDeligate.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 13/02/2022.
//

import Foundation

protocol ActorActionDelegate: AnyObject{
    func onTapFavorite(isFavorite: Bool)
    func onTapActor(_ id: Int)
}
