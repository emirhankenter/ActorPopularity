//
//  ViewController.swift
//  PopularActors
//
//  Created by Emirhan KENTER on 29/06/2018.
//  Copyright © 2018 Navek. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchActor: UISearchBar!
//    @IBOutlet weak var currentPage: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var actorNames = [String]()
    var actorPopularity = [Float]()
    var actorImages = [Any]()
    var actorID = [Any]()
    var selectedActor_Name = ""
    var selectedActor_Popularity = ""
    var selectedActor_Image = ""
    var page: Int = 1
    var searchName = "Chris"
    var searchResult = [String]()
    var fetchingMore = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiRequest(page: page)
//        currentPage.text = "1"
        loadingActivity.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchBar.placeholder = "Search Actors"
    }
    
    func apiRequest(page: Int){//start requesting data
        
        let url = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=e0fa1c423583d32191513776f4eb5e62&page=\(page)")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                if data != nil {
                    
                    do {
                        let jSONResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
                        //print(jSONResult)
                        //let totalPage = jSONResult["total_pages"] as! Int
                        //print(totalPage)
                        let popularList = jSONResult["results"] as! NSArray
                        //print(popularList)
        
                        for actorObj in (popularList as NSArray as! [Dictionary<String, AnyObject>]) {
                            self.actorNames.append(actorObj["name"]! as! String)
                            self.actorPopularity.append(actorObj["popularity"]! as! Float)
                            self.actorImages.append(actorObj["profile_path"] as Any)
                            //self.actorID.append(actorObj["id"]! as! Int)
                        }
                        let filteredStrings = self.actorNames.filter({ (item: String) -> Bool in
                            let stringMatch = item.localizedLowercase.range(of: self.searchName.localizedLowercase)
                            return stringMatch != nil ? true : false
                        })
                        self.searchResult.append(contentsOf: filteredStrings)
                        print(self.searchResult)
                        self.tableView.reloadData()
                        
                    } catch {
                        
                    }
                }
            }
            
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let search = String(describing: searchBar.text)
//        self.actorNames.removeAll()
//        self.actorNames.append(String(search))
//        self.tableView.reloadData()
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if loadingActivity.isAnimating == true {
//            loadingActivity.isHidden = true
//            loadingActivity.stopAnimating()
//        } else {
//            loadingActivity.isHidden=false
//            loadingActivity.startAnimating()
//        }
        return self.actorNames.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toActorPage" {
            let destinationVC = segue.destination as! ActorViewController
            destinationVC.actorName = selectedActor_Name
            destinationVC.actorPopularity = selectedActor_Popularity
            destinationVC.actorImageUrl = selectedActor_Image
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedActor_Name = actorNames[indexPath.row]
        selectedActor_Popularity = String(actorPopularity[indexPath.row])
        selectedActor_Image = actorImages[indexPath.row] as! String
        performSegue(withIdentifier: "toActorPage", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1).  \(self.actorNames[indexPath.row])"
        //cell.textLabel?.text = "\(indexPath.row + 1).  \(String(describing: self.actorID[indexPath.row]))"
        //cell.textLabel?.text = String(self.actorPopularity[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let newActors = (self.actorNames.count...self.actorNames.count + 19).map { index in index }
            //self.actorID.append(contentsOf: newActors as [Any])
            self.page += 1
            self.apiRequest(page: self.page)
            print(newActors)
            self.fetchingMore = false
            self.tableView.reloadData()
        })
    }
    
}
