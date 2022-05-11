//
//  TimeWorker.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 20.04.2022.
//

import Foundation
import UIKit

protocol TimeListener: AnyObject {
    func didUpdate(time: Int)
}

class TimeWorker {
    private static var eps = 0.001
    
    private var anchorDate: Date?
    private var status = TimerStatus.stopped
    private var timeBeforeAnchorDate: TimeInterval = 0.0
    private var listeners = [() -> TimeListener?]()
    
    init() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(enterBackground),
            name: UIScene.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(enterForeground),
            name: UIScene.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Public functions.
    func addListener(_ listener: TimeListener) {
        listeners.append({ [weak listener] in
            return listener
        })
    }
    
    func start() {
        if status == .stopped {
            status = .running
            anchorDate = Date()
            resumeTimeUpdation()
        }
    }
    
    func pause() {
        if status == .running {
            status = .stopped
            timeBeforeAnchorDate += getSecondsFromAnchorDate() ?? 0
        }
    }
    
    public var time: Int {
        return Int(floor(getSecondsFromStart()))
    }
    
    // MARK: - Background processing functions.
    @objc private func enterBackground() {
        if status == .running {
            status = .runningInBackground
        }
    }
    
    @objc private func enterForeground() {
        if status == .runningInBackground {
            status = .running
            resumeTimeUpdation()
        }
    }
    
    // MARK: - Time updation functions.
    private func resumeTimeUpdation() {
        guard status == .running else { return }
        let seconds = Int(floor(getSecondsFromStart()))
        for listener in listeners.map({ $0() }) {
            listener?.didUpdate(time: seconds)
        }
        scheduleNextUpdation()
    }
    
    private func scheduleNextUpdation() {
        let seconds = getSecondsFromStart()
        let difference = ceil(seconds) - seconds + Self.eps
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + difference) { [weak self] in
            self?.resumeTimeUpdation()
        }
    }
    
    // MARK: - Supporting functions and classes.
    private func getSecondsFromAnchorDate() -> TimeInterval? {
        if let anchorDate = anchorDate {
            return anchorDate.distance(to: Date())
        } else {
            return nil
        }
    }
    
    private func getSecondsFromStart() -> TimeInterval {
        if let secondsFromAnchorDate = getSecondsFromAnchorDate(), status != .stopped {
            return secondsFromAnchorDate + self.timeBeforeAnchorDate
        } else {
            return self.timeBeforeAnchorDate
        }
        
    }
    
    private enum TimerStatus {
        case stopped
        case running
        case runningInBackground
    }
}
