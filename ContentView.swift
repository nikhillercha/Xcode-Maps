//
//  ContentView.swift
//  MeetXcode
//
//  Created by Nikhil Lercha on 19/07/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // Filtering state
    @State private var selectedCategories: Set<String> = []
    @State private var selectedEffortLevels: Set<String> = []

    // Adventures data
    @State private var adventures: [Adventure] = SampleAdventures.all
    @State private var currentIndex: Int = 0

    private var currentAdventure: Adventure { adventures[currentIndex] }
    
    private var allCategories: [String] { Array(Set(adventures.map { $0.category })).sorted() }
    private var allEffortLevels: [String] { Array(Set(adventures.map { $0.effortLevel })).sorted() }

    // Camera position centered on the marker
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: SampleAdventures.all.first?.latitude ?? 37.3349, longitude: SampleAdventures.all.first?.longitude ?? -122.0090),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Map(position: $position) {
                    Marker(currentAdventure.locationName, coordinate: currentAdventure.coordinate)
                }
                .ignoresSafeArea()

                // Floating info card
                VStack(alignment: .leading, spacing: 8) {
                    // Pills row
                    HStack(spacing: 8) {
                        Text(currentAdventure.category)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.blue.opacity(0.15)))
                            .foregroundStyle(.blue)
                        Text(currentAdventure.effortLevel)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.green.opacity(0.15)))
                            .foregroundStyle(.green)
                        Spacer(minLength: 0)
                    }

                    // Title
                    Text(currentAdventure.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    // Description
                    Text(currentAdventure.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)

                    // Status row with button bottom-right
                    HStack {
                        Spacer()
                        Button(action: {
                            adventures[currentIndex].isCompleted.toggle()
                        }) {
                            Label(currentAdventure.isCompleted ? "Completed" : "Mark Complete",
                                  systemImage: currentAdventure.isCompleted ? "checkmark.seal.fill" : "checkmark.seal")
                                .labelStyle(.titleAndIcon)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(currentAdventure.isCompleted ? .green : .accentColor)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 8)
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                // Floating Next Adventure button
                VStack {
                    Spacer()
                    Button(action: {
                        if !adventures.isEmpty {
                            currentIndex = (currentIndex + 1) % adventures.count
                            withAnimation(.easeInOut) {
                                position = .region(
                                    MKCoordinateRegion(
                                        center: currentAdventure.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                    )
                                )
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            Label("Next Adventure", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
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
