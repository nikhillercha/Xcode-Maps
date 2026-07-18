//
//  ContentView.swift
//  MeetXcode
//
//  Created by Nikhil Lercha on 19/07/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // Coordinate for the featured micro adventure (example: Apple Park)
    private let adventureCoordinate = CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090)
    
    // Camera position centered on the marker
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    // Filtering state
    @State private var selectedCategories: Set<String> = []
    @State private var selectedEffortLevels: Set<String> = []

    // Example options (customize as needed)
    private let allCategories: [String] = ["Parks", "Trails", "Museums", "Food"]
    private let allEffortLevels: [String] = ["Easy", "Moderate", "Hard"]

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                Marker("Start Here", coordinate: adventureCoordinate)
            }
            .ignoresSafeArea()
            .navigationTitle("Micro Adventures")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        // Categories section
                        Section("Categories") {
                            Button("Select All Categories") {
                                selectedCategories = Set(allCategories)
                            }
                            ForEach(allCategories, id: \.self) { category in
                                let isOn = selectedCategories.contains(category)
                                Button(action: {
                                    if isOn { selectedCategories.remove(category) } else { selectedCategories.insert(category) }
                                }) {
                                    Label(category, systemImage: isOn ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                        // Effort levels section
                        Section("Effort Levels") {
                            Button("Select All Effort Levels") {
                                selectedEffortLevels = Set(allEffortLevels)
                            }
                            ForEach(allEffortLevels, id: \.self) { level in
                                let isOn = selectedEffortLevels.contains(level)
                                Button(action: {
                                    if isOn { selectedEffortLevels.remove(level) } else { selectedEffortLevels.insert(level) }
                                }) {
                                    Label(level, systemImage: isOn ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                        // Clear all option
                        Section {
                            Button(role: .destructive) {
                                selectedCategories.removeAll()
                                selectedEffortLevels.removeAll()
                            } label: {
                                Label("Clear All Filters", systemImage: "xmark.circle")
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
