//
//  FlicksViewController.swift
//  Flicks
//
//  Created by Rocha, Luis on 4/1/17.
//  Copyright © 2017 Luis Rocha. All rights reserved.
//

import UIKit
import AFNetworking

class FlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary] = []
    
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
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    
                    self.tableView.reloadData()
                    NSLog("response: \(self.movies)")
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
        
        // parse the data
        let movie = movies[indexPath.row] as NSDictionary
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        cell.titleLabel.text = title
        cell.summaryLabel.text = overview
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w45/\(posterPath)") {
            cell.movieImageLabel.setImageWith(imageUrl)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get the index path of the sender
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        // get the detail view controller
        let detailViewController = segue.destination as! MovieDetailsViewController
        
        // set the image in the detail view controller from the cell image
        let movie = movies[indexPath!.row] as NSDictionary
        let posterPath = movie["poster_path"] as! String
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w342/\(posterPath)") {
            detailViewController.imageUrl = imageUrl
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
