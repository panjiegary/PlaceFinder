//
//  ResultTableViewController.swift
//  PlaceFinder
//
//  Created by 潘捷 on 2017-03-12.
//  Copyright © 2017 SMU. All rights reserved.
//

import UIKit
import CoreLocation

class ResultTableViewController: UITableViewController, YelpAPIControllerProcol {
    
    var api: YelpAPIController!
    var businesses = [Business]()
    var term: String?
    var location: CLLocation?
    var hotAndNew: Bool?
    var cashback: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestYelp()
    }
    
    func requestYelp(){
        api = YelpAPIController()
        api.delegate = self
        if let location = location, let term = term, let hotAndNew = hotAndNew
            , let cashback = cashback {
            api.getBusinessSearch(location: location, term: term, hotAndNew: hotAndNew
                , cashback: cashback)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    //MARK: -YelpAPIControllerProcol
    func didReceiveAPIResults(results: [[String: Any]]) {
        DispatchQueue.main.async(execute: {
            for result in results {
                if let newItem = Business(json: result) {
                    self.businesses.append(newItem)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! BusinessTableViewCell
        let business = businesses[indexPath.row]
        cell.name.text = business.name
        cell.distance.text = business.distance
        cell.category.text = business.categories
        if let url = business.img_url
        {
            if let data = NSData(contentsOf: url)
            {
                cell.preview.contentMode = UIViewContentMode.scaleAspectFit
                cell.preview.image = UIImage(data: data as Data)
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue" {
            if let selectedCell = sender as? BusinessTableViewCell {
                if let selectedIndex = tableView.indexPath(for: selectedCell) {
                    let destinationViewController = segue.destination as! DetailsViewController
                    destinationViewController.business = businesses[selectedIndex.row]
                }
            }
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
