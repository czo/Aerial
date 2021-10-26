//
//  PWC+Updates.swift
//  Aerial
//      This is the controller code for the Updates Tab
//
//  Created by Guillaume Louel on 03/06/2019.
//  Copyright © 2019 John Coates. All rights reserved.
//

import Cocoa

extension PreferencesWindowController {
    func setupUpdatesTab() {
        newVideosModePopup.selectItem(at: preferences.newVideosMode!)

        betaCheckFrequencyPopup.selectItem(at: preferences.betaCheckFrequency!)

        lastCheckedVideosLabel.stringValue = "Last checked on " + preferences.lastVideoCheck!

        // Format date
    }

    // MARK: - Update panel
    @IBAction func newVideosModeChange(_ sender: NSPopUpButton) {
        debugLog("UI newVideosMode: \(sender.indexOfSelectedItem)")
        preferences.newVideosMode = sender.indexOfSelectedItem
    }

    @IBAction func betaCheckFrequencyChange(_ sender: NSPopUpButton) {
        debugLog("UI betaCheckFrequency: \(sender.indexOfSelectedItem)")
        preferences.betaCheckFrequency = sender.indexOfSelectedItem
    }

    @IBAction func popoverUpdateClick(_ button: NSButton) {
        popoverUpdate.show(relativeTo: button.preparedContentRect, of: button, preferredEdge: .maxY)
    }

    // Json updates
    @IBAction func checkNowButtonClick(_ sender: NSButton) {
        checkNowButton.isEnabled = false
        ManifestLoader.instance.addCallback(reloadJSONCallback)
        ManifestLoader.instance.reloadFiles()
    }

    func reloadJSONCallback(manifestVideos: [AerialVideo]) {
        checkNowButton.isEnabled = true
        lastCheckedVideosLabel.stringValue = "Last checked on " + preferences.lastVideoCheck!
    }
}
