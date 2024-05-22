import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = ListingViewModel(pageSize: 5) // Regular page size for listing views
    @StateObject var activeMapViewModel = ListingViewModel(pageSize: 50) // Larger page size for map view
    @StateObject var closedMapViewModel = ListingViewModel(pageSize: 50) // Larger page size for map view
    @State private var selectedTab = 0 // Set the initial tab programmatically
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ActiveListingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ClosedListingsView(viewModel: viewModel)
                .tabItem {
                    Label("Closed Listings", systemImage: "house")
                }
                .tag(1)
            
            ActiveListingsMapView(viewModel: activeMapViewModel)
                .tabItem {
                    Label("Active Map", systemImage: "map.fill")
                }
                .tag(2)
            
            ClosedListingsMapView(viewModel: closedMapViewModel)
                .tabItem {
                    Label("Closed Map", systemImage: "map")
                }
                .tag(3)
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
