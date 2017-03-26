//
//  ConfigurationViewController.swift
//  PlaceFinder
//
//  Created by 潘捷 on 2017-03-12.
//  Copyright © 2017 SMU. All rights reserved.
//

import UIKit
import CoreLocation

class ConfigurationViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var showPlacesButton: UIButton!
    @IBOutlet weak var addTerm: UITextField!
    @IBOutlet weak var prettyImageView: UIImageView!
    
    @IBOutlet weak var hotAndNewSwitch: UISwitch!

    @IBOutlet weak var cashbackSwitch: UISwitch!
    
    var term: String?
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTerm.delegate = self
        showPlacesButton.isEnabled = false
        hotAndNewSwitch.isOn = false
        cashbackSwitch.isOn = false
        //
        if let url = URL(string: "https://static.independent.co.uk/s3fs-public/styles/article_large/public/thumbnails/image/2016/02/25/13/cat-getty_0.jpg")
        {
            if let data = NSData(contentsOf: url)
            {
                prettyImageView.contentMode = UIViewContentMode.scaleAspectFit
                prettyImageView.image = UIImage(data: data as Data)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addTerm {
            print(addTerm.text ?? "none")
            let trimmedString = addTerm.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            if trimmedString != "" {
                self.term = addTerm.text
                showPlacesButton.isEnabled = true
            } else {
                showPlacesButton.isEnabled = false
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addTerm {
            addTerm.resignFirstResponder()
            return false
        }
        return true
    }
    
    func getCurrentLocation() -> CLLocation {
        var currentLocation: CLLocation
        if let location = locationManager.location {
            currentLocation = location
        } else {
            currentLocation = CLLocation(latitude: 44.7210, longitude: -63.7104)
        }
        return currentLocation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "configurationToResultsSegue" {
            let destinationViewController = segue.destination as! ResultTableViewController
            destinationViewController.term = addTerm.text
            destinationViewController.hotAndNew = hotAndNewSwitch.isOn
            destinationViewController.cashback = cashbackSwitch.isOn
            destinationViewController.location = getCurrentLocation()
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
