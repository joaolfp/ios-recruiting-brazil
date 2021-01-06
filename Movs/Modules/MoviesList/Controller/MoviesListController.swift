//
//  MoviesListController.swift
//  Movs
//
//  Created by Joao Lucas on 08/10/20.
//

import UIKit
import RealmSwift

class MoviesListController: UICollectionViewController {

    var moviesList = [ResultMoviesDTO]()
    
    var viewModel: MoviesListViewModel!
    var activityView: UIActivityIndicatorView?
    
    var filteredMovies = [ResultMoviesDTO]()
    var inSearchMode = false
    var searchBar: UISearchBar!
    
    let realm = try! Realm()
        
    var itemsFavorites = [FavoriteEntity]()
    
    private var dataSource: MoviesListDataSource? {
        didSet {
            guard let dataSource = dataSource else { return }
            
            collectionView.delegate = dataSource
            collectionView.dataSource = dataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        setupViewModel()
        setupFetchMovies()
        dataSource?.setupStates()
        setupFetchGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        self.collectionView!.register(MoviesListCell.self, forCellWithReuseIdentifier: "moviesList")
        self.collectionView.backgroundColor = .white
    }
    
    func setupSearchBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
}

// - MARK: View State popular movies

extension MoviesListController {
    private func setupViewModel() {
        viewModel = MoviesListViewModelFactory().create()
    }
    
    private func setupFetchMovies() {
        viewModel.fetchMoviesList()
            .successObserver(onSuccess)
            .loadingObserver(onLoading)
            .errorObserver(onError)
    }
    
    private func onSuccess(movies: MoviesDTO) {
        moviesList = movies.results
        dataSource = MoviesListDataSource(moviesList: moviesList, filteredMovies: filteredMovies,
                                          inSearchMode: inSearchMode, realm: realm, viewModel: viewModel)
        activityView?.stopAnimating()
    }
    
    private func onLoading() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    private func onError(message: HTTPError) {
        let errorView = ErrorView()
        self.view = errorView
        print(message.localizedDescription)
    }
}
