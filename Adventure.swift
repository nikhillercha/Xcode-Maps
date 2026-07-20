import Foundation
import CoreLocation

struct Adventure: Identifiable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var category: String
    var effortLevel: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, description: String, category: String, effortLevel: String, locationName: String, latitude: Double, longitude: Double, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.effortLevel = effortLevel
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.isCompleted = isCompleted
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum SampleAdventures {
    static let all: [Adventure] = [
        Adventure(title: "Apple Park Loop", description: "A scenic loop around Apple Park with viewpoints and shaded paths. Great for a short walk.", category: "Parks", effortLevel: "Easy", locationName: "Apple Park", latitude: 37.3349, longitude: -122.0090, isCompleted: false),
        Adventure(title: "Mission Peak", description: "A challenging hike with rewarding views over the Bay Area.", category: "Trails", effortLevel: "Hard", locationName: "Fremont", latitude: 37.5125, longitude: -121.8803, isCompleted: false),
        Adventure(title: "Shoreline Lake", description: "Leisurely walk by the lake with options for kayaking and bird watching.", category: "Parks", effortLevel: "Easy", locationName: "Mountain View", latitude: 37.4300, longitude: -122.0870, isCompleted: true),
        Adventure(title: "SF Museum Crawl", description: "Explore a few museums in San Francisco in a single afternoon.", category: "Museums", effortLevel: "Moderate", locationName: "San Francisco", latitude: 37.7857, longitude: -122.4011, isCompleted: false),
        Adventure(title: "Food Truck Night", description: "Taste your way through a rotating lineup of food trucks.", category: "Food", effortLevel: "Easy", locationName: "San Jose", latitude: 37.3382, longitude: -121.8863, isCompleted: false)
    ]
}
