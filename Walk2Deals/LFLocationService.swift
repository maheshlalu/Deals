
import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation, _ locationManager: CLLocationManager)
    func tracingLocationDidFailWithError(_ error: NSError)
    func tracingLocationDetails(_ currentLocationDetails: CLPlacemark)
}

class LFLocationService: NSObject, CLLocationManagerDelegate {
    static let sharedInstance: LFLocationService = {
        let instance = LFLocationService()
        return instance
    }()

    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?

    override init() {
        super.init()

        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()

        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
        }else{
            //MARK: AlertView for Locations
            
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        CXLog.print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        CXLog.print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }
        
        // singleton for get last(current) location
        currentLocation = location
        
        // use for real time update location
        updateLocation(location,manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // do on error
        updateLocationDidFailWithError(error as NSError)
    }
    
    // Private function
    fileprivate func updateLocation(_ currentLocation: CLLocation,_ locationManager: CLLocationManager){

        guard let delegate = self.delegate else {
            return
        }
        updateLocationDetails(currentLocation)
        delegate.tracingLocation(currentLocation,locationManager)
    }
    
    fileprivate func updateLocationDetails(_ currentLocation: CLLocation){
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) in
            if (error != nil) {
                CXLog.print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                self.locationManager?.stopUpdatingLocation()
                let pm = (placemarks?[0])! as CLPlacemark
               self.delegate?.tracingLocationDetails(pm)
                
            } else {
                CXLog.print("Problem with the data received from geocoder")
            }
        })

    }
    
    fileprivate func updateLocationDidFailWithError(_ error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error)
    }
}
