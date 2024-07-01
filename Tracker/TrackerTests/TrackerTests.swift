//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Lolita Chernysheva on 23.04.2024.
//  
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        isRecording = false // Do not furget set to true when first test launch, and then set false. Snapshot tests work.
    }

    func testViewControllerLightMode() {
        let vc = Assembler.mainScreenBuilder()
        vc.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX, traits: .init(userInterfaceStyle: .light)), testName: "ViewControllerLightMode")
    }

    func testViewControllerDarkMode() {
        let vc = Assembler.mainScreenBuilder()
        vc.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX, traits: .init(userInterfaceStyle: .dark)), testName: "ViewControllerDarkMode")
    }

}
