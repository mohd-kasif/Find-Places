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
//        map.showsUserLocation=true
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    
    lazy var textField:UITextField={
       let searchField=UITextField()
        searchField.placeholder="Search"
        searchField.layer.cornerRadius=6
        searchField.clipsToBounds=true
        searchField.backgroundColor = .white
        searchField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchField.leftViewMode = .always
        searchField.translatesAutoresizingMaskIntoConstraints=false
        return searchField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
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

}

