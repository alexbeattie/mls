import SwiftUI

struct ActiveListingsView: View {
    @State private var selectedListing: ActiveListings.ListingResult?
    @ObservedObject var viewModel: ListingViewModel
    @State private var lastIdVisible: String?
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.results.isEmpty {
                ShimmerEffect(cornerRadius: 10)
                    .frame(height: 200)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.results.isEmpty {
                Text("No active listings found.")
            } else {
                NavigationStack {
                    GeometryReader { proxy in
                        ScrollView {
                            ScrollViewReader { scrollView in
                                LazyVStack {
                                    ForEach(viewModel.results.indices, id: \.self) { index in
                                        let listing = viewModel.results[index]
                                        NavigationLink(destination: ListingDetailView(listing: listing)) {
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
                                                    //                                                        .shimmering()
                                                    
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
                                                    
                                                    Text("\(listing.StandardFields.ListAgentName ?? "Unknown")")
                                                        .padding(.horizontal)
                                                        .font(.system(size: 14, weight: .regular))
                                                        .foregroundColor(.gray)
                                                    
                                                }
                                            }
                                        }
                                        .padding()
                                        //                                        .frame(height: 200)
                                        .onAppear {
                                            if index == viewModel.results.count - 3 && viewModel.hasMoreData && !viewModel.isLoading {
                                                viewModel.fetchNextPage(of: .active)
                                                if let lastId = lastIdVisible {
                                                    scrollView.scrollTo(lastId, anchor: .bottom)
                                                }
                                            }
                                        }
                                        .onDisappear {
                                            lastIdVisible = listing.StandardFields.ListingId
                                        }
                                    }
                                    if viewModel.isLoading {
                                        //                                        ShimmerEffect(cornerRadius: 10)
                                        //                                            .frame(height: 200)
                                        //                                            .padding()
                                    }
                                }
                                .padding(.bottom, proxy.safeAreaInsets.bottom)
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedListing) { listing in
            NavigationStack {
                ListingDetailView(listing: viewModel.results.first { $0.StandardFields.ListingId == listing.id }!)
            }
        }
        .onAppear {
            viewModel.fetchListings(of: .active)
        }
    }
}
// Mock Data for Preview
class MockListingViewModel: ListingViewModel {
    override init(pageSize: Int = 5) {
        super.init(pageSize: pageSize)
        self.results = [
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

struct ActiveListingsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveListingsView(viewModel: MockListingViewModel())
    }
}