import SwiftUI
import MapKit
struct NewMapView: View {
    let listings: [Value] // Assuming the listings are of type `Value`
    @StateObject private var viewModel = ListingViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.144404, longitude: -118.872124), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        MapOfSoldListings()
    }
}


struct CarouselCell: View {
    let item: ListingAnno
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: item.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 100)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .trailing, spacing: 24) {
                Text(item.title)
                    .font(.system(size: 16, weight: .regular))
                
                    .lineLimit(1)
                    .foregroundColor(.black)

                Text(item.title)
                    .font(.system(size: 10, weight: .light))
                
                    .lineLimit(1)
                    .foregroundColor(.black)

                
                
            }

            .padding(.all, 16)
        }
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
        .onTapGesture {
            onTap()
        }
    }
}

struct SoldLocationsCarousel: View {
    @Binding var selectedItem: ListingAnno?
    @Binding var scrollToSelectedItem: Bool // Add this line

    var items: [ListingAnno]
    let onItemSelected: (ListingAnno) -> Void
//    let onZoomToItem: (SoldListingsAnno, Bool) -> Void // Updated closure parameter
    
    private let itemWidth: CGFloat = 300
    private let itemSpacing: CGFloat = 12
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: itemSpacing) {
                    ForEach(items) { item in
                        CarouselCell(
                            item: item,
                            isSelected: selectedItem?.id == item.id,
                            onTap: {
                                selectedItem = item
                                onItemSelected(item)
//                                onZoomToItem(item, true) // Pass true for animated zoom
                                withAnimation(.easeInOut) {
                                    proxy.scrollTo(item.id, anchor: .center)
                                }
                            }
                        )
                        .frame(width: itemWidth)
                        .id(item.id)
                    }
                }
                .padding(.horizontal, itemSpacing)
            }
            .onChange(of: selectedItem) { newValue in
                if let selectedItem = newValue {
                    onItemSelected(selectedItem)
//                    onZoomToItem(selectedItem, true) // Pass true for animated zoom
                }
            }
            .onChange(of: scrollToSelectedItem) { shouldScroll in // Add this block
                           if shouldScroll {
                               withAnimation {
                                   proxy.scrollTo(selectedItem?.id, anchor: .center)
                               }
                           }
                       }
        }
        .frame(height: 150)
        // Removed the onAppear that attempted to use `proxy` outside its closure
    }
}


struct MapOfSoldListings: View {
    @StateObject private var viewModel = ListingViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.144404, longitude: -118.872124), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var isAnimating = false
    @State private var scrollToSelectedItem = false

    @State private var mapLocation: ListingAnno?
    @State private var showLocationsList = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region, annotationItems: viewModel.listings) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        LocationMapAnnotationView()
                            .scaleEffect(viewModel.selectedItem == item ? 1 : 0.7)

//                        Image(systemName: viewModel.selectedItem?.id == item.id ? "mappin.circle.fill" : "mappin")
//                            .foregroundColor(viewModel.selectedItem?.id == item.id ? .red : .blue)
                            .onTapGesture {
                                viewModel.selectedItem = item
                                withAnimation {
                                    isAnimating = true
                                    scrollToSelectedItem = true // Add this line

                                }
                            }
                    }
                }
                
                
                SoldLocationsCarousel(
                    selectedItem: $viewModel.selectedItem,
                    scrollToSelectedItem: $scrollToSelectedItem, // Pass the binding

                    items: viewModel.listings,
                    onItemSelected: { selectedItem in
                        viewModel.selectedItem = selectedItem
                        withAnimation {
                            isAnimating = true
                        }
                    }
                )
            }
            .onAppear {
                viewModel.fetchSoldListings()
            }
            .onChange(of: isAnimating) { newValue in
                if newValue {
                    zoomToSelectedItem()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            isAnimating = false
                            scrollToSelectedItem = false // Add this line

                        }
                    }
                }
            }
//            .navigationTitle("Map of Previously Sold")
        }
    }
    func showNextLocation(item: ListingAnno) {
        withAnimation(.easeInOut) {
            mapLocation = item
            showLocationsList = false
        }
    }
    private func zoomToSelectedItem() {
        guard let selectedItem = viewModel.selectedItem else { return }
        
        let zoomRegion = MKCoordinateRegion(center: selectedItem.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        withAnimation(.easeInOut(duration: 0.5)) {
            region = zoomRegion
        }
    }
}

struct SoldCustomListingAnno: View {
    let item: ListingAnno
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .foregroundColor(isSelected ? .red : .blue)
            .scaleEffect(isSelected ? 1.5 : 1.0)
            .onTapGesture {
                onTap()
            }
    }
}
struct ListingAnno: Identifiable, Equatable, Hashable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let subtitle: Int
    let imageURL: URL?
    let address: String
    let listPrice: Int
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: listPrice)) ?? ""
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: Int, imageURL: URL?, address: String, listPrice: Int) {
        self.title = title.localizedCapitalized
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.address = address
        self.listPrice = listPrice
    }
    
    static func == (lhs: ListingAnno, rhs: ListingAnno) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
