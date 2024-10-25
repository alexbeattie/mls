import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var listings: [ActiveListings.ListingResult]
    @Binding var selectedListing: ActiveListings.ListingResult?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        
        let annotations = listings.map { listing -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = listing.StandardFields.UnparsedAddress
            annotation.subtitle = listing.StandardFields.ListAgentName
            annotation.coordinate = CLLocationCoordinate2D(latitude: listing.StandardFields.Latitude?.doubleValue ?? 0,
                                                            longitude: listing.StandardFields.Longitude?.doubleValue ?? 0)
            annotation.accessibilityLabel = listing.id // Assuming 'id' is unique for each listing
            return annotation
        }

        uiView.addAnnotations(annotations)

        if let firstAnnotation = annotations.first {
            let region = MKCoordinateRegion(center: firstAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            uiView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "ListingAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation as? MKPointAnnotation,
                  let listingId = annotation.accessibilityLabel,
                  let listing = parent.listings.first(where: { $0.id == listingId }) else { return }
            
            parent.selectedListing = listing
        }
    }
}
