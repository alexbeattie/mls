import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = ListingViewModel()
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
            
            
//            NewMapView(listings: Array(viewModel.results))  // Ensure this matches the NewMapView initializer
//                .tabItem {
//                    Image(systemName: "map")
//                    Text("Map")
//                }
//                .tag(1)
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
