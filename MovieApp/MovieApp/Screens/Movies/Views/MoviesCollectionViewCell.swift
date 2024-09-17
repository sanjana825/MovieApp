//
//  MoviesCollectionViewCell.swift
//  MovieApp
//
//  Created by Sanjana on 15/09/24.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    var movie : Search?
    var onFavouriteButtonTapped: (() -> Void)?
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // MARK: -  VC life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - IBAction
    @IBAction func favouriteTapped(_ sender: Any) {
        if tag == 1{
            // save movie to UserDefaults for moviesCollectionView
            guard let movie else {return}
            saveMovie(movie)
            onFavouriteButtonTapped?()
        }
        else if tag == 2{
            //remove from UserDefaults for favouritesCollectionView
            guard let movie else {return}
            removeMovie(movie)
            onFavouriteButtonTapped?()
        }
    }
}

// MARK: - UserDefault methods
extension MoviesCollectionViewCell{
    func saveMovie(_ movie: Search){
        var savedMovies = getSavedMoviesFromUserDefaults()
        if !(savedMovies.contains(where: {$0.imdbID == movie.imdbID})){
            savedMovies.append(movie)
            saveMoviesToUserDefaults(savedMovies)
        }
    }
    
    func removeMovie(_ movie : Search){
        var savedMovies = getSavedMoviesFromUserDefaults()
        if let index = savedMovies.firstIndex(where: {$0.imdbID == movie.imdbID}){
            savedMovies.remove(at : index)
            saveMoviesToUserDefaults(savedMovies)
        }
    }
    
    func saveMoviesToUserDefaults(_ movies: [Search]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: "savedMovies")
            print("Movie saved")
            
        }
    }
    
    func getSavedMoviesFromUserDefaults() -> [Search] {
        guard let data = UserDefaults.standard.data(forKey: "savedMovies") else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Search].self, from: data)) ?? []
    }
}
