//
//  secondViewController.swift
//  mapview
//
//  Created by Harpanth Kaur on 2021-02-17.
//

import UIKit
import CoreData
import MapKit

class secondViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var results = [Labtest]()
    var results1: Labtest?

    var loc = Labtest()
    var check=false

    @IBOutlet weak var loctitle: UITextField!
    @IBOutlet weak var subtitle: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //43.6532° N, 79.3832° W!
       // 30.9661° N, 76.5231° E
        
        loctitle.text=results1?.title
        subtitle.text=results1?.subtitle
        latitude.text=String(results1?.latitude ?? 0.0)
        longitude.text=String(results1?.longitude ?? 0.0)

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveData(_ sender: Any) {
        
        if(check)
        {
            results1!.title=loctitle.text!
            results1!.subtitle=subtitle.text!
            results1!.latitude=Double(latitude.text!)!
            results1!.longitude=Double(longitude.text!)!
            check=false
        }
        
        else{
        loc = Labtest(context: self.context)
        
        loc.title=loctitle.text!
        loc.subtitle=subtitle.text!
        loc.latitude = Double(latitude.text!)!
        loc.longitude = Double(longitude.text!)!
            
        }

        // save the data in the core data
        do{
            try self.context.save()
        }
        catch{
            print("Error in saving data to core data")
        }
    }
    
    @IBAction func deleteData(_ sender: UIButton) {
        if(check)
        {
            self.context.delete(results1!)
        }
        else{
            self.context.delete(loc)
        }
    }
    
}
