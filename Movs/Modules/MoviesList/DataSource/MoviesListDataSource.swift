//
//  MoviesListDataSource.swift
//  Movs
//
//  Created by joao.lucas.f.pereira on 06/01/21.
//

import UIKit
import RealmSwift

final class MoviesListDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var moviesList: [ResultMoviesDTO]
    private var filteredMovies: [ResultMoviesDTO]
    private var inSearchMode: Bool
    private var viewModel: MoviesListViewModel
    private var itemsFavorites = [FavoriteEntity]()
    var realm: Realm
    
    init(moviesList: [ResultMoviesDTO], filteredMovies: [ResultMoviesDTO], inSearchMode: Bool, realm: Realm, viewModel: MoviesListViewModel) {
        self.moviesList = moviesList
        self.filteredMovies = filteredMovies
        self.inSearchMode = inSearchMode
        self.realm = realm
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            if self.filteredMovies.isEmpty {
                let emptyView = EmptyView()
                collectionView.backgroundView = emptyView
            } else {
                collectionView.backgroundView = nil
            }
            return self.filteredMovies.count
        }
        
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesList", for: indexPath) as! MoviesListCell
        
        let movies = inSearchMode ? filteredMovies[indexPath.row] : moviesList[indexPath.row]
    
        cell.backgroundColor = .systemBlue
        cell.delegate = self
        cell.addComponents(with: movies)
        
        itemsFavorites = realm.objects(FavoriteEntity.self).map({ $0 })
                
        if itemsFavorites.contains(where: {$0.id == movies.id}) {
            cell.favorite.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
        } else {
            cell.favorite.setImage(UIImage(named: "favorite_gray_icon"), for: .normal)
        }
    
        return cell
    }
}

extension MoviesListDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 170.0
        let height = width * 1.76
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 170

        let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
        let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 16, left: edgeInsets, bottom: 16, right: edgeInsets)
    }
}

extension MoviesListDataSource: MoviesListDelegate {
    func buttonFavorite(movies: ResultMoviesDTO, cell: MoviesListCell) {
        if cell.favorite.currentImage == UIImage(named: "favorite_gray_icon") {
            cell.favorite.setImage(UIImage(named: "favorite_full_icon"), for: .normal)
            addToFavorite(movie: movies)
        } else {
            cell.favorite.setImage(UIImage(named: "favorite_gray_icon"), for: .normal)
            removeFavorite(movie: movies)
        }
    }
    
    private func addToFavorite(movie: ResultMoviesDTO) {
        viewModel.loadAddToFavorite(realm: realm, movie: movie)
    }
    
    private func removeFavorite(movie: ResultMoviesDTO) {
        viewModel.loadRemoveFavorite(realm: realm, movie: movie)
    }
    
    func setupStates() {
        viewModel.successAdding.observer(viewModel) { message in
            print(message)
        }
        
        viewModel.successRemoving.observer(viewModel) { message in
            print(message)
        }
    }
}
