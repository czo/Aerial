//
//  Preferences.swift
//  Aerial
//
//  Created by John Coates on 9/21/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import ScreenSaver

// swiftlint:disable:next type_body_length
final class Preferences {

    // MARK: - Types

    fileprivate enum Identifiers: String {
        case differentAerialsOnEachDisplay = "differentAerialsOnEachDisplay"
        case multiMonitorMode = "multiMonitorMode"
        case cacheAerials = "cacheAerials"
        case customCacheDirectory = "cacheDirectory"
        case showDescriptions = "showDescriptions"
        case showDescriptionsMode = "showDescriptionsMode"
        case neverStreamVideos = "neverStreamVideos"
        case neverStreamPreviews = "neverStreamPreviews"
        case descriptionCorner = "descriptionCorner"

        case debugMode = "debugMode"
        case logToDisk = "logToDisk"
        case versionCheck = "versionCheck"
        case alsoVersionCheckBeta = "alsoVersionCheckBeta"
        case newVideosMode = "newVideosMode"
        case lastVideoCheck = "lastVideoCheck"
        case ciOverrideLanguage = "ciOverrideLanguage"
        case videoSets = "videoSets"
        case updateWhileSaverMode = "updateWhileSaverMode"
        case allowBetas = "allowBetas"
        case betaCheckFrequency = "betaCheckFrequency"

//        case newDisplayMode = "newDisplayMode"
//        case newViewingMode = "newViewingMode"
        case newDisplayDict = "newDisplayDict"
        case logMilliseconds = "logMilliseconds"
//        case horizontalMargin = "horizontalMargin"
//        case verticalMargin = "verticalMargin"
//        case displayMarginsAdvanced = "displayMarginsAdvanced"
//        case advancedMargins = "advancedMargins"

//        case synchronizedMode = "synchronizedMode"
//        case aspectMode = "aspectMode"
//        case useHDR = "useHDR"
    }

    enum BetaCheckFrequency: Int {
        case hourly, bidaily, daily
    }

    enum NewVideosMode: Int {
        case weekly, monthly, never
    }

//    enum SolarMode: Int {
//        case strict, official, civil, nautical, astronomical
//    }

    enum VersionCheck: Int {
        case never, daily, weekly, monthly
    }

    enum ExtraCorner: Int {
        case same, hOpposed, dOpposed
    }

    enum DescriptionCorner: Int {
        case topLeft, topRight, bottomLeft, bottomRight, random
    }

    enum MultiMonitorMode: Int {
        case mainOnly, mirrored, independant, secondaryOnly
    }

    /*enum VideoFormat: Int {
        case v1080pH264, v1080pHEVC, v4KHEVC
    }

    enum AlternateVideoFormat: Int {
        case powerSaving, v1080pH264, v1080pHEVC, v4KHEVC
    }*/

    enum DescriptionMode: Int {
        case fade10seconds, always
    }

    static let sharedInstance = Preferences()

    lazy var userDefaults: UserDefaults = {
        let module = "hu.czo.Aerial"

        guard let userDefaults = ScreenSaverDefaults(forModuleWithName: module) else {
            warnLog("Couldn't create ScreenSaverDefaults, creating generic UserDefaults")
            return UserDefaults()
        }

        return userDefaults
    }()

    // MARK: - Setup

    init() {
        registerDefaultValues()
    }

