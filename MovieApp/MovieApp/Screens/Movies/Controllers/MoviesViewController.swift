//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Sanjana on 15/09/24.
//

import UIKit

class MoviesViewController: UIViewController {
    
    var screenSize : CGRect!
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!
    var movieList : [Search]?
    
    // MARK: - IBOutlets
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - VC life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - IBAction
    @IBAction func favouriteTapped(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - CollectionView Delegates & DataSource
extension MoviesViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        cell.titleLabel.text = movieList?[indexPath.row].title
        cell.releaseDateLabel.text = movieList?[indexPath.row].year
        let posterURL = self.movieList?[indexPath.row].poster ?? ""
        let url = URL(string: posterURL)
        if let newURL = url {
            cell.movieImageView.downloaded(from: newURL)
        }
        cell.movie = movieList?[indexPath.row]
        cell.tag = moviesCollectionView.tag
        cell.onFavouriteButtonTapped = { [weak self] message in
            let alert = UIAlertController(title: "Favourites", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self?.present(alert, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        destinationVC.imdbID = movieList?[indexPath.row].imdbID
        destinationVC.movieTitle = movieList?[indexPath.row].title
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}


// MARK: - SearchBar Delegates
extension MoviesViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            fetchMoviesAPI(nil)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            moviesCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty{
            fetchMoviesAPI(text)
            moviesCollectionView.reloadData()
        }
        self.searchBar.endEditing(true)
    }
}
// MARK: - Setup Methods
extension MoviesViewController{
    func setUp(){
        moviesCollectionView.tag = 1
        setUpCollectionView()
        fetchMoviesAPI(nil)
    }
    
    func setUpCollectionView(){
        moviesCollectionView.register(UINib(nibName: "MoviesCollectionViewCell" , bundle: .main), forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth - 30)/2, height: screenWidth/1.5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        moviesCollectionView.collectionViewLayout = layout
    }
    
    func fetchMoviesAPI(_ search: String?){
        //get apikey from Secrets.plist
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["OMDB_API_KEY"] as? String {
            
            let searchTerm = search?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Action"
            guard let url = URL(string: "https://www.omdbapi.com/?s=\(searchTerm)&page=1&apikey=\(apiKey)") else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)
            
            MovieService.shared.request(urlRequest: request, resultType: SearchGenre.self) { [weak self] data in
                guard let self = self else { return }
                
                switch data{
                case .success(let data) :
                    self.movieList = data.search
                    DispatchQueue.main.async {
                        self.noResultView.isHidden = true
                        self.moviesCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async{
                        self.noResultView.isHidden = false
                    }
                }
            }
        }
        else{
            print("key not found")
        }
    }
    
}

