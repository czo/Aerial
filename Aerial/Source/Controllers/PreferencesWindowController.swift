//
//  PreferencesWindowController.swift
//  Aerial
//
//  Created by John Coates on 10/23/15.
//  Copyright © 2015 John Coates. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation
import ScreenSaver
import CoreLocation

@objc(PreferencesWindowController)
// swiftlint:disable:next type_body_length
final class PreferencesWindowController: NSWindowController, NSOutlineViewDataSource, NSOutlineViewDelegate {

    // Main UI
    @IBOutlet weak var prefTabView: NSTabView!
    @IBOutlet weak var downloadProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var downloadStopButton: NSButton!
    @IBOutlet var versionButton: NSButton!
    @IBOutlet var closeButton: NSButton!

    // Popovers
    @IBOutlet var popover: NSPopover!
    @IBOutlet var popoverH264Indicator: NSButton!
    @IBOutlet var popoverHEVCIndicator: NSButton!
    @IBOutlet var popoverH264Label: NSTextField!
    @IBOutlet var popoverHEVCLabel: NSTextField!
    @IBOutlet var secondProjectPageLink: NSButton!

    @IBOutlet var popoverTime: NSPopover!
    @IBOutlet var linkTimeWikipediaButton: NSButton!

    @IBOutlet var popoverPower: NSPopover!
    @IBOutlet var popoverUpdate: NSPopover!
    @IBOutlet var popoverWeather: NSPopover!

    // Videos tab
    @IBOutlet var outlineView: NSOutlineView!
    @IBOutlet var outlineViewSettings: NSButton!

    @IBOutlet var videoMenu: NSMenu!
    @IBOutlet var rightClickOpenQuickTimeMenuItem: NSMenuItem!
    @IBOutlet var rightClickDownloadVideoMenuItem: NSMenuItem!
    @IBOutlet var rightClickMoveToTrashMenuItem: NSMenuItem!

    @IBOutlet var videoSetsButton: NSButton!

    @IBOutlet var playerView: AVPlayerView!
    @IBOutlet var previewDisabledTextfield: NSTextField!

    @IBOutlet var fadeInOutModePopup: NSPopUpButton!
    @IBOutlet var popupVideoFormat: NSPopUpButton!

    @IBOutlet var menu1080pHDR: NSMenuItem!
    @IBOutlet var menu4KHDR: NSMenuItem!

    @IBOutlet var onBatteryPopup: NSPopUpButton!

    @IBOutlet var rightArrowKeyPlaysNextCheckbox: NSButton!
    //@IBOutlet var synchronizedModeCheckbox: NSButton!
    @IBOutlet var projectPageLink: NSButton!

    // Displays tab
    @IBOutlet var displayInstructionLabel: NSTextField!
    @IBOutlet var newDisplayModePopup: NSPopUpButton!
    @IBOutlet var newViewingModePopup: NSPopUpButton!
    @IBOutlet var aspectModePopup: NSPopUpButton!

    @IBOutlet var displayMarginBox: NSBox!
    @IBOutlet var horizontalDisplayMarginTextfield: NSTextField!
    @IBOutlet var verticalDisplayMarginTextfield: NSTextField!

    @IBOutlet var displayMarginAdvancedMode: NSButton!

    @IBOutlet var displayMarginAdvancedEdit: NSButton!

    // Info tab (replaces text)
    @IBOutlet var infoTableView: NSTableView!
    @IBOutlet var infoSettingsTableView: NSTableView!
    @IBOutlet var infoContainerView: InfoContainerView!

    @IBOutlet var infoBox: NSBox!

    @IBOutlet var infoSettingsView: InfoSettingsView!

    @IBOutlet var infoCommonView: InfoCommonView!

    @IBOutlet var infoLocationView: InfoLocationView!
    @IBOutlet var infoClockView: InfoClockView!
    @IBOutlet var infoMessageView: InfoMessageView!
    @IBOutlet var infoBatteryView: InfoBatteryView!
    @IBOutlet var infoCountdownView: InfoCountdownView!
    @IBOutlet var infoTimerView: InfoTimerView!
    @IBOutlet var infoDateView: InfoDateView!

    // Caches tab
    @IBOutlet var cacheAerialsAsTheyPlayCheckbox: NSButton!
    @IBOutlet var neverStreamVideosCheckbox: NSButton!
    @IBOutlet var neverStreamPreviewsCheckbox: NSButton!
    @IBOutlet var cacheLocation: NSPathControl!
    @IBOutlet weak var downloadNowButton: NSButton!
    @IBOutlet weak var cacheSizeTextField: NSTextField!

    // Updates Tab
    @IBOutlet var newVideosModePopup: NSPopUpButton!
    @IBOutlet var checkNowButton: NSButton!
    @IBOutlet var lastCheckedVideosLabel: NSTextField!

