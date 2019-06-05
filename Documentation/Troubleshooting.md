# Troubleshooting

## Very common issues/macOS bugs

- "You cannot use the Aerial screen saver with this version of macOS." error: Select Aerial, close `System Preferences` with Aerial still selected, re-open System Preferences and Aerial should now work. This is a known bug with Swift screen savers in macOS/OS X reported (a long time ago...) to Apple as [rdar://25569037](http://www.openradar.me/25569037).
- "This app is damaged and can't be opened, you should move it to the trash" when double-clicking the `Aerial.saver` file: Please see the [installation notes](Installation.md), this is a GateKeeper issue.
- Chrome complains that "This download is uncommon and potentilally malicious" on very fresh releases. Google seems to flag very recent files as "uncommon" and may block the download (more info on [Google's site here](https://support.google.com/chrome/answer/6261569). After a few hours/days, this warning will disappear. More info in this [issue](https://github.com/JohnCoates/Aerial/issues/759#issuecomment-489616050).
- Can't use Aerial as a login screen saver: As far as we know, using 3rd party screen savers before login is no longer possible on modern versions of macOS (probably and rightly so for securoty reasons). More about this [here](https://github.com/JohnCoates/Aerial/issues/571).

## About custom videos

- After playing a video, Aerial is stuck on the last frame for a while and does not go to the next video : Please check that your video contains correct duration information. Some export tools may generate incorrect video files and Aerial will not be able to properly detect the end of the file. To fix your files, you will need to "remux" them using a tool such as Handbrake or MP4Box.

## About video caching

- Change cache location : This option simply changes _the location_ of the Cache folder that Aerial uses. It does _not_ move your files for you. Please note that this change will only be taken into account the next time Aerial starts (you may need to fully close System Preferences). We strongly recommend you use a path that's always accessible, as Aerial **can't work** without a Cache directory. In case the path is no longer available (missing USB key, etc), starting with Aerial 1.4.7, it will reset the Cache location to it's default location (usually `/Library/Caches/Aerial/` or, if unavailable `~/Library/Caches/Aerial`) to avoid crashing.
- Videos keeps disappearing, Aerial may not restart once in a while: Aerial stores all it's data in a Cache folder. This cache may get deleted by some third party software trying to free disk space. If you use such a "Cleaning" tool, we recommend you set a manual folder location in the Cache tab of Aerial. For example, you can create an Aerial folder in your User folder, and point to it. This will ensure Aerial files don't get deleted.
- Black screen: If you are behind a firewall (Like Little Snitch or Hands Off!) try creating exceptions for Aerial to allow it access to Apple's servers. Be sure the applications `ScreenSaverEngine.app` and `System Preferences.app` are not being blocked access to `*.phobos.apple.com`, `*.phobos.apple.com.edgesuite.net` and `sylvan.apple.com`. If that isn't an option, please look at the [Offline mode](OfflineMode.md) documentation.

## Bugs related to old versions
*Tip : you can see the version number in the bottom right corner of the preference panel. If you don't see a version number, your version is SEVERELY outdated (1.2 or below)!*

- "Done" button doesn't close Aerial: Please update to latest available version, this is a bug on Mojave with very old versions of Aerial (1.2 and below).
- Not seeing extended descriptions: Make sure you have version 1.4.2 or above.
- Can't type into text fields with macOS High Sierra/Video corruption issue on High Sierra: Please make sure you have at least version 1.4.5.
- Aerial logs you out of your user account everytime it starts: This looks like a new bug with macOS 10.14.5 beta 18F108f (similar to the Video corruption issue on High Sierra above), possibly only for Macs with Intel graphics. Please update to Aerial 1.5.0. More information here : https://github.com/JohnCoates/Aerial/issues/738

## Misc.

- Brightness control does not control external displays: Aerial uses the brightness API from macOS to change the brightness of your screens. As of version 1.5.0, this does not allow us to control the brightness of external screens.
- High CPU usage/fan spinning all of a sudden: If you correctly configured the preferred video format [according to your Mac](HardwareDecoding.md) and still experience high CPU usage/fan spinning all of a sudden, please look for the cause with `Activity Monitor`, you may see a `com.apple.photos.ImageConversionService` responsible for this CPU load. This is the iCloud Photos process, you can find more about [what it does here](https://support.apple.com/en-gu/HT204264) and how to pause it.

