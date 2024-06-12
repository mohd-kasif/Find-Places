//
//  ViewController.swift
//  Find Places
//
//  Created by Mohd Kashif on 12/06/24.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    lazy var mapView:MKMapView={
       let map=MKMapView()
        map.showsUserLocation=true
        map.delegate=self
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    //41, 20, 15
    lazy var textField:UITextField={
       let searchField=UITextField()
        searchField.placeholder="Search"
        searchField.backgroundColor = .white
        searchField.layer.cornerRadius=6
        searchField.delegate=self
        searchField.layer.borderColor = UIColor.black.cgColor
        searchField.layer.masksToBounds = false
        searchField.layer.shadowOffset = CGSize(width: 0, height: 0)
        searchField.layer.shadowOpacity = 0.7
        searchField.clipsToBounds=false
        searchField.layer.shadowRadius = 8
        searchField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchField.leftViewMode = .always
        searchField.translatesAutoresizingMaskIntoConstraints=false
        return searchField
    }()
    
    var locationManager:CLLocationManager?
    var places:[PlaceAnnotation]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager=CLLocationManager()
        locationManager?.delegate=self //  it delgetae it function to self meaning to ViewController itself
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        setupUI()
    }

    
    private func setupUI(){
        view.addSubview(textField)
        view.addSubview(mapView)

        view.bringSubviewToFront(textField)
        // add constraint to mapView
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive=true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive=true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        
        //add constraint to searchTextField
        
        textField.heightAnchor.constraint(equalToConstant: 50).isActive=true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        textField.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive=true
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive=true
        textField.returnKeyType = .go
    }
    
    private func checkAuthorization(){
        guard let locationManager=locationManager, let location=locationManager.location else {return}
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            focusLocation(location: location)
        case .restricted, .notDetermined:
            print("restricted")
        case .denied:
            print("denied")
        @unknown default:
            print("default")
        }
    }
    
    private func focusLocation(location:CLLocation){
        let region=MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        mapView.setRegion(region, animated: true)
    }
    
    private func presentSheet(places:[PlaceAnnotation]){
        guard let locationManager=locationManager, let location=locationManager.location else {return}
        let pageVC=PageSheetViewController(userLocation: location, places: places)
        pageVC.modalPresentationStyle = .pageSheet
        if let sheet=pageVC.sheetPresentationController{
            sheet.prefersGrabberVisible=true
            sheet.detents=[.medium(),.large()]
            present(pageVC, animated: true)
        }
    }
    
    private func findPlaces(by text:String){
        mapView.removeAnnotations(mapView.annotations)
        let request=MKLocalSearch.Request()
        request.naturalLanguageQuery=text
        request.region=mapView.region
        let search=MKLocalSearch(request: request)
        search.start {[weak self] response, error in
            guard let response=response, error==nil, let self=self else {return}
            places=response.mapItems.map(PlaceAnnotation.init)
            places.forEach { place in
                self.mapView.addAnnotation(place)
            }
            self.presentSheet(places:places)
        }
        
    }

}


extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
}

extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text=textField.text ?? ""
        if !text.isEmpty{
            textField.resignFirstResponder()
            findPlaces(by: text)
        }
        return true
    }
}


extension ViewController:MKMapViewDelegate{
    private func clearAllSelection(){
        self.places=self.places.map({ item in
            item.isSelected=false
            return item
        })
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        clearAllSelection()
        guard let selectAnnotation=annotation as? PlaceAnnotation else {return}
        let placeAnnoataion=self.places.first(where: {$0.id==selectAnnotation.id})
        placeAnnoataion?.isSelected=true
        self.presentSheet(places: self.places)
    }
}
