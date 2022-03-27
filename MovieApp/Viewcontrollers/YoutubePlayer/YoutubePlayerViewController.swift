//
//  YoutubePlayerViewController.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 23/03/2022.
//

import UIKit
import YouTubePlayer

class YoutubePlayerViewController: UIViewController {

    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    
    var youtubeId: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = youtubeId {
            youtubePlayerView.loadVideoID(id)
        } else {
            print("Invalid Youtube Id")
        }
        
    }
    
    @IBAction func onClickDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
