//
//  MovieItemDelegate.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 13/02/2022.
//

import Foundation

protocol MovieItemDelegate: AnyObject {
    func onTapMovie(id: Int)
    func onTapTVSeries(id: Int)
}
