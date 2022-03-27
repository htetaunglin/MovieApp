//
//  GenreTableViewCell.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 12/02/2022.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewGenre: UICollectionView!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
    var genreList: [GenreVo]? {
        didSet{
            if let _ = genreList {
                genreList?.removeAll{ !movieListByGenre.keys.contains($0.id) }
                collectionViewGenre.reloadData()
                onTapGenre(genreList?.first?.id ?? 0)
            }
        }
    }
    
    weak var delegate: MovieItemDelegate?
    
    var allMovieAndSeries : [MovieResult] = [] {
        didSet{
            allMovieAndSeries.forEach{ (movieSeries) in
                movieSeries.genreIDS?.forEach{ (genreId) in
                    let key = genreId
                    if let _ = movieListByGenre[key] {
                        movieListByGenre[key]!.insert(movieSeries)
                    } else {
                        movieListByGenre[key] = [movieSeries]
                    }
                }
            }
        }
    }
    private var selectedMovieList: [MovieResult] = []
    private var movieListByGenre: [Int: Set<MovieResult>] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionViewGenre()
        registerCollectionViewMovie()
    }
    
    private func registerCollectionViewGenre(){
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        collectionViewGenre.registerForCell(identifier: GenreCollectionViewCell.identifier)
    }
    
    private func registerCollectionViewMovie(){
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension GenreTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMovie {
            return selectedMovieList.count
        }
        return genreList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMovie {
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = selectedMovieList[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            cell.data = genreList?[indexPath.row]
            cell.onTapItem = {[weak self] genreId in
                guard let self = self else { return }
                self.onTapGenre(genreId)
            }
            return cell
        }
    }
    
    private func onTapGenre(_ genreId: Int) {
        self.genreList?.forEach{ (genreVo) in
            if genreId == genreVo.id {
                genreVo.isSelected = true
            } else {
                genreVo.isSelected = false
            }
        }
        let movieList = self.movieListByGenre[genreId]
        self.selectedMovieList = movieList?.map{ $0 } ?? [MovieResult]()
        self.collectionViewGenre.reloadData()
        self.collectionViewMovie.reloadData()
    }
    
    
    //For Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewMovie {
            return CGSize(width: 120, height: 250)
        }
        return CGSize(width: widthOfString(text: genreList?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)) + 25, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func widthOfString(text: String, font: UIFont)-> CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize =  text.size(withAttributes: fontAttributes)
        return CGFloat(textSize.width)
    }
    
    //For Onclick
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = selectedMovieList[indexPath.row].id {
            if selectedMovieList[indexPath.row].video ?? true {
                delegate?.onTapTVSeries(id: id)
            } else {
                delegate?.onTapMovie(id: id)
            }
        }
    }
}
