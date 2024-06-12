//
//  DetailPageViewController.swift
//  Find Places
//
//  Created by Mohd Kashif on 12/06/24.
//

import Foundation
import UIKit
class DetailPageViewController:UIViewController{
    let place:PlaceAnnotation
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    lazy var name:UILabel={
        let label=UILabel()
        label.numberOfLines=0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font=UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    lazy var address:UILabel={
        let label=UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints=false
        label.font=UIFont.preferredFont(forTextStyle: .body)
        label.alpha=0.4
        return label
    }()
    
    var dirButton:UIButton={
        var config=UIButton.Configuration.bordered()
        let button=UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Direction", for: .normal)
        return button
    }()
    var callButton:UIButton={
        var config=UIButton.Configuration.bordered()
        let button=UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func getDirection(button:UIButton){
        let coordinate=place.location.coordinate
        guard let url=URL(string: "https://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else {return}
        
        UIApplication.shared.open(url)
    }
    @objc func makeCall(button:UIButton){
        print("button pressed")
        guard let url=URL(string: "tel://\(place.phone.removeSpecialChar)") else {return}
        UIApplication.shared.open(url)
    }
    func setupUI(){
        let stack=UIStackView()
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints=false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem
        stack.isLayoutMarginsRelativeArrangement=true
        stack.directionalLayoutMargins=NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        name.text=place.name
        address.text=place.address
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(address)
        name.widthAnchor.constraint(equalToConstant: view.bounds.width-20).isActive=true
        
        let hStack=UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints=false
        hStack.axis = .horizontal
        hStack.spacing = UIStackView.spacingUseSystem
        dirButton.addTarget(self, action: #selector(getDirection), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(makeCall), for: .touchUpInside)
        hStack.addArrangedSubview(dirButton)
        hStack.addArrangedSubview(callButton)
        stack.addArrangedSubview(hStack)
        view.addSubview(stack)
    }
}

extension String{
    var removeSpecialChar:String{
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: "*", with: "")
    }
}
