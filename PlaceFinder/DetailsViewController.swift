//
//  DetailsViewController.swift
//  PlaceFinder
//
//  Created by 潘捷 on 2017-03-25.
//  Copyright © 2017 SMU. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    var business: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        if let business = business {
            nameLabel.text = business.name ?? "Business name"
            if let phone = business.phone {
                phoneNumber.text = String("Phone: \(phone)")
            } else {
                phoneNumber.text = String("Phone: Not available")
            }
            categoriesLabel.text = business.categories
            if let rating = business.rating {
                ratingLabel.text = String("Rating: \(rating)")
            } else {
                ratingLabel.text = String("Rating: Not available")
            }
            if let img_url = business.img_url {
                let imageInfo = NSData(contentsOf: img_url)
                let imageCell = UIImage(data: imageInfo as! Data)
                imagePreview.contentMode = UIViewContentMode.scaleAspectFit
                imagePreview.image = imageCell
            }
            //map
            if let coordinates = business.coordinates {
                let annotation = MKPointAnnotation()
                annotation.title = business.name
                annotation.coordinate.latitude = coordinates.coordinate.latitude
                annotation.coordinate.longitude = coordinates.coordinate.longitude
                mapView.addAnnotation(annotation)
                centerMapOnLocation(annotation.coordinate)
                mapView.showsUserLocation = true
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let radius = 1000
        let region = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(Double(radius) * 2.0), CLLocationDistance(Double(radius) * 2.0))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusePin")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        view.pinTintColor = UIColor.green
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        if let coordinate = view.annotation?.coordinate {
            location?.mapItem(coordinate: coordinate).openInMaps(launchOptions: launchingOptions)
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

extension MKAnnotation {
    func mapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        return mapItem
    }
}
