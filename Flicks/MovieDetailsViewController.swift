//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Rocha, Luis on 4/1/17.
//  Copyright © 2017 Luis Rocha. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        UIView.animate(withDuration: 1, delay: 0, options: .allowAnimatedContent, animations: {
            self.scrollView.contentOffset.y = CGFloat(200)
        }, completion: nil)

        titleLabel.text = movie.title
        voteLabel.text = "\(movie.voteAgerage)/10"
        voteCountLabel.text = "\(movie.voteCount)"
        yearLabel.text = "\(movie.year)"
        overviewLabel.text = movie.overview
        overviewLabel.sizeToFit()

        // fade in image loaded from network
        let smallImageRequest = URLRequest(url: movie.smallPosterUrl!)
        let largeImageRequest = URLRequest(url: movie.posterUrl!)
        posterImageView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) in
                let duration: TimeInterval = smallImageResponse != nil ? 0.4 : 0.0
                print("image not in cache: fade in image")
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage
                UIView.animate(withDuration: duration, animations: {
                    self.posterImageView.alpha = 1
                }, completion: { (success) -> Void in
                    self.posterImageView.setImageWith(largeImageRequest, placeholderImage: nil, success: { (largeImageRequest, largeImageResponse, largeImage) in
                        self.posterImageView.image = largeImage
                    }, failure: { (largeImageRequest, largeImageResponse, error) in
                        // error handling
                        print("error loading large image: " + (largeImageRequest.url?.absoluteString)!)
                    })
                })
        }) { (smallImageRequest, smallImageResponse, error) in
            // error handling
            print("error loading small image: " + (smallImageRequest.url?.absoluteString)!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
