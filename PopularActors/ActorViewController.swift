//
//  ActorViewController.swift
//  PopularActors
//
//  Created by Emirhan KENTER on 30/06/2018.
//  Copyright © 2018 Navek. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ActorViewController: UIViewController {

    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    var actorName = ""
    var actorPopularity = ""
    var actorImageUrl = ""
    
    let imageCache = AutoPurgingImageCache()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = URL(string: "https://image.tmdb.org/t/p/w470_and_h470_face\(self.actorImageUrl)")!
        self.actorImage.af_setImage(withURL: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = actorName
        popularityLabel.text = actorPopularity
    }
}