    // Advanced Tab
    @IBOutlet weak var debugModeCheckbox: NSButton!
    @IBOutlet weak var showLogBottomClick: NSButton!
    @IBOutlet weak var logToDiskCheckbox: NSButton!

    @IBOutlet var muteSoundCheckbox: NSButton!

    @IBOutlet var videoVersionsLabel: NSTextField!
    @IBOutlet var moveOldVideosButton: NSButton!
    @IBOutlet var trashOldVideosButton: NSButton!
    @IBOutlet var languagePopup: NSPopUpButton!
    @IBOutlet var currentLocaleLabel: NSTextField!

    // Video sets panel
    @IBOutlet var addVideoSetPanel: NSPanel!
    @IBOutlet var addVideoSetTextField: NSTextField!
    @IBOutlet var addVideoSetConfirmButton: NSButton!
    @IBOutlet var addVideoSetCancelButton: NSButton!
    @IBOutlet var addVideoSetErrorLabel: NSTextField!

    // Weather Panel
    @IBOutlet var weatherPanel: NSPanel!
    @IBOutlet var weatherCustomView: NSView!
    @IBOutlet var weatherLabel: NSTextField!

    // Log Panel
    @IBOutlet var logPanel: NSPanel!
    @IBOutlet weak var logTableView: NSTableView!

    // Quit confirmation Panel
    @IBOutlet var quitConfirmationPanel: NSPanel!

    // Change cache folder Panel
    @IBOutlet var changeCacheFolderPanel: NSPanel!
    @IBOutlet var cacheFolderTextField: NSTextField!

    @IBOutlet var displayMarginAdvancedPanel: NSPanel!
    @IBOutlet var displayMarginAdvancedTextfield: NSTextField!

    var player: AVPlayer = AVPlayer()

    var videos: [AerialVideo]?
    // cities -> time of day -> videos
    var cities = [City]()

    static var loadedJSON: Bool = false

    lazy var preferences = Preferences.sharedInstance

    let fontManager: NSFontManager
    var fontEditing = 0     // To track the font we are changing

    var highestLevel: ErrorLevel?  // To track the largest level of error received

    var savedBrightness: Float?

    // Info tab
    var infoSource: InfoTableSource?
    var infoSettingsSource: InfoSettingsTableSource?

    @IBOutlet var displayView: DisplayView!
    public var appMode: Bool = false

    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()

    required init?(coder decoder: NSCoder) {
        self.fontManager = NSFontManager.shared
        debugLog("pwc init1")
        super.init(coder: decoder)
    }

    // We start here from SysPref and App mode
    override init(window: NSWindow?) {
        self.fontManager = NSFontManager.shared
        debugLog("pwc init2")
        super.init(window: window)
    }

    // MARK: - Lifecycle
    // Before Sparkle tries to restart Aerial, we dismiss the sheet *and* quit System Preferences
    // This is required as killing Aerial will crash the preview outside of Aerial, in System Preferences
    @objc func sparkleWillRestart() {
        debugLog("Sparkle will restart, properly quitting")
        window?.sheetParent?.endSheet(window!)
        for app in NSWorkspace.shared.runningApplications where app.bundleIdentifier == "com.apple.systempreferences" {
            app.terminate()
        }
    }

