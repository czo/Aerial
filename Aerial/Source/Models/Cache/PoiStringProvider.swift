//
//  PoiStringProvider.swift
//  Aerial
//
//  Created by Guillaume Louel on 13/10/2018.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

final class PoiStringProvider {
    static let sharedInstance = PoiStringProvider()
    var loadedDescriptions = false
    var loadedDescriptionsWasLocalized = false

    var stringBundle:Array<Bundle> = []
    var stringDict: [String: String]?

    // MARK: - Lifecycle
    init() {
        debugLog("Poi Strings Provider initialized")
        loadBundle()
//        loadCommunity()
    }

    // MARK: - Bundle management
    private func getBundleLanguages() -> [String] {
        // Might want to improve that...
        // This is a static list of what's supposed to be in the bundle
        // swiftlint:disable:next line_length
        return ["de", "he", "en_AU", "ar", "el", "ja", "en", "uk", "es_419", "zh_CN", "es", "pt_BR", "da", "it", "sk", "pt_PT", "ms", "sv", "cs", "ko", "no", "hu", "zh_HK", "tr", "pl", "zh_TW", "en_GB", "vi", "ru", "fr_CA", "fr", "fi", "id", "nl", "th", "pt", "ro", "hr", "hi", "ca"]
    }

    private func loadBundle() {
        // Idle string bundle
        let preferences = Preferences.sharedInstance
        let appSupportDirectory = VideoCache.appSupportDirectory!

        var bundlePath:Array<String> = []

        if preferences.ciOverrideLanguage == "" {
            debugLog("Preferred languages : \(Locale.preferredLanguages)")

            let bestMatchedLanguage = Bundle.preferredLocalizations(from: getBundleLanguages(), forPreferences: Locale.preferredLanguages).first
            if let match = bestMatchedLanguage {
                debugLog("Best matched language : \(match)")
                var bundlePath13 = appSupportDirectory
                bundlePath13.append(contentsOf: "/TVIdleScreenStrings13.bundle/" + match + ".lproj/")
                var bundlePath15 = appSupportDirectory
                bundlePath15.append(contentsOf: "/TVIdleScreenStrings15.bundle/" + match + ".lproj/")
                bundlePath.append( bundlePath15 )
                bundlePath.append( bundlePath13 )
            } else {
                debugLog("No match, reverting to english")
                // We load the bundle and let system grab the closest available preferred language
                // This no longer works in Catalina and defaults back to english
                // as legacyScreenSaver.appex, our new "mainbundle" is english only
                var bundlePath13 = appSupportDirectory
                bundlePath13.append(contentsOf: "/TVIdleScreenStrings13.bundle")
                var bundlePath15 = appSupportDirectory
                bundlePath15.append(contentsOf: "/TVIdleScreenStrings15.bundle")
                bundlePath.append( bundlePath15 )
                bundlePath.append( bundlePath13 )
            }
        } else {
            debugLog("Language overriden to \(String(describing: preferences.ciOverrideLanguage))")
            // Or we load the overriden one
            var bundlePath13 = appSupportDirectory
            bundlePath13.append(contentsOf: "/TVIdleScreenStrings13.bundle/" + preferences.ciOverrideLanguage! + ".lproj/")
            var bundlePath15 = appSupportDirectory
            bundlePath15.append(contentsOf: "/TVIdleScreenStrings15.bundle/" + preferences.ciOverrideLanguage! + ".lproj/")
            bundlePath.append( bundlePath15 )
            bundlePath.append( bundlePath13 )
        }

        var sourceStringDict : [String: String] = [:]

        for singleBundlePath in bundlePath {
            if let sb = Bundle.init(path: singleBundlePath) {
                let dictPath = singleBundlePath.appending("/Localizable.nocache.strings")

                if let sd = NSDictionary(contentsOfFile: dictPath) as? [String: String] {
                    sourceStringDict = sourceStringDict.merging(sd) { (current, new ) in new }
                    print(sd);
                }

                self.stringBundle.append(sb)
                self.loadedDescriptions = true
            } else {
                errorLog("\(singleBundlePath) is missing, please remove entries.json in Cache folder to fix the issue" )
            }
        }

        if ( !sourceStringDict.isEmpty ) {
            self.stringDict = sourceStringDict
        }
    }


    // Make sure we have the correct bundle loaded
    private func ensureLoadedBundle() -> Bool {
        if loadedDescriptions {
            return true
        } else {
            loadBundle()
            return loadedDescriptions
        }
    }

    // Return the Localized (or english) string for a key from the Strings Bundle
    func getString(key: String, video: AerialVideo) -> String {
        guard ensureLoadedBundle() else { return "" }

        /*let preferences = Preferences.sharedInstance
        let locale: NSLocale = NSLocale(localeIdentifier: Locale.preferredLanguages[0])

        if #available(OSX 10.12, *) {
            if preferences.localizeDescriptions && locale.languageCode != communityLanguage && preferences.ciOverrideLanguage == "" {
                return stringBundle!.localizedString(forKey: key, value: "", table: "Localizable.nocache")
            }
        }*/

        for sb in self.stringBundle {
            let retVal = sb.localizedString(forKey: key, value: "", table: "Localizable.nocache")
            if ( retVal != key ) {
                return retVal
            }
        }
        return key
    }

    // Return all POIs for an id
    func fetchExtraPoiForId(id: String) -> [String: String]? {
        print("fetchExtraPoiForId: ", id)
        guard let stringDict = stringDict, ensureLoadedBundle() else { return [:] }

        var found = [String: String]()
        for key in stringDict.keys where key.starts(with: id) {
            found[String(key.split(separator: "_").last!)] = key // FIXME: crash if key doesn't have "_"
        }
        return found
    }

    // 
    func getPoiKeys(video: AerialVideo) -> [String: String] {
        return video.poi
    }

    // Do we have any keys, anywhere, for said video ?
    func hasPoiKeys(video: AerialVideo) -> Bool {
        return !video.poi.isEmpty && loadedDescriptions
    }
}
