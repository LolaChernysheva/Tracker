//
//  CreateTrackerScreenModel.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 14.02.2024.
//  
//

import UIKit

struct CreateTrackerScreenModel {
    let title: String
    let habitButtonTitle: String
    let eventButtonTitle: String
    let backGroundColor: UIColor
    
    static let empty: CreateTrackerScreenModel = .init(title: "", habitButtonTitle: "", eventButtonTitle: "", backGroundColor: .clear)
}
