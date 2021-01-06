//
//  MoviesListController+SearchView.swift
//  Movs
//
//  Created by joao.lucas.f.pereira on 06/01/21.
//

import UIKit

extension MoviesListController: UISearchBarDelegate {
    @objc func showSearchBar() {
        configureSearchBar()
    }
        
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .black
                
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        setupSearchBar()
        inSearchMode = false
        collectionView.reloadData()
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredMovies = moviesList.filter({ $0.title.range(of: searchText) != nil })
            collectionView.reloadData()
        }
    }
}
