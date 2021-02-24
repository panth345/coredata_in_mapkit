//
//  ViewController.swift
//  mapview
//
//  Created by Harpanth Kaur on 2021-02-17.
//
import UIKit
import CoreData
import MapKit

class ViewController: UIViewController, MKMapViewDelegate
{
    var loc = Labtest()
    var model = [Labtest]()
    @IBOutlet weak var mapview: MKMapView!
    
    @IBOutlet weak var search: UISearchBar!
    var results = [Labtest]()
    var annotations = [MKAnnotation]()
    var titleselected=""
    var searchResults = [String]()
    var hasSearched = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.mapview.delegate = self
        
        self.getAnnotations()
        mapview.addAnnotations(annotations)
       
        let gr = UILongPressGestureRecognizer(target: self, action:#selector(longpress(gestureRecognizer:)))
        gr.minimumPressDuration = 2
        mapview.addGestureRecognizer(gr)
        search.becomeFirstResponder()    }
    
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer){
        
        let touchedPoint = gestureRecognizer.location(in: self.mapview)
        
        let coordinate = mapview.convert(touchedPoint, toCoordinateFrom: self.mapview)
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate
        
        pin.title = "Forth Location"
        
        pin.subtitle = "This is my next visit"
        
        mapview.addAnnotation(pin)
       loc = Labtest(context: self.context)
        loc.title = pin.title
        loc.subtitle = pin.title
        loc.latitude = pin.coordinate.latitude
        loc.longitude = pin.coordinate.longitude
        do{
            try self.context.save()
        }
        catch{
            print("Error in saving data to core data")
        }
    
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //guard is Capital else { return nil}
        let identifier="identifier"
        var annotationView=mapview.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        }
        else{
            annotationView?.annotation=annotation
        }
        return annotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let vc=storyboard?.instantiateViewController(identifier: "secondViewController") as? secondViewController
        do {
            results = try context.fetch(Labtest.fetchRequest())
            for storedLocation in results {
                if(storedLocation.title == view.annotation?.title)
                {
                    self.titleselected = String((view.annotation?.title)!!)
                    vc?.results1=storedLocation
                }
            }
        }
        catch {
            print("Fetching Failed")
        }
        vc?.check=true
        
        // pushing new view controller
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func getAnnotations()
    {
        do {
            results = try context.fetch(Labtest.fetchRequest())
             annotations = [MKAnnotation]()
            for storedLocation in results {
                let newAnnotation = MKPointAnnotation()
               newAnnotation.title=storedLocation.title
                newAnnotation.subtitle=storedLocation.subtitle
               newAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(storedLocation.latitude), longitude: CLLocationDegrees(storedLocation.longitude))
                annotations.append(newAnnotation)
            }
        }
        catch {
            print("Fetching Failed")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        mapview.removeAnnotations(annotations)
        self.getAnnotations()
        mapview.addAnnotations(annotations)
    }
}
    extension ViewController: UISearchBarDelegate {
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            for dataarr in results{
               if ( dataarr.title!.contains(searchText) ){
                  let latitudes:CLLocationDegrees = dataarr.latitude
                   let longitudes:CLLocationDegrees = dataarr.longitude
                      
                      
                   let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitudes, longitude: longitudes)
                      
                   
                
              

                                  let reg_x:CLLocationDegrees = 0.05
                    let reg_y:CLLocationDegrees = 0.05
                    
                    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: reg_x, longitudeDelta: reg_y)
                    let region: MKCoordinateRegion = MKCoordinateRegion(center: location , span: span)
                    mapview.setRegion(region, animated: true)
                    print(dataarr.title)
                  //  print(dataarr.subtitle!)
                  //  print(dataarr.latitude)
                    searchResults.append(dataarr.title!)
                
                  }
                
                
          else{
            print(results.count)
        }
             //   print(dataarr.title)
             //print(dataarr.subtitle!)
              // print(dataarr.latitude)
            }
                
        }
        func position(for bar: UIBarPositioning) -> UIBarPosition {
            return .topAttached
        }



    }
