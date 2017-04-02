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
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        overviewLabel.sizeToFit()

        // fade in image loaded from network
        let imageRequest = URLRequest(url: movie.posterUrl!)
        posterImageView.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) in
                if (imageResponse != nil) {
                    // not in cache, so fade in image
                    print("image not in cache: fade in image")
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = image
                    UIView.animate(withDuration: 0.3, animations: {
                        self.posterImageView.alpha = 1
                    })
                    
                } else {
                    // already in cache, so just update it
                    print("image already in cache: update image")
                    self.posterImageView.image = image
                }
        }) { (imageRequest, imageResponse, error) in
            // error handling
            print("error loading image: " + (imageRequest.url?.absoluteString)!)
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
