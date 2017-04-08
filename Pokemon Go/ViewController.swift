//
//  ViewController.swift
//  Pokemon Go
//
//  Created by Hudson Pereira on 08/04/17.
//  Copyright © 2017 Hudson Pereira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var counter = 0
    
    var coreDataPokemon: CoreDataPokemon!
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.coreDataPokemon = CoreDataPokemon()
        
        self.pokemons = self.coreDataPokemon.getAll()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let currentCoordinates = self.locationManager.location?.coordinate {
                let annotation = PokemonAnnotation()
                
                let index = arc4random_uniform(UInt32(self.pokemons.count))
                
                let pokemon = self.pokemons[Int(index)]
                
                annotation.pokemon = pokemon
                annotation.coordinate = currentCoordinates
                
                let randomLatitude = (Double(arc4random_uniform(400)) - 200) / 100000.0
                let randomLongitude = (Double(arc4random_uniform(400)) - 200) / 100000.0
                
                annotation.coordinate.latitude += randomLatitude
                annotation.coordinate.longitude += randomLongitude

                self.map.addAnnotation(annotation)
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        var frame = annotationView.frame
        
        
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        }else {
            if let pokemonAnnotation = annotation as? PokemonAnnotation {
                annotationView.image = UIImage(named: pokemonAnnotation.pokemon.image!)
            }
        }
        
        
        frame.size.width = 40
        frame.size.height = 40
        
        annotationView.frame = frame
        
        
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        if annotation is PokemonAnnotation {
            
            if let annotationCoordinates = annotation?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(annotationCoordinates, 200, 200)
                map.setRegion(region, animated: true)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                if let coordinates = self.locationManager.location?.coordinate {
                    if MKMapRectContainsPoint(self.map.visibleMapRect, MKMapPointForCoordinate(coordinates)) {
                        if let pokemonAnnotation = annotation as? PokemonAnnotation {
                            self.coreDataPokemon.catchPokemon(pokemon: pokemonAnnotation.pokemon)
                            
                            mapView.removeAnnotation(annotation!)
                            
                            let alert = UIAlertController(title: "Gotcha!", message: "You captured a \(String(describing: pokemonAnnotation.pokemon.name!))", preferredStyle: .alert)
                            let confirm = UIAlertAction(title: "Cool", style: .default, handler: nil)
                            
                            alert.addAction(confirm)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Get closer!", message: "You are too far", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        
                        alert.addAction(confirm)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.counter < 5 {
            self.centerUser()
            
            self.counter += 1
        } else {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            let alert = UIAlertController(title: "Permission", message: "Please authorize Geo Location to start catching'em all", preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: "Open config", style: .default, handler: { (action) in
                let url = NSURL(string: UIApplicationOpenSettingsURLString)! as URL
                
                UIApplication.shared.open(url)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(confirm)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func compassAction(_ sender: Any) {
        self.centerUser()
    }

    
    @IBAction func pokedexAction(_ sender: Any) {
    }
    
    func centerUser() {
        if let coordinates = self.locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinates, 200, 200)
            map.setRegion(region, animated: true)
        }
    }
}

