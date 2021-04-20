//
//  AccessView.swift
//  BucketList Examples
//
//  Created by Kristoffer Eriksson on 2021-04-20.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct AccessView: View {
    
    @Binding var centerCoordinate : CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    @Binding var showingEditScreen: Bool
    
    var body: some View {
        
        ZStack{
            MapView(centerCoordinate: $centerCoordinate, annotations: locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.title = "New location"
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                        
                        self.selectedPlace = newLocation
                        self.showingEditScreen = true
                        
                    }) {
                        Image(systemName: "plus")
                            //modifiers here lets you press the whole circle
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(Color.white)
                            .font(.headline)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                    //modifiers here first, must press texture of image
                }
            }
        }
        .alert(isPresented: $showingPlaceDetails){
            Alert(title: Text(selectedPlace?.title ?? "unknown"), message: Text(selectedPlace?.subtitle ?? "missing place info"), primaryButton: .default(Text("ok")), secondaryButton: .default(Text("Edit")) {
                //Edit this place
                self.showingEditScreen = true
            })
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData){
            if self.selectedPlace != nil {
                EditView(placeMark: self.selectedPlace!)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveData(){
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("saved data")
        } catch {
            print("Unable to save data")
        }
    }
}
//
//struct AccessView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccessView()
//    }
//}
