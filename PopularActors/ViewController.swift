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
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var actorNames = [String]()
    var actorPopularity = [Float]()
    var actorImages = [Any]()
    var actorID = [Any]()
    var selectedActor_Name = ""
    var selectedActor_Popularity = ""
    var selectedActor_Image = ""
    var page: Int = 1
    var urlQuery = ""
    var urlPopular = ""
    var fetchingMore = false
    var searchURL = String()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlPopular = "/popular"
        self.createUrl()
        apiRequest()
        loadingActivity.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchBar.placeholder = "Search Actors"
    }
    
    func apiRequest(){//start requesting data
        
//        self.loadingActivity.isHidden=false
//        self.loadingActivity.startAnimating()

        //showloading
        let url = URL(string: self.searchURL)
        let session = URLSession.shared

        let task = session.dataTask(with: url!) { (data, response, error) in
            //hide loading
//            self.loadingActivity.isHidden = true
//            self.loadingActivity.stopAnimating()
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
                        self.reloadData()
                        
                    } catch {
                        
                    }
                } else {
                    
                }
            }
            
        }
        task.resume()
    }
    
    func reloadData(){
        self.tableView.reloadData()
    }
    
    func removeArrays(){
        self.page = 1
        self.actorNames.removeAll()
        self.actorPopularity.removeAll()
        self.actorID.removeAll()
        self.actorImages.removeAll()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.removeArrays()
//        self.searchURL = "https://api.themoviedb.org/3/person/popular?api_key=e0fa1c423583d32191513776f4eb5e62&page=\(self.page)"
        self.urlPopular = "/popular"
        self.urlQuery.removeAll()
        createUrl()
        self.apiRequest()
        self.reloadData()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: "", with: "+")
        self.removeArrays()
        self.urlQuery = String(finalKeywords!)
        self.urlQuery = (finalKeywords)!
        print(self.urlQuery)
//        self.urlPopular = ""
////        self.searchURL = "https://api.themoviedb.org/3/search/person?api_key=e0fa1c423583d32191513776f4eb5e62&query=\(finalKeywords!)&page=\(self.page)"
//        createUrl()
//        self.view.endEditing(true)
//        self.apiRequest()
    }
    
    func createUrl(){
        self.searchURL = "https://api.themoviedb.org/3/person\(self.urlPopular)?api_key=e0fa1c423583d32191513776f4eb5e62&page=\(self.page)&query=\(self.urlQuery)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            _ = (self.actorNames.count...self.actorNames.count + 19).map { index in index }
            //self.actorID.append(contentsOf: newActors as [Any])
            self.page += 1
            self.createUrl()
            self.apiRequest()
            self.fetchingMore = false
            self.tableView.reloadData()
        })
    }
    
}
