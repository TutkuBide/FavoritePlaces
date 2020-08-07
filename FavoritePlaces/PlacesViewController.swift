//
//  placesVC.swift
//  fourSquareClone
//
//  Created by Tutku Bide on 28.06.2019.
//  Copyright © 2019 Tutku Bide. All rights reserved.
//

import UIKit
import Parse

class PlacesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placesNameArray = [String]()
    var chosenPlace = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenPlace = placesNameArray[indexPath.row]
        self.performSegue(withIdentifier: "fromplacesVCtodetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromplacesVCtodetailsVC" {
            let destination = segue.destination as! DetailsViewController
            destination.selectedPlaces = self.chosenPlace
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.placesNameArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.tableView.reloadData()
        }
    }
    
    func getData() {
        let query = PFQuery(className: "Place")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                self.placesNameArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.placesNameArray.append(object.object(forKey: "name") as! String)
                    
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "☆ \(placesNameArray[indexPath.row])"
        return cell
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "fromplacesVCtoimagesVC", sender: nil)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
        let sign = self.storyboard?.instantiateViewController(withIdentifier: "sign") as! SignInViewController
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = sign
        delegate.rememberUser()
    }
}
