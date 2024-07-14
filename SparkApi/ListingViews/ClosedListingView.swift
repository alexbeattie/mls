import SwiftUI

struct ClosedListingsView: View {
    @State private var selectedListing: ActiveListings.ListingResult?
    @ObservedObject var viewModel: ListingViewModel
    @State private var lastIdVisible: String?

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.closedListings.isEmpty {
                ProgressView()
                    .frame(height: 200)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.closedListings.isEmpty {
                Text("No closed listings found.")
            } else {
                GeometryReader { proxy in
                    ScrollView {
                        ScrollViewReader { scrollView in
                            LazyVStack {
                                ForEach(viewModel.closedListings.indices, id: \.self) { index in
                                    let listing = viewModel.closedListings[index]
                                    VStack(alignment: .leading) {
                                        AsyncImage(url: URL(string: listing.StandardFields.Photos?.first?.Uri800 ?? "")) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(height:200)
                                                    .cornerRadius(10)
                                                    .clipped()
                                            case .failure(_):
                                                ProgressView()
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 200)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(10)
                                                    .padding(.horizontal)
                                            case .empty:
                                                ProgressView()
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 200)
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(10)
                                                    .padding(.horizontal)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        
                                        VStack(alignment: .center) {
                                            Text(listing.StandardFields.UnparsedAddress ?? "No Address")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(.gray)
                                                .padding(.horizontal)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                            
                                            HStack {
                                                Label("\(listing.StandardFields.BedsTotal) Beds", systemImage: "bed.double")
                                                    .font(.system(size: 14, weight: .regular))
                                                    .foregroundColor(.gray)
                                                Label("\(listing.StandardFields.BathsFull) Baths", systemImage: "bathtub")
                                                    .font(.system(size: 14, weight: .regular))
                                                    .foregroundColor(.gray)
                                                Label("\(formatNumberWithoutDecimals(Double(listing.StandardFields.BuildingAreaTotal ?? 0))) sq ft",
                                                      systemImage: "ruler")
                                                    .font(.system(size: 14, weight: .regular))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("$\(listing.StandardFields.ListPrice ?? 0)")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(.gray)
                                                .padding(.horizontal)
                                            
                                            Text("\(listing.StandardFields.ListAgentName ?? "")")
                                                .padding(.horizontal)
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(.gray)
                                            MlsStatusView(listing: listing.StandardFields)

                                        }
                                    }
                                    .padding()
                                    .onTapGesture {
                                        selectedListing = listing
                                    }
                                    .onAppear {
                                        if index == viewModel.closedListings.count - 3 && viewModel.hasMoreData && !viewModel.isLoading {
                                            viewModel.fetchNextPage(of: .closed)
                                        }
                                    }
                                    .onDisappear {
                                        lastIdVisible = listing.StandardFields.ListingId
                                    }
                                }
                                if viewModel.isLoading {
                                    ProgressView()
                                        .frame(height: 200)
                                        .padding()
                                }
                            }
                            .padding(.bottom, proxy.safeAreaInsets.bottom)
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

// Mock Data for Preview
class MockClosedListingViewModel: ListingViewModel {
    override init(pageSize: Int = 5) {
        super.init(pageSize: pageSize)
        self.closedListings = [
            ActiveListings.ListingResult(
                Id: "1",
                ResourceUri: "uri",
                StandardFields: ActiveListings.StandardFields(
                    BathsFull: "2",
                    Latitude: .double(34.0522),
                    Longitude: .double(-118.2437),
                    BedsTotal: "3",
                    ListingId: "123",
                    BuildingAreaTotal: 1200,
                    ListAgentName: "John Doe",
                    CoListAgentName: "Jane Smith",
                    MlsStatus: "Closed", // Add mock MLS status

                    PostalCode: "322323",
                    UnparsedAddress: "123 Main St, Los Angeles, CA",
                    ListPrice: 1000000,

                    Photos: [
                        ActiveListings.StandardFields.PhotoDictionary(Id: "1", Name: "Photo 1", Uri800: "https://via.placeholder.com/800")
                    ]
                ),
                CustomFields: [],
                LastCachedTimestamp: "2023-01-01T00:00:00Z"
            )
            // Add more mock listings here if needed
        ]
    }
}

struct ClosedListingsView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedListingsView(viewModel: MockClosedListingViewModel())
    }
}
