//
//  Routers.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 13/02/2022.
//

import Foundation
import UIKit

enum StoryBoardName: String {
    case Main = "Main"
    case LaunchScreen = "LaunchScreen"
}

extension UIStoryboard{
    static func mainStoryBoard() -> UIStoryboard{
        UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
    }
}

extension UIViewController{
    func navigateToFilmDetailViewController(movieId: Int, isTVSeries: Bool){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailViewController.identifier) as? MovieDetailViewController else {return}
        //Transition style
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.isTVSeries = isTVSeries
        vc.filmId = movieId
//        present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMoreActorsViewController(initData: ActorListResponse?){
        let vc = MoreActorsViewController()
        //Transition style
        vc.modalPresentationStyle = .fullScreen
        vc.initData = initData
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
    
    func navigateToMoreShowCaseViewController(initData: MovieListResponse?){
        let vc = MoreShowCaseViewController()
        //Transition style
        vc.modalPresentationStyle = .fullScreen
        vc.initData = initData
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
    
    func navigateToSearchViewController(){
        let vc = SearchViewController()
        //Transition style
        self.navigationController?.pushViewController(vc, animated: true)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
    }
    
    func navigateToActorDetail(actorId: Int){
        let vc = ActorDetailViewController()
        vc.id = actorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
