//
//  ActorViewController.swift
//  PopularActors
//
//  Created by Emirhan KENTER on 30/06/2018.
//  Copyright © 2018 Navek. All rights reserved.
//

import UIKit

class ActorViewController: UIViewController {

    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    var actorName = ""
    var actorPopularity = ""
    var actorImageUrl = ""
    //let url = URL(string: "https://image.tmdb.org/t/p/w470_and_h470_face\(actorImageUrl)")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = actorName
        popularityLabel.text = actorPopularity
    }
}
