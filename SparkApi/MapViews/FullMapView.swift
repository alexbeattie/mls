import SwiftUI
import MapKit

struct FullMapView: View {
    let listing: ActiveListings.ListingResult
    @Environment(\.presentationMode) var presentationMode
    @Binding var directions: [String]

    var body: some View {
        NavigationView {
            VStack {
                MapOfListingsView(listings: [listing], directions: $directions)
                    .edgesIgnoringSafeArea(.all)
                
                List(directions, id: \.self) { direction in
                    Text(direction)
                }
                .listStyle(PlainListStyle())
                
                .navigationBarItems(trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black) // Adjust the color as needed
                })
            }
        }
    }
}
