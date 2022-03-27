//
//  MoreActorDelegate.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 23/03/2022.
//

import Foundation

protocol ActorDelegate: AnyObject {
    func onTapMoreActors()
    func onTapActor(_ id: Int)
}
