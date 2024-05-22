import SwiftUI
import MapKit
import SwiftUI

import SwiftUI

struct ImageCarouselView: View {
    let photos: [ActiveListings.StandardFields.PhotoDictionary]
    
    var body: some View {
        TabView {
            ForEach(photos, id: \.Id) { photo in
                if let urlString = photo.Uri800, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ShimmerEffect()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ListingDetailView: View {
    let listing: ActiveListings.ListingResult
    @State private var showMapView = false
    @State private var directions: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let photos = listing.StandardFields.Photos {
                    ImageCarouselView(photos: photos)
                        .frame(height: 300)
                } else {
                    ShimmerEffect()
                        .frame(height: 300)
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack(alignment: .center, spacing: 8) {
                    Text(listing.StandardFields.UnparsedAddress ?? "No Address")
                        .font(.headline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack  {
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
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text("\(listing.StandardFields.ListAgentName ?? "Unknown")")
                        .padding(.horizontal)
                }
                
                Text(listing.StandardFields.PublicRemarks ?? "No Remarks")
                    .padding(.horizontal)
                
                if let lat = listing.StandardFields.Latitude?.doubleValue,
                                 let lon = listing.StandardFields.Longitude?.doubleValue {
                                  MapOfListingsView(listings: [listing], directions: $directions)
                                      .frame(height: 200)
                                      .cornerRadius(10)
                                      .padding(.horizontal)
                                  
                                  Button(action: {
                                      openDirectionsInMaps(latitude: lat, longitude: lon)
                                  }) {
                                      Text("Get Directions")
                                          .padding()
                                          .frame(maxWidth: .infinity)
                                          .background(Color.blue)
                                          .foregroundColor(.white)
                                          .cornerRadius(8)
                                  }
                                  .padding()
                              } else {
                                  Text("Location information not available.")
                                      .padding(.horizontal)
                              }
                
//                Button(action: {
//                    showMapView.toggle()
//                }) { 
//                    Text("View Full Map")
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding()
//                .sheet(isPresented: $showMapView) {
//                    FullMapView(listing: listing, directions: $directions)
//                }
                Spacer()
            }
        }
//        .edgesIgnoringSafeArea(.all)
    }
    private func openDirectionsInMaps(latitude: Double, longitude: Double) {
           let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)")!
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
}
func formatNumberWithoutDecimals(_ number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: number)) ?? ""
}
