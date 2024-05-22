import SwiftUI

struct ActiveListingsMapView: View {
    @ObservedObject var viewModel: ListingViewModel
    @State private var selectedListing: ActiveListings.ListingResult?

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.results.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                MapView(listings: viewModel.results, selectedListing: $selectedListing)
//                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            viewModel.fetchListings(of: .active)
        }
        .sheet(item: $selectedListing) { listing in
            NavigationView {
                ListingDetailView(listing: listing)
            }
        }
    }
}