    func registerDefaultValues() {
        var defaultValues = [Identifiers: Any]()
        defaultValues[.differentAerialsOnEachDisplay] = false
        defaultValues[.cacheAerials] = true
        defaultValues[.showDescriptions] = true
        defaultValues[.showDescriptionsMode] = DescriptionMode.fade10seconds
        defaultValues[.neverStreamVideos] = false
        defaultValues[.neverStreamPreviews] = false
//        defaultValues[.timeMode] = TimeMode.disabled
//        defaultValues[.manualSunrise] = "09:00"
//        defaultValues[.manualSunset] = "19:00"
        defaultValues[.multiMonitorMode] = MultiMonitorMode.mainOnly
//        defaultValues[.fadeMode] = FadeMode.t1
//        defaultValues[.fadeModeText] = FadeMode.t1
        defaultValues[.descriptionCorner] = DescriptionCorner.bottomLeft
        defaultValues[.debugMode] = true
        defaultValues[.logToDisk] = true
        defaultValues[.versionCheck] = VersionCheck.weekly
        defaultValues[.alsoVersionCheckBeta] = false
//        defaultValues[.latitude] = ""
//        defaultValues[.longitude] = ""
//        defaultValues[.solarMode] = SolarMode.official
//        defaultValues[.overrideMargins] = false
//        defaultValues[.marginX] = 50
//        defaultValues[.marginY] = 50
//        defaultValues[.overrideOnBattery] = false
//        defaultValues[.powerSavingOnLowBattery] = false
//        defaultValues[.alternateVideoFormat] = AlternateVideoFormat.powerSaving
//        defaultValues[.darkModeNightOverride] = false
        defaultValues[.newVideosMode] = NewVideosMode.weekly
        defaultValues[.ciOverrideLanguage] = ""
        defaultValues[.videoSets] = [String: [String]]()
        defaultValues[.updateWhileSaverMode] = true
        defaultValues[.allowBetas] = false
        defaultValues[.betaCheckFrequency] = BetaCheckFrequency.daily
//        defaultValues[.newDisplayMode] = NewDisplayMode.allDisplays
//        defaultValues[.newViewingMode] = NewViewingMode.independent
        defaultValues[.newDisplayDict] = [String: Bool]()
        defaultValues[.logMilliseconds] = false
//        defaultValues[.horizontalMargin] = 0
//        defaultValues[.verticalMargin] = 0
//        defaultValues[.displayMarginsAdvanced] = false

//        defaultValues[.synchronizedMode] = false
//        defaultValues[.aspectMode] = AspectMode.fill
//        defaultValues[.useHDR] = false
//        defaultValues[.advancedMargins] = ""

        // Set today's date as default
        let dateFormatter = DateFormatter()
        let current = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: current)
        defaultValues[.lastVideoCheck] = today

        let defaults = defaultValues.reduce([String: Any]()) { (result, pair:(key: Identifiers, value: Any)) -> [String: Any] in
            var mutable = result
            mutable[pair.key.rawValue] = pair.value
            return mutable
        }

        userDefaults.register(defaults: defaults)
    }

    // MARK: - Variables
//    var advancedMargins: String? {
//        get {
//            return optionalValue(forIdentifier: .advancedMargins)
//        }
//        set {
//            setValue(forIdentifier: .advancedMargins, value: newValue)
//        }
//    }

    var videoSets: [String: [String]] {
        get {
            return userDefaults.dictionary(forKey: "videoSets") as! [String: [String]]
        }
        set {
            setValue(forIdentifier: .videoSets, value: newValue)
        }
    }

    var newDisplayDict: [String: Bool] {
        get {
            return userDefaults.dictionary(forKey: "newDisplayDict") as! [String: Bool]
        }
        set {
            setValue(forIdentifier: .newDisplayDict, value: newValue)
        }
    }

//    var displayMarginsAdvanced: Bool {
//        get {
//            return value(forIdentifier: .displayMarginsAdvanced)
//        }
//        set {
//            setValue(forIdentifier: .displayMarginsAdvanced, value: newValue)
//        }
//    }
//
//    var horizontalMargin: Double? {
//        get {
//            return optionalValue(forIdentifier: .horizontalMargin)
//        }
//        set {
//            setValue(forIdentifier: .horizontalMargin, value: newValue)
//        }
//    }
//
//    var verticalMargin: Double? {
//        get {
//            return optionalValue(forIdentifier: .verticalMargin)
//        }
//        set {
//            setValue(forIdentifier: .verticalMargin, value: newValue)
//        }
//    }

//    var aspectMode: Int? {
//        get {
//            return optionalValue(forIdentifier: .aspectMode)
//        }
//        set {
//            setValue(forIdentifier: .aspectMode, value: newValue)
//        }
//    }

