import SwiftUI
import MapKit

struct MapOfListingsView: UIViewRepresentable {
    var listings: [ActiveListings.ListingResult]
    @Binding var directions: [String]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true // Show user location on the map
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        
        let annotations = listings.compactMap { listing -> MKPointAnnotation? in
            guard let lat = listing.StandardFields.Latitude?.doubleValue,
                  let lon = listing.StandardFields.Longitude?.doubleValue else { return nil }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.title = listing.StandardFields.City
            annotation.subtitle = listing.StandardFields.UnparsedAddress
            return annotation
        }
        uiView.addAnnotations(annotations)
        
        if let firstAnnotation = annotations.first {
            uiView.setRegion(MKCoordinateRegion(
                center: firstAnnotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
            
            // Add code to calculate route
            if let userLocation = uiView.userLocation.location {
                calculateRoute(from: userLocation.coordinate, to: firstAnnotation.coordinate, mapView: uiView)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func calculateRoute(from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: endPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response, let route = response.routes.first else { return }
            
            mapView.addOverlay(route.polyline)
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapOfListingsView

        init(_ parent: MapOfListingsView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
