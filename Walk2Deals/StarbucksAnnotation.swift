//
//  StarbucksAnnotation.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/16/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import MapKit

class StarbucksAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var idstr: String!
    var name: String!
    var email: String!
    var referenceID: String!
    var address: String!
    var image: URL!
    var isFromGoogle:Bool!
    var restaurantNumber:Int!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