//    var newDisplayMode: Int? {
//        get {
//            return optionalValue(forIdentifier: .newDisplayMode)
//        }
//        set {
//            setValue(forIdentifier: .newDisplayMode, value: newValue)
//        }
//    }

//    var newViewingMode: Int? {
//        get {
//            return optionalValue(forIdentifier: .newViewingMode)
//        }
//        set {
//            setValue(forIdentifier: .newViewingMode, value: newValue)
//        }
//    }

    var lastVideoCheck: String? {
        get {
            return optionalValue(forIdentifier: .lastVideoCheck)
        }
        set {
            setValue(forIdentifier: .lastVideoCheck, value: newValue)
        }
    }

    var betaCheckFrequency: Int? {
        get {
            return optionalValue(forIdentifier: .betaCheckFrequency)
        }
        set {
            setValue(forIdentifier: .betaCheckFrequency, value: newValue)
        }
    }

    var newVideosMode: Int? {
        get {
            return optionalValue(forIdentifier: .newVideosMode)
        }
        set {
            setValue(forIdentifier: .newVideosMode, value: newValue)
        }
    }

//    var alternateVideoFormat: Int? {
//        get {
//            return optionalValue(forIdentifier: .alternateVideoFormat)
//        }
//        set {
//            setValue(forIdentifier: .alternateVideoFormat, value: newValue)
//        }
//    }

//    var useHDR: Bool {
//        get {
//            return value(forIdentifier: .useHDR)
//        }
//        set {
//            setValue(forIdentifier: .useHDR, value: newValue)
//        }
//    }

//    var synchronizedMode: Bool {
//        get {
//            return value(forIdentifier: .synchronizedMode)
//        }
//        set {
//            setValue(forIdentifier: .synchronizedMode, value: newValue)
//        }
//    }

    var logMilliseconds: Bool {
        get {
            return value(forIdentifier: .logMilliseconds)
        }
        set {
            setValue(forIdentifier: .logMilliseconds, value: newValue)
        }
    }

    var allowBetas: Bool {
        get {
            return value(forIdentifier: .allowBetas)
        }
        set {
            setValue(forIdentifier: .allowBetas, value: newValue)
        }
    }

    var updateWhileSaverMode: Bool {
        get {
            return value(forIdentifier: .updateWhileSaverMode)
        }
        set {
            setValue(forIdentifier: .updateWhileSaverMode, value: newValue)
        }
    }

//    var darkModeNightOverride: Bool {
//        get {
//            return value(forIdentifier: .darkModeNightOverride)
//        }
//        set {
//            setValue(forIdentifier: .darkModeNightOverride, value: newValue)
//        }
//    }

//    var overrideOnBattery: Bool {
//        get {
//            return value(forIdentifier: .overrideOnBattery)
//        }
//        set {
//            setValue(forIdentifier: .overrideOnBattery, value: newValue)
//        }
//    }
//
//    var powerSavingOnLowBattery: Bool {
//        get {
//            return value(forIdentifier: .powerSavingOnLowBattery)
//        }
//        set {
//            setValue(forIdentifier: .powerSavingOnLowBattery, value: newValue)
//        }
//    }

//    var overrideMargins: Bool {
//        get {
//            return value(forIdentifier: .overrideMargins)
//        }
//        set {
//            setValue(forIdentifier: .overrideMargins, value: newValue)
//        }
//    }

//    var marginX: Int? {
//        get {
//            return optionalValue(forIdentifier: .marginX)
//        }
//        set {
//            setValue(forIdentifier: .marginX, value: newValue)
//        }
//    }
//
//    var marginY: Int? {
//        get {
//            return optionalValue(forIdentifier: .marginY)
//        }
//        set {
//            setValue(forIdentifier: .marginY, value: newValue)
//        }
//    }