    // sawiftlint:disable:next cyclomatic_complexity
    override func awakeFromNib() {
        super.awakeFromNib()

        // We register for the notification just before Sparkle tries to terminate Aerial

        // Setup the updates for the Logs
        let logger = Logger.sharedInstance
        logger.addCallback {level in
            self.updateLogs(level: level)
        }

        // Setup the updates for the download status
        let videoManager = VideoManager.sharedInstance
        videoManager.addCallback { done, total in
            self.updateDownloads(done: done, total: total, progress: 0)
        }
        videoManager.addProgressCallback { done, total, progress in
            self.updateDownloads(done: done, total: total, progress: progress)
        }

        loadJSON()  // Async loading

        logTableView.delegate = self
        logTableView.dataSource = self

        // Grab version from bundle
        if let version = Bundle(identifier: "hu.czo.TestPreferences")?.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionButton.title = version
        } else if let version = Bundle(identifier: "hu.czo.Aerial")?.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionButton.title = version
        }
        debugLog("Aerial control panel V\(versionButton.title)")

        setupVideosTab()
        setupDisplaysTab()
        setupInfoTab()
        setupCacheTab()
        setupUpdatesTab()
        setupAdvancedTab()

        colorizeProjectPageLinks()
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Workaround for garbled icons on non retina, we force redraw
        outlineView.reloadData()
        debugLog("wdl")
    }

    @IBAction func close(_ sender: AnyObject?) {
        // We ask for confirmation in case downloads are ongoing
        if !downloadProgressIndicator.isHidden {
            quitConfirmationPanel.makeKeyAndOrderFront(self)
        } else {
            // This seems needed for screensavers as our lifecycle is different
            // from a regular app and we may be kept in memory by System Preferences
            // and our settings won't get saved as they should be
            preferences.synchronize()

            logPanel.close()
            if appMode {
                NSApplication.shared.terminate(nil)
            } else {
                window?.sheetParent?.endSheet(window!)
            }
        }
    }

    @IBAction func confirmQuitClick(_ sender: Any) {
        quitConfirmationPanel.close()
        preferences.synchronize()
        logPanel.close()
        if appMode {
            NSApplication.shared.terminate(nil)
        } else {
            window?.sheetParent?.endSheet(window!)
        }
    }

    @IBAction func cancelQuitClick(_ sender: Any) {
        quitConfirmationPanel.close()
    }

    // MARK: - Setup

    fileprivate func colorizeProjectPageLinks() {
        let color = NSColor(calibratedRed: 0.18, green: 0.39, blue: 0.76, alpha: 1)
        var coloredLink = NSMutableAttributedString(attributedString: projectPageLink.attributedTitle)
        var fullRange = NSRange(location: 0, length: coloredLink.length)
        coloredLink.addAttribute(.foregroundColor, value: color, range: fullRange)
        projectPageLink.attributedTitle = coloredLink

        // We have an extra project link on the video format popover, color it too
        coloredLink = NSMutableAttributedString(attributedString: secondProjectPageLink.attributedTitle)
        fullRange = NSRange(location: 0, length: coloredLink.length)
        coloredLink.addAttribute(.foregroundColor, value: color, range: fullRange)
        secondProjectPageLink.attributedTitle = coloredLink

        // We have an extra project link on the video format popover, color it too
        coloredLink = NSMutableAttributedString(attributedString: linkTimeWikipediaButton.attributedTitle)
        fullRange = NSRange(location: 0, length: coloredLink.length)
        coloredLink.addAttribute(.foregroundColor, value: color, range: fullRange)
        linkTimeWikipediaButton.attributedTitle = coloredLink

        // We have an extra project link on the video format popover, color it too
        coloredLink = NSMutableAttributedString(attributedString: versionButton.attributedTitle)
        fullRange = NSRange(location: 0, length: coloredLink.length)
        coloredLink.addAttribute(.foregroundColor, value: color, range: fullRange)
        versionButton.attributedTitle = coloredLink

    }

    @IBAction func versionButtonClick(_ sender: Any) {
        let workspace = NSWorkspace.shared
        var url: URL
        url = URL( string: "https://github.com/czo/Aerial/releases" )!
        workspace.open(url)
    }

    // MARK: - Links

    @IBAction func pageProjectClick(_ button: NSButton?) {
        let workspace = NSWorkspace.shared
        let url = URL(string: "https://github.com/czo/Aerial")!
        workspace.open(url)
    }

    // MARK: - Manifest

    func loadJSON() {
        if PreferencesWindowController.loadedJSON {
            return
        }
        PreferencesWindowController.loadedJSON = true

        ManifestLoader.instance.addCallback { manifestVideos in
            self.loaded(manifestVideos: manifestVideos)
        }
    }

    func reloadJson() {
        ManifestLoader.instance.reloadFiles()
    }

    func loaded(manifestVideos: [AerialVideo]) {
        debugLog("Callback after manifest loading")
        var videos = [AerialVideo]()
        var cities = [String: City]()

        // Grab a fresh version, because our callback can be feeding us wrong data in CVC
        let freshManifestVideos = ManifestLoader.instance.loadedManifest
        //debugLog("freshManifestVideos count : \(freshManifestVideos.count)")

        // First day, then night
        for video in freshManifestVideos {
            let name = video.name

            if cities.keys.contains(name) == false {
                cities[name] = City(name: name)
            }
            let city = cities[name]!

            let timeOfDay = video.timeOfDay
            city.addVideoForTimeOfDay(timeOfDay, video: video)

            videos.append(video)
        }

        self.videos = videos

        // sort cities by name
        let unsortedCities = cities.values
        let sortedCities = unsortedCities.sorted { $0.name < $1.name }

        self.cities = sortedCities

        DispatchQueue.main.async {
            self.outlineView.reloadData()
            self.outlineView.expandItem(nil, expandChildren: true)
        }

        // We update the info in the advanced tab
        let (description, total) = ManifestLoader.instance.getOldFilesEstimation()
        videoVersionsLabel.stringValue = description
        if total > 0 {
            moveOldVideosButton.isEnabled = true
            trashOldVideosButton.isEnabled = true
        } else {
            moveOldVideosButton.isEnabled = false
            trashOldVideosButton.isEnabled = false
        }
    }
}
