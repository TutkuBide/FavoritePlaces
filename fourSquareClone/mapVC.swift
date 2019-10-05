//
//  mapVC.swift
//  fourSquareClone
//
//  Created by Tutku Bide on 28.06.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import MapKit
import Parse

class mapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
   @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager() /// kullanıcı yeri bulma
    var choosenLatitude = ""
    var choosenLongitude = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        mapView.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest /// yer bulma keskinliği
        manager.requestWhenInUseAuthorization() //// kullanıcı istediği zaman çalıssın
        manager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapVC.chooseLocation))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.choosenLongitude = ""
        self.choosenLatitude = ""
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began  {
            let touches = gestureRecognizer.location(in: self.mapView) /// dokunulan nokta
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation() /// kırmızı pin
            annotation.coordinate = coordinates
            annotation.title = globalName
            annotation.subtitle = globalType
            self.mapView.addAnnotation(annotation)
            
            self.choosenLatitude = String(coordinates.latitude)
            self.choosenLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    

  
    @IBAction func saveButton(_ sender: Any) {
        let object = PFObject(className: "Place")
        object["name"] = globalName
        object["type"] = globalType
        object["atmospher"] = globalAtmospher
        object["latitude"] = self.choosenLatitude
        object["longitude"] = self.choosenLongitude
        
        if let imageData = globalImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
              self.present(alert, animated: true, completion: nil)
            }else{
                
                self.performSegue(withIdentifier: "frommapVCtoplacesVC", sender: nil)
                
            }
        }
        
    }
    @IBAction func cancelButton(_ sender: Any) {
        
    self.dismiss(animated: true, completion: nil)
    }
    
}
