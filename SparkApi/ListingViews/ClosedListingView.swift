import SwiftUI

struct ClosedListingsView: View {
    @State private var selectedListing: ActiveListings.ListingResult?
    @ObservedObject var viewModel: ListingViewModel
    @State private var lastIdVisible: String?

    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.closedListings.isEmpty {
                ShimmerEffect(cornerRadius: 10)
                    .frame(height: 200)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.closedListings.isEmpty {
                Text("No closed listings found.")
            } else {
                NavigationStack {
                    GeometryReader { proxy in
                        ScrollView {
                            ScrollViewReader { scrollView in
                                LazyVStack {
                                    ForEach(viewModel.closedListings.indices, id: \.self) { index in
                                        let listing = viewModel.closedListings[index]
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
                                        .padding(.bottom)
                                        .onAppear {
                                            if index == viewModel.closedListings.count - 3 && viewModel.hasMoreData && !viewModel.isLoading {
                                                viewModel.fetchNextPage(of: .closed)
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
                                        ShimmerEffect(cornerRadius: 10)
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
        }
        .sheet(item: $selectedListing) { listing in
            NavigationStack {
                ListingDetailView(listing: viewModel.closedListings.first { $0.StandardFields.ListingId == listing.id }!)
            }
        }
        .onAppear {
            viewModel.fetchListings(of: .closed)
        }
    }
}