//    var solarMode: Int? {
//        get {
//            return optionalValue(forIdentifier: .solarMode)
//        }
//        set {
//            setValue(forIdentifier: .solarMode, value: newValue)
//        }
//    }

    var debugMode: Bool {
        get {
            return value(forIdentifier: .debugMode)
        }
        set {
            setValue(forIdentifier: .debugMode, value: newValue)
        }
    }

    var logToDisk: Bool {
        get {
            return value(forIdentifier: .logToDisk)
        }
        set {
            setValue(forIdentifier: .logToDisk, value: newValue)
        }
    }

    var alsoVersionCheckBeta: Bool {
        get {
            return value(forIdentifier: .alsoVersionCheckBeta)
        }
        set {
            setValue(forIdentifier: .alsoVersionCheckBeta, value: newValue)
        }
    }

//    var showClock: Bool {
//        get {
//            return value(forIdentifier: .showClock)
//        }
//        set {
//            setValue(forIdentifier: .showClock, value: newValue)
//        }
//    }
//
//    var withSeconds: Bool {
//        get {
//            return value(forIdentifier: .withSeconds)
//        }
//        set {
//            setValue(forIdentifier: .withSeconds, value: newValue)
//        }
//    }
//
//    var showMessage: Bool {
//        get {
//            return value(forIdentifier: .showMessage)
//        }
//        set {
//            setValue(forIdentifier: .showMessage, value: newValue)
//        }
//    }

    var ciOverrideLanguage: String? {
        get {
            return optionalValue(forIdentifier: .ciOverrideLanguage)
        }
        set {
            setValue(forIdentifier: .ciOverrideLanguage, value: newValue)
        }
    }

//    var latitude: String? {
//        get {
//            return optionalValue(forIdentifier: .latitude)
//        }
//        set {
//            setValue(forIdentifier: .latitude, value: newValue)
//        }
//    }
//
//    var longitude: String? {
//        get {
//            return optionalValue(forIdentifier: .longitude)
//        }
//        set {
//            setValue(forIdentifier: .longitude, value: newValue)
//        }
//    }

//    var showMessageString: String? {
//        get {
//            return optionalValue(forIdentifier: .showMessageString)
//        }
//        set {
//            setValue(forIdentifier: .showMessageString, value: newValue)
//        }
//    }
//
    var differentAerialsOnEachDisplay: Bool {
        get {
            return value(forIdentifier: .differentAerialsOnEachDisplay)
        }
        set {
            setValue(forIdentifier: .differentAerialsOnEachDisplay, value: newValue)
        }
    }

    var cacheAerials: Bool {
        get {
            return value(forIdentifier: .cacheAerials)
        }
        set {
            setValue(forIdentifier: .cacheAerials, value: newValue)
        }
    }

    var neverStreamVideos: Bool {
        get {
            return value(forIdentifier: .neverStreamVideos)
        }
        set {
            setValue(forIdentifier: .neverStreamVideos, value: newValue)
        }
    }

    var neverStreamPreviews: Bool {
        get {
            return value(forIdentifier: .neverStreamPreviews)
        }
        set {
            setValue(forIdentifier: .neverStreamPreviews, value: newValue)
        }
    }

//    var fontName: String? {
//        get {
//            return optionalValue(forIdentifier: .fontName)
//        }
//        set {
//            setValue(forIdentifier: .fontName, value: newValue)
//        }
//    }

//    var fontSize: Double? {
//        get {
//            return optionalValue(forIdentifier: .fontSize)
//        }
//        set {
//            setValue(forIdentifier: .fontSize, value: newValue)
//        }
//
//    }
//
//    var extraFontName: String? {
//        get {
//            return optionalValue(forIdentifier: .extraFontName)
//        }
//        set {
//            setValue(forIdentifier: .extraFontName, value: newValue)
//        }
//    }
//
//    var extraFontSize: Double? {
//        get {
//            return optionalValue(forIdentifier: .extraFontSize)
//        }
//        set {
//            setValue(forIdentifier: .extraFontSize, value: newValue)
//        }
//
//    }
//    var manualSunrise: String? {
//        get {
//            return optionalValue(forIdentifier: .manualSunrise)
//        }
//        set {
//            setValue(forIdentifier: .manualSunrise, value: newValue)
//        }
//    }
//
//    var manualSunset: String? {
//        get {
//            return optionalValue(forIdentifier: .manualSunset)
//        }
//        set {
//            setValue(forIdentifier: .manualSunset, value: newValue)
//        }
//    }

    var customCacheDirectory: String? {
        get {
            return optionalValue(forIdentifier: .customCacheDirectory)
        }
        set {
            setValue(forIdentifier: .customCacheDirectory, value: newValue)
        }
    }

    var versionCheck: Int? {
        get {
            return optionalValue(forIdentifier: .versionCheck)
        }
        set {
            setValue(forIdentifier: .versionCheck, value: newValue)
        }
    }

    var descriptionCorner: Int? {
        get {
            return optionalValue(forIdentifier: .descriptionCorner)
        }
        set {
            setValue(forIdentifier: .descriptionCorner, value: newValue)
        }
    }

