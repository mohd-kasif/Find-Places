//
//  PageSheetViewController.swift
//  Find Places
//
//  Created by Mohd Kashif on 12/06/24.
//

import Foundation
import UIKit
import MapKit
import SwiftUI
class PageSheetViewController:UITableViewController{
    
    var userLocation: CLLocation
    var places: [PlaceAnnotation]
    
    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        self.places.swapAt(indexOfSelected ?? 0, 0)
    }
    var indexOfSelected:Int?{
        self.places.firstIndex(where: {$0.isSelected==true})
    }
    
    func calculateDistance(from:CLLocation, to:CLLocation)->String{
        let distance=from.distance(from: to)
        return formatDistance(distance: distance)
        
        
    }
    func formatDistance(distance:CLLocationDistance)->String{
        let meters=Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .kilometers).formatted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place=places[indexPath.row]
        let vc=DetailPageViewController(place: place)
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row]
        
        // cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = calculateDistance(from: userLocation, to: place.location)
        
        cell.contentConfiguration = content
        cell.backgroundColor=place.isSelected ? .gray : .clear
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
