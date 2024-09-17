//
//  FavouritesViewController.swift
//  MovieApp
//
//  Created by Sanjana on 16/09/24.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    var movieList : [Search]?
    
    // MARK: - IBOutlets
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var noFavouritesView: UIView!
    
    // MARK: - VC life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - CollectionView DataSource & Delegate
extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Provide the number of items based on your data source
        return movieList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        // Configure the cell
        cell.titleLabel.text = movieList?[indexPath.row].title
        cell.releaseDateLabel.text = movieList?[indexPath.row].year
        let posterURL = self.movieList?[indexPath.row].poster ?? ""
        let url = URL(string: posterURL)
        if let newURL = url {
            cell.movieImageView.downloaded(from: newURL)
        }
        cell.movie = movieList?[indexPath.row]
        cell.tag = favouritesCollectionView.tag
        cell.onFavouriteButtonTapped = { [weak self] message in
            if message != ""{
                let alert = UIAlertController(title: "Favourites", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self?.present(alert, animated: true)
            }
            self?.handleFavouriteButtonTapped(at: indexPath)
            
        }
        return cell
    }
    private func handleFavouriteButtonTapped(at indexPath: IndexPath) {
        loadMoviesFromUserDefaults()
        favouritesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        destinationVC.imdbID = movieList?[indexPath.row].imdbID
        destinationVC.movieTitle = movieList?[indexPath.row].title
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

// MARK: - Setup Methods
extension FavouritesViewController{
    func setUp() {
        setUpCollectionView()
        loadMoviesFromUserDefaults()
        favouritesCollectionView.tag = 2
    }
    
    func setUpCollectionView() {
        favouritesCollectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        favouritesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30)/2, height: UIScreen.main.bounds.width/1.5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        favouritesCollectionView.collectionViewLayout = layout
    }
    
    func loadMovies() -> [Search]? {
        if let savedMoviesData = UserDefaults.standard.data(forKey: "savedMovies") {
            let decoder = JSONDecoder()
            return try? decoder.decode([Search].self, from: savedMoviesData)
        }
        return nil
    }
    
    func loadMoviesFromUserDefaults(){
        if let savedMovies = loadMovies() {
            if savedMovies.count == 0{
                // Handle the case where no movies are saved
                noFavouritesView.isHidden = false
            }
            else{
                noFavouritesView.isHidden = true
                self.movieList = savedMovies
            }
        }
    }
}
