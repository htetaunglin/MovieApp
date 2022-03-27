//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 24/03/2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionViewMovies: UICollectionView!
    
    private let searchBar: UISearchBar = UISearchBar()
    
    private let searchModel = SearchModelImpl.shared
    
    private var data: [MovieResult] = []
    private var currentPage: Int = 1
    private var totalPage: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionView()
        initSearchBar()
    }
    
    private func initSearchBar(){
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor.white
        navigationItem.titleView = searchBar
    }
    
    private func registerCollectionView(){
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        collectionViewMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    private func searchMovie(searchText: String?, page: Int = 1){
        searchModel.searchMovie(searchText ?? "", page: page){ result in
            switch result {
            case .success(let movieListResponse):
                self.currentPage = movieListResponse.page
                self.totalPage = movieListResponse.totalPages
                if page == 1 {
                    self.data.removeAll()
                }
                self.data.append(contentsOf: movieListResponse.results ?? [])
                self.collectionViewMovies.reloadData()
            case .failure(let error):
                debugPrint("Search Movie Error > \(error.description)")
            }
            
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = (collectionView.frame.width / 3) - 9
        let itemHeight : CGFloat = itemWidth * 1.8
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == (data.count - 1)
        let hasMoreMovie = currentPage < totalPage
        if isAtLastRow && hasMoreMovie {
            searchMovie(searchText: searchBar.text, page: currentPage + 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = data[indexPath.row].id {
            navigateToFilmDetailViewController(movieId: movieId, isTVSeries: false)
        }
    }
}



extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchMovie(searchText: searchText)
        }
    }
}
