//
//  MoviesListController+Genres.swift
//  Movs
//
//  Created by joao.lucas.f.pereira on 06/01/21.
//

import UIKit

extension MoviesListController {
    func setupFetchGenres() {
        viewModel.fetchGenres()
            .successObserver(onSuccessGenres)
            .errorObserver(onErrorGenres)
    }
    
    private func onSuccessGenres(genres: GenresDTO) {
        let genres = genres
        GenresDTO.shared = genres
    }
    
    private func onErrorGenres(message: HTTPError) {
        print(message.localizedDescription)
    }
}