//    var extraCorner: Int? {
//        get {
//            return optionalValue(forIdentifier: .extraCorner)
//        }
//        set {
//            setValue(forIdentifier: .extraCorner, value: newValue)
//        }
//    }

//    var fadeMode: Int? {
//        get {
//            return optionalValue(forIdentifier: .fadeMode)
//        }
//        set {
//            setValue(forIdentifier: .fadeMode, value: newValue)
//        }
//    }
//
//    var fadeModeText: Int? {
//        get {
//            return optionalValue(forIdentifier: .fadeModeText)
//        }
//        set {
//            setValue(forIdentifier: .fadeModeText, value: newValue)
//        }
//    }

//    var timeMode: Int? {
//        get {
//            return optionalValue(forIdentifier: .timeMode)
//        }
//        set {
//            setValue(forIdentifier: .timeMode, value: newValue)
//        }
//    }

//    var videoFormat: Int? {
//        get {
//            return optionalValue(forIdentifier: .videoFormat)
//        }
//        set {
//            setValue(forIdentifier: .videoFormat, value: newValue)
//        }
//    }

    var showDescriptionsMode: Int? {
        get {
            return optionalValue(forIdentifier: .showDescriptionsMode)
        }
        set {
            setValue(forIdentifier: .showDescriptionsMode, value: newValue)
        }
    }

    var multiMonitorMode: Int? {
        get {
            return optionalValue(forIdentifier: .multiMonitorMode)
        }
        set {
            setValue(forIdentifier: .multiMonitorMode, value: newValue)
        }
    }

    var showDescriptions: Bool {
        get {
            return value(forIdentifier: .showDescriptions)
        }
        set {
            setValue(forIdentifier: .showDescriptions,
                     value: newValue)
        }
    }

    func videoIsInRotation(videoID: String) -> Bool {
        let key = "remove\(videoID)"
        let removed = userDefaults.bool(forKey: key)
        return !removed
    }

    func setVideo(videoID: String, inRotation: Bool,
                  synchronize: Bool = true) {
        let key = "remove\(videoID)"
        let removed = !inRotation
        userDefaults.set(removed, forKey: key)

        if synchronize {
            self.synchronize()
        }
    }

    // MARK: - Setting, Getting

    fileprivate func value(forIdentifier identifier: Identifiers) -> Bool {
        let key = identifier.rawValue
        return userDefaults.bool(forKey: key)
    }

    fileprivate func optionalValue(forIdentifier identifier: Identifiers) -> String? {
        let key = identifier.rawValue
        return userDefaults.string(forKey: key)
    }

    fileprivate func optionalValue(forIdentifier identifier: Identifiers) -> Int? {
        let key = identifier.rawValue
        return userDefaults.integer(forKey: key)
    }

    fileprivate func optionalValue(forIdentifier identifier: Identifiers) -> Double? {
        let key = identifier.rawValue
        return userDefaults.double(forKey: key)
    }

    fileprivate func setValue(forIdentifier identifier: Identifiers, value: Any?) {
        let key = identifier.rawValue
        if value == nil {
            userDefaults.removeObject(forKey: key)
        } else {
            userDefaults.set(value, forKey: key)
        }
        synchronize()
    }

    func synchronize() {
        userDefaults.synchronize()
    }
} //swiftlint:disable:this file_length
