//
//  FlicksViewController.swift
//  Flicks
//
//  Created by Rocha, Luis on 4/1/17.
//  Copyright © 2017 Luis Rocha. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var endpoint: String = ""
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.isHidden = true
        
        searchBar.delegate = self
        
        // table view configuration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        
        // initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FlicksViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        refreshControlAction(refreshControl)
        
        // navigation bar
        self.navigationItem.title = "Movies"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            navigationBar.barStyle = .blackTranslucent
            navigationBar.backgroundColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        // load the movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            // Check if there is an error.
            if error != nil {
                self.errorView.isHidden = false
                NSLog("error: \(String(describing: error))")
                refreshControl.endRefreshing()
                return
            }

            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
                    let moviesDict = responseDictionary["results"] as! [NSDictionary]
                    NSLog("totalMovies=\(moviesDict.count)")
                    
                    self.movies = []
                    for movieDict in moviesDict {
                        let movie = Movie(movie: movieDict as NSDictionary)
                        self.movies.append(movie)
                    }
                    self.filteredMovies = []
                    self.filteredMovies.append(contentsOf: self.movies)
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // get the current movie
        let movie = filteredMovies[indexPath.row]
        
        // set cell data
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = movie.overview

        // fade in image loaded from network
        let imageRequest = URLRequest(url: movie.smallPosterUrl!)
        cell.posterImageView.setImageWith(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
            if (imageResponse != nil) {
                // not in cache, so fade in image
                print("image not in cache: fade in image")
                cell.posterImageView.alpha = 0.0
                cell.posterImageView.image = image
                UIView.animate(withDuration: 0.4, animations: {
                    cell.posterImageView.alpha = 1.0
                })
            } else {
                // already in cache, so just update it
                print("image already in cache: update image")
                cell.posterImageView.image = image
            }
        }) { (imageRequest, imageResponse, error) in
            // error handling
            print("error loading image: " + (imageRequest.url?.absoluteString)!)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get the index path of the sender
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        // get the detail view controller
        let detailViewController = segue.destination as! MovieDetailsViewController
        
        // set the movie model in the detail view controller
        detailViewController.movie = filteredMovies[indexPath!.row]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies.filter({ (movie: Movie) -> Bool in
            // search in both title and overview fields
            return (movie.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) ||
            (movie.overview.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        })
        tableView.reloadData()
    }
}
