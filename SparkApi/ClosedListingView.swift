import SwiftUI

struct ClosedListingsView: View {
    @State private var selectedListing: ActiveListings.ListingResult?
    @ObservedObject var viewModel: ListingViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.closedListings.isEmpty {
                Text("No closed listings found.")
            } else {
                NavigationStack {
                    GeometryReader { proxy in
                        ZStack {
                            ScrollView {
                                ForEach(viewModel.closedListings, id: \.self) { listing in
                                    VStack {
                                        AsyncImage(url: URL(string: listing.StandardFields.Photos?.first?.Uri800 ?? "")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 200)
                                                .cornerRadius(0)
                                        } placeholder: {
                                            ShimmerEffect(cornerRadius: 0)
                                                .frame(height: 200)
                                        }
                                        .onTapGesture {
                                            selectedListing = listing
                                        }

                                        VStack(alignment: .leading) {
                                            Text(listing.StandardFields.UnparsedAddress ?? "")
                                                .font(.headline)
                                            HStack {
                                                Text(listing.StandardFields.ListAgentName ?? "")
                                                Text(listing.StandardFields.CoListAgentName ?? "")
                                            }
                                            Text("$\(listing.StandardFields.ListPrice ?? 0)")

                                        }
                                        .padding()
                                    }
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedListing) { listing in
            NavigationStack {
                ListingDetailView(listing: listing)
            }
        }
        .onAppear {
            viewModel.fetchListings(of: .closed)
        }
    }
}
