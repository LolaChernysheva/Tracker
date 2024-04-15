//
//  AnaliticService.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 15.04.2024.
//  
//

import Foundation
import AppMetricaCore

final class AnaliticService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "1d657765-10ed-433c-926e-68f0bb9303bc") else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func report(event: AnaliticsEvent, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event.rawValue, parameters: params, onFailure: { (error) in
            print("DID FAIL REPORT EVENT: %@", error.localizedDescription)
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

enum AnaliticsEvent: String {
    case open = "Open"
    case close = "Close"
    case click = "Click"
}
