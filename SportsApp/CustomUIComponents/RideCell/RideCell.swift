//
//  RideCell.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import UIKit
import MapKit

// UITableViewCell, containing information about single ride.
class RideCell: UITableViewCell {
    public static let reuseIdentifier = "RideCell"
    
    private let usernameLabel = UILabel()
    private let nameLabel = UILabel()
    private let statisticsView = RideStatisticsView()
    private let mapView = MKMapView()
    private var polylines = [MKPolyline]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        configure()
        layoutUsernameLabel()
        layoutNameLabel()
        layoutStatisticsView()
        layoutMapView()
        layoutSeparator()
    }
    
    // MARK: - Configure functions
    private func configure() {
        usernameLabel.font = UIFont(name: "Jura-Bold", size: 16)
        nameLabel.font = UIFont(name: "Jura-Bold", size: 32)
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        selectionStyle = .none
    }
    
    // MARK: - Layout functions
    private func layoutUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
    }
    
    private func layoutNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
    }
    
    private func layoutStatisticsView() {
        addSubview(statisticsView)
        statisticsView.translatesAutoresizingMaskIntoConstraints = false
        statisticsView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        statisticsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        statisticsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func layoutMapView() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: statisticsView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func layoutSeparator() {
        let separator = UIView()
        separator.backgroundColor = Colors.gray3
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Setup functions
    public func setup(ride: Ride) {
        usernameLabel.text = ride.username
        nameLabel.text = ride.name
        var statistics = [Statistic]()
        for parameter in ride.parameters {
            statistics.append(parameter.getCorrespondingStatistic())
        }
        statisticsView.setup(statistics: statistics)
        if let route = ride.route {
            setupRoute(route: route)
        }
    }
    
    // Setups route and chooses right point of view for map.
    private func setupRoute(route: [[CLLocationCoordinate2D]]) {
        for polyline in polylines {
            mapView.removeOverlay(polyline)
        }
        polylines = [MKPolyline]()
        for segment in route {
            let polyline = MKPolyline(coordinates: segment, count: segment.count)
            mapView.addOverlay(polyline)
            polylines.append(polyline)
        }
        if let minimumLatitude = route.flatMap({ $0 }).map({ $0.latitude }).min(),
           let maximumLatitude = route.flatMap({ $0 }).map({ $0.latitude }).max(),
           let minimumLongitude = route.flatMap({ $0 }).map({ $0.longitude }).min(),
           let maximumLongitude = route.flatMap({ $0 }).map({ $0.longitude }).max() {
            let latitudinalMeters =
                CLLocation(latitude: minimumLatitude, longitude: minimumLongitude).distance(
                    from: CLLocation(latitude: maximumLatitude, longitude: minimumLongitude))
            let longitudinalMeters =
                CLLocation(latitude: minimumLatitude, longitude: minimumLongitude).distance(
                    from: CLLocation(latitude: minimumLatitude, longitude: maximumLongitude))
            let coordinateRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: (maximumLatitude + minimumLatitude) / 2,
                    longitude: (maximumLongitude + minimumLongitude) / 2),
                latitudinalMeters: latitudinalMeters * 1.5,
                longitudinalMeters: longitudinalMeters * 1.5)
            mapView.setRegion(coordinateRegion, animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MKMapViewDelegate implementation
extension RideCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = Colors.red
        renderer.lineWidth = 6
        return renderer
    }
}
