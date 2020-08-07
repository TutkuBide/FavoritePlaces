//
//  detailsVC.swift
//  fourSquareClone
//
//  Created by Tutku Bide on 28.06.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Parse
import MapKit

class DetailsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeAtmospherLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var selectedPlaces = ""
    var chosenLatitude = ""
    var chosenLongitude = ""
    var nameArray = [String]()
    var typeArray = [String]()
    var atmospherArray = [String]()
    var latitudeArray = [String]()
    var longitudeArray = [String]()
    var imageArray = [PFFileObject]()
    var manager = CLLocationManager()
    var requestCLLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        findPlaceFromServer()
        imageView.layer.cornerRadius = 75
        detailsView.layer.cornerRadius = 20
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.chosenLatitude != "" && self.chosenLongitude != "" {
            let location = CLLocationCoordinate2D(latitude: Double(self.chosenLatitude)!, longitude: Double(self.chosenLongitude)!)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.nameArray.last!
            annotation.subtitle = self.typeArray.last!
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let refuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: refuseID)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: refuseID)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != "" && self.chosenLatitude != "" {
            self.requestCLLocation = CLLocation(latitude: Double(self.chosenLatitude)!, longitude: Double(chosenLongitude)!)
            CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name = self.nameArray.last!
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
    func findPlaceFromServer() {
        let query = PFQuery(className: "Place")
        query.whereKey("name", equalTo: self.selectedPlaces)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.nameArray.removeAll(keepingCapacity: false)
                self.typeArray.removeAll(keepingCapacity: false)
                self.imageArray.removeAll(keepingCapacity: false)
                self.latitudeArray.removeAll(keepingCapacity: false)
                self.atmospherArray.removeAll(keepingCapacity: false)
                self.longitudeArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.nameArray.append(object.object(forKey: "name") as! String)
                    self.typeArray.append(object.object(forKey: "type") as! String)
                    self.atmospherArray.append(object.object(forKey: "atmospher") as! String)
                    self.latitudeArray.append(object.object(forKey: "latitude") as! String)
                    self.longitudeArray.append(object.object(forKey: "longitude") as! String)
                    self.imageArray.append(object.object(forKey: "image") as! PFFileObject)
                    self.placeNameLabel.text = "Name: \(self.nameArray.last!)"
                    self.placeTypeLabel.text = "Type: \(self.typeArray.last!)"
                    self.chosenLongitude = self.longitudeArray.last!
                    self.chosenLatitude = self.latitudeArray.last!
                    self.manager.startUpdatingLocation()
                    self.placeAtmospherLabel.text = "Atmospher: \(self.atmospherArray.last!)"
                    self.imageArray.last?.getDataInBackground(block: { (data, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            self.imageView.image = UIImage(data: data!)
                        }
                    })
                }
            }
        }
    }
}
