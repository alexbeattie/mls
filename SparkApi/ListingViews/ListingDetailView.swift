import SwiftUI
import MapKit
import SwiftUI

import SwiftUI
//struct WebsiteLinkView: View {
//    let value: ActiveListings.StandardFields.Documents
//    
//    var body: some View {
//        HStack {
//            if let documentMedia = value.StandardFields.(where: { $0.MediaCategory == "Document" }),
//               let mediaURL = documentMedia.MediaURL {
//                Link(destination: URL(string: mediaURL)!) {
//                    Label("Download Document", systemImage: "arrow.down.doc")
//                }
//            }
//        }
//    }
//}

struct FeatureSection: View {
    let title: String
    let features: [String]
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
            Divider()
            ForEach(expanded ? features : Array(features.prefix(3)), id: \.self) { feature in
                Text(feature)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if features.count > 3 {
                Button(action: {
                    expanded.toggle()
                }) {
                    Text(expanded ? "Show Less" : "Show More")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .background(ignoresSafeAreaEdges: .all)
        .frame(width: 200)
    }
}

//struct PropertyDescriptionView: View {
//    let value: [ActiveListings.CustomFields]
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//           
//           
//            
////            VStack {
////                WebsiteLinkView(value: value)
////            }
////            .padding(.vertical)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(alignment: .top) {
//                    if let amenities = value.first?.main?.first?.associationAmenities, !amenities.isEmpty {
//                        FeatureSection(title: "Association Amenities", features: amenities)
//                    }
//                    
//                    if let communityFeatures = value.CommunityFeatures, !communityFeatures.isEmpty {
//                        FeatureSection(title: "Community Features", features: communityFeatures)
//                    }
//                    
//                    if let lotFeatures = value.LotFeatures, !lotFeatures.isEmpty {
//                        FeatureSection(title: "Lot Features", features: lotFeatures)
//                    }
//                    
//                    if let lotDisclosures = value.Disclosures, !lotDisclosures.isEmpty {
//                        FeatureSection(title: "Disclosures", features: lotDisclosures)
//                    }
//                    
//                    if let constructionMaterials = value.ConstructionMaterials, !constructionMaterials.isEmpty {
//                        FeatureSection(title: "Materials", features: constructionMaterials)
//                    }
//                    
//                    if let coolingSystem = value.Cooling, !coolingSystem.isEmpty {
//                        FeatureSection(title: "Cooling", features: coolingSystem)
//                    }
//                    
//                    if let heatingSystem = value.Heating, !heatingSystem.isEmpty {
//                        FeatureSection(title: "Heating", features: heatingSystem)
//                    }
//                    
//                    if let interiorFeatures = value.InteriorFeatures, !interiorFeatures.isEmpty {
//                        FeatureSection(title: "Interior", features: interiorFeatures)
//                    }
//                    
//                    if let viewFeatures = value.View, !viewFeatures.isEmpty {
//                        FeatureSection(title: "View Features", features: viewFeatures)
//                    }
//                    
//                    if let windowFeatures = value.WindowFeatures, !windowFeatures.isEmpty {
//                        FeatureSection(title: "Window Features", features: windowFeatures)
//                    }
//                    
//                    if let applianceFeatures = value.Appliances, !applianceFeatures.isEmpty {
//                        FeatureSection(title: "Appliances", features: applianceFeatures)
//                    }
//                }
//                .padding(.leading, 0) // Remove the leading padding
//            }
//        }
//    }
//}
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
