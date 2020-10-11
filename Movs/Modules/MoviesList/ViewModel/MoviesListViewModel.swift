//
//  MoviesListViewModel.swift
//  Movs
//
//  Created by Joao Lucas on 08/10/20.
//

import Foundation
import RealmSwift

class MoviesListViewModel: DataLifeViewModel {
    
    let service: MoviesListService
    
    var viewState: ViewState<MoviesDTO, HTTPError>
    
    var useCase: MoviesListUseCase
    
    var successAdding = DataLife<String>()
    
    var successRemoving = DataLife<String>()
    
    init(service: MoviesListService, viewState: ViewState<MoviesDTO, HTTPError>, useCase: MoviesListUseCase) {
        self.service = service
        self.viewState = viewState
        self.useCase = useCase
    }
    
    func fetchMoviesList() -> ViewState<MoviesDTO, HTTPError> {
        viewState.fetchSource {
            self.service.getMoviesList { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.viewState.success(data: movies)
                case .failure(let message):
                    self?.viewState.error(error: message)
                }
            }
        }
        
        return viewState
    }
    
    func loadAddToFavorite(realm: Realm, movie: ResultMoviesDTO) {
        useCase.addToFavorites(realm: realm, movie: movie) {
            self.successAdding.value = "Success in adding to favorites"
        }
    }
    
    func loadRemoveFavorite(realm: Realm, movie: ResultMoviesDTO) {
        useCase.removeFavorites(realm: realm, movie: movie) {
            self.successRemoving.value = "Success when removing from favorites"
        }
    }
}
