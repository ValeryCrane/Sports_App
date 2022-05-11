//
//  MapViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 16.04.2022.
//


import UIKit
import MapKit


// Protocol of display logic of MapViewController.
protocol MapDisplayLogic: UIViewController {
    func display(altitude: String)                      // Displays altitude.
    func display(speed: String)                         // Displays speed.
    func addPolyline(_ polyline: MKPolyline)            // Adds polyline.
    func removePolyline(_ polyline: MKPolyline)         // Removes polyline.
    // Updates polyline with new.
    func updatePolyline(_ polyline: MKPolyline, with newPolyline: MKPolyline)
    // Sets new overlaying ViewController for MapViewController
    func setOverlayingViewController(_ viewController: TouchTransparentViewController?)
}


// MARK: - MapViewController class.
class MapViewController: UIViewController {
    var interactor: MapBusinessLogic!
    
    private let mapView = MKMapView()
    private var overlayingViewController: TouchTransparentViewController?
    
    private let parametersStackView = TouchTransparentStackView()
    private let altitudeLabel = UILabel()
    private let speedLabel = UILabel()

    // MARK: - ViewController's life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Record"
        view.backgroundColor = Colors.gray2
        
        configureMapView()
        layoutMapView()
        configureParametersStack()
        layoutParametersStack()
        
        setOverlayingViewController(StartRecordAssembly().assemble())
        mapView.setRegion(MKCoordinateRegion(
            center: CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(),
            latitudinalMeters: 256,
            longitudinalMeters: 256), animated: false)
    }
    
    // MARK: - Configuration functions.
    private func configureMapView() {
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func configureParametersStack() {
        parametersStackView.axis = .horizontal
        parametersStackView.spacing = 16
        
        altitudeLabel.text = "214m"
        speedLabel.text = "0.0km/h"
        let altitudeView = createParameterView(image: UIImage(named: "altitude"), label: altitudeLabel)
        let speedView = createParameterView(image: UIImage(named: "speed"), label: speedLabel)
        
        parametersStackView.addArrangedSubview(altitudeView)
        parametersStackView.addArrangedSubview(speedView)
    }
    
    // MARK: - Layout functions.
    private func layoutMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func layoutParametersStack() {
        let scrollView = TouchTransparentScrollView()
        scrollView.layer.masksToBounds = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(parametersStackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        parametersStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 40),
            
            parametersStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            parametersStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            parametersStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            parametersStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            parametersStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // REFACTOR AND MAKE CUSTOM UIVIEW ! ! ! ! ! ! !
    private func createParameterView(image: UIImage?, label: UILabel) -> UIView {
        let parameterView = UIView()
        parameterView.backgroundColor = Colors.gray1
        parameterView.layer.cornerRadius = 4
        parameterView.layer.shadowColor = UIColor.black.cgColor
        parameterView.layer.shadowOffset = .zero
        parameterView.layer.shadowRadius = 8
        parameterView.layer.shadowOpacity = 0.1
        
        let imageView = UIImageView(image: image)
        label.font = UIFont(name: "Jura-Bold", size: 16)
        parameterView.addSubview(imageView)
        parameterView.addSubview(label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.leadingAnchor.constraint(equalTo: parameterView.leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: parameterView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: parameterView.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: parameterView.centerYAnchor)
        ])
        
        return parameterView
    }
}


// MARK: - MapDisplayLogic implementation.
extension MapViewController: MapDisplayLogic {
    func setOverlayingViewController(_ viewController: TouchTransparentViewController?) {
        if let overlayingViewController = overlayingViewController {
            overlayingViewController.willMove(toParent: nil)
            overlayingViewController.view.removeFromSuperview()
            overlayingViewController.removeFromParent()
        }
        if let viewController = viewController {
            addChild(viewController)
            view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            self.overlayingViewController = viewController
            layoutOverlayingViewController()
        }
    }
    
    private func layoutOverlayingViewController() {
        guard let overlayingView = overlayingViewController?.view else { return }
        overlayingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overlayingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            overlayingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addPolyline(_ polyline: MKPolyline) {
        mapView.addOverlay(polyline)
    }
    
    func removePolyline(_ polyline: MKPolyline) {
        mapView.removeOverlay(polyline)
    }
    
    func updatePolyline(_ polyline: MKPolyline, with newPolyline: MKPolyline) {
        removePolyline(polyline)
        addPolyline(newPolyline)
    }
    
    func display(altitude: String) {
        altitudeLabel.text = altitude
    }
    
    func display(speed: String) {
        speedLabel.text = speed
    }
}


// MARK: - MKMapViewDelegate implementation.
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = Colors.red
        renderer.lineWidth = 6
        return renderer
    }
}



