//
//  ContentView.swift
//  BucketList Examples
//
//  Created by Kristoffer Eriksson on 2021-04-11.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    
    @State private var showingEditScreen = false
    
    @State private var isUnlocked = false
    
    //challenge 3 alerts
    @State private var showingBioAlert = false
    @State private var bioAlertTitle = ""
    @State private var bioAlertMessage = ""
    
    var body: some View {
     
        ZStack{
            if isUnlocked {
                
                AccessView(centerCoordinate: $centerCoordinate, locations: $locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, showingEditScreen: $showingEditScreen)
                
            } else {
                //button here
                Button("Unlock Places"){
                    self.authenticate()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(Color.white)
                .clipShape(Capsule())
                
            }
        }
        .alert(isPresented: $showingBioAlert){
            Alert(title: Text(bioAlertTitle), message: Text(bioAlertMessage), dismissButton: .default(Text("ok")))
        }
        .onAppear(perform: loadData)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load data.")
        }
    }
    
    func authenticate(){
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Please authenticate yourself to unlock places"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        //error
                        self.showingBioAlert = true
                        self.bioAlertTitle = "Biometric Authententication Error"
                        self.bioAlertMessage = String(describing: authenticationError)
                    }
                }
            }
        } else {
            // no biometrics
            self.showingBioAlert = true
            self.bioAlertTitle = "No biometrics error"
            self.bioAlertMessage = "Your device has no biometric authentication"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

