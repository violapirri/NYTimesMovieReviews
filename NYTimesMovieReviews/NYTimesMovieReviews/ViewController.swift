//
//  ViewController.swift
//  NYTimesMovies
//
//  Created by Viola Pirri on 9/25/17.
//  Copyright © 2017 Viola Pirri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var myView: UIView!
    @IBOutlet var tableView: UITableView!
    var rowHeight =  140.0
    
    var searchResults: [Movies] = []
    let cellReuseIdentifierSet = "cellSettings"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifierSet)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let queryNYTimes = QueryNYTimes()
        
        //view.addSubview(myView)
        
        queryNYTimes.getSearchResults() { results, errorMessage in
            if let results = results {
                self.searchResults = results
                self.tableView.reloadData()
            }
            
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
    }
    
    // -- Datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierSet) as UITableViewCell!
        
        let url =  URL(string: self.searchResults[indexPath.row].media)
        
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            cell.imageView?.image = UIImage(data: data!)!
        }
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = self.searchResults[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let url =  URL(string: self.searchResults[indexPath.row].reviewLink)
        
        UIApplication.shared.open(url!)
    }
}
