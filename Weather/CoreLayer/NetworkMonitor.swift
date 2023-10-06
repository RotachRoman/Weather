//
//  NetworkMonitor.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation
import Network

final class NetworkMonitor {
    
    //MARK: - Properties
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private(set) var isConnected: Bool = false
    
    private(set) var connectionType: ConnectionType = .unKnown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unKnown
    }
    
    // Initialization
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        }
        else {
            connectionType = .unKnown
        }
    }
    
    deinit {
        self.stopMonitoring()
    }
}
