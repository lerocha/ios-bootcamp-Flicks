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

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view configuration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        
        // load the movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
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

            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
                    let moviesDict = responseDictionary["results"] as! [NSDictionary]
                    NSLog("response: \(self.movies)")
                    
                    for movieDict in moviesDict {
                        let movie = Movie(movie: movieDict as NSDictionary)
                        self.movies.append(movie)
                    }
                    self.tableView.reloadData()
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
        return movies.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // get the current movie
        let movie = movies[indexPath.row]
        
        // set cell
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = movie.overview
        cell.posterImageView.setImageWith(movie.smallPosterUrl!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get the index path of the sender
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        // get the detail view controller
        let detailViewController = segue.destination as! MovieDetailsViewController
        
        // set the movie model in the detail view controller
        detailViewController.movie = movies[indexPath!.row]
    }
}
