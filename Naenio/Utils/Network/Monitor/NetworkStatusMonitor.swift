//
//  NetworkMonitor.swift
//  Naenio
//
//  Created by 이영빈 on 2022/09/12.
//

import Network
import SwiftUI



class NetworkStatusMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var status: Status = .connected

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("We're connected!")
                    self.status = .connected

                } else {
                    print("No connection.")
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    // An enum to handle the network status
    enum Status: String {
        case connected
        case disconnected
    }
}
