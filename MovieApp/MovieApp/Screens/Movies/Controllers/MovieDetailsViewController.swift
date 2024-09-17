//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Sanjana on 15/09/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movieDetails : Movie?
    var imdbID : String?
    var movieTitle: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - VC life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUp()
    }
}

// MARK: - Setup Methods
extension MovieDetailsViewController{
    func setUp(){
        setMovieTitle()
        getMovieDetailsAPI(imdbID ?? "")
        
    }
    
    func setMovieTitle(){
        DispatchQueue.main.async {
            self.titleLabel.text = self.movieTitle
        }
    }
    
    func setMovieDetailsfromAPI(){
        DispatchQueue.main.async {
            self.noDataView.isHidden = true
            self.genreLabel.text = self.movieDetails?.genre
            self.ratingLabel.text = "Rating : \(self.movieDetails?.imdbRating ?? "N/A")"
            self.descriptionLabel.text = self.movieDetails?.plot
            let posterURL = self.movieDetails?.poster
            guard let posterURL else {return}
            let url = URL(string: posterURL)
            if let newURL = url {
                self.movieImageView.downloaded(from: newURL)
            }
        }
    }
    
    func getMovieDetailsAPI(_ imdbID: String){
        //get apikey from Secrets.plist
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["OMDB_API_KEY"] as? String {
            guard let url = URL(string: "https://www.omdbapi.com/?i=\(imdbID)&apikey=\(apiKey)") else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            
            MovieService.shared.request(urlRequest: request, resultType: Movie.self) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let movie):
                    self.movieDetails = movie
                    setMovieDetailsfromAPI()
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.noDataView.isHidden = false
                    }
                }
            }
        }
        else{
            print("key not found")
        }
    }
}

