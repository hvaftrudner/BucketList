//
//  MKPointAnnotation-Object.swift
//  BucketList Examples
//
//  Created by Kristoffer Eriksson on 2021-04-14.
//

import MapKit

extension MKPointAnnotation: ObservableObject{
    public var wrappedTitle: String {
        get {
            self.title ?? "unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "unknown value"
        }
        set {
            subtitle = newValue
        }
    }
    
}
