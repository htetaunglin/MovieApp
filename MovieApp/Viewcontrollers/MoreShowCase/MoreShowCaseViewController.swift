//
//  MoreShowCaseViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 23/03/2022.
//

import UIKit

class MoreShowCaseViewController: UIViewController {

    @IBOutlet weak var collectionViewMoreShowCase: UICollectionView!
    
    var initData: MovieListResponse? {
        didSet {
            if let results = initData?.results {
                data.append(contentsOf: results)
            }
        }
    }
    
    private var data: [MovieResult] = []
    private var currentPage: Int = 1
    private var totalPage: Int = 1
    
    private let movieModel = MovieModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPage = initData?.totalPages ?? 1
        currentPage = initData?.page ?? 1
        registerCollectionView()
    }
    
    private func registerCollectionView(){
        collectionViewMoreShowCase.dataSource = self
        collectionViewMoreShowCase.delegate = self
        collectionViewMoreShowCase.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
    }
    
    private func fetchTopRelatedMovie(page: Int){
        movieModel.getTopRelatedMoveiList(page: page){ result in
            switch result {
            case .success(let movieListResponse):
                self.currentPage = movieListResponse.page
                self.totalPage = movieListResponse.totalPages ?? self.totalPage
                self.data.append(contentsOf: movieListResponse.results ?? [])
                self.collectionViewMoreShowCase.reloadData()
            case .failure(let error):
                debugPrint("Top Related Movie Error in \(page) > \(error.description)")
            }
        }
    }
}

extension MoreShowCaseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as ShowCaseCollectionViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width - 16
        let itemHeight = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == (data.count - 1)
        let hasMoreMovie = currentPage < totalPage
        if isAtLastRow && hasMoreMovie {
            fetchTopRelatedMovie(page: currentPage + 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = data[indexPath.row].id {
            navigateToFilmDetailViewController(movieId: movieId, isTVSeries: false)
        }
    }
    
}
