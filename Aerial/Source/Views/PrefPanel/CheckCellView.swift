//
//  CheckCellView.swift
//  Aerial
//
//  Created by John Coates on 10/24/15.
//  Copyright © 2015 John Coates. All rights reserved.
//

import Cocoa

enum VideoStatus {
    case unknown, notAvailable, queued, downloading, downloaded
}

final class CheckCellView: NSTableCellView {

    @IBOutlet var checkButton: NSButton!
    @IBOutlet var formatLabel: NSTextField!
    @IBOutlet var mainTextField: NSTextField!

    var onCheck: ((Bool) -> Void)?
    var video: (AerialVideo)?
    var status = VideoStatus.unknown

    override required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        checkButton.target = self
        checkButton.action = #selector(CheckCellView.check(_:))
    }

    @objc func check(_ button: AnyObject?) {
        guard let onCheck = self.onCheck else {
            return
        }

        onCheck(checkButton.state == NSControl.StateValue.on)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    func adaptIndicators() {
        let videoManager = VideoManager.sharedInstance

            status = .notAvailable

        formatLabel.isHidden = !(video!.has4KVersion())
    }

    func updateProgressIndicator(progress: Double) {
        if status != .downloading {
            status = .downloading
        }
    }

    // Add video handling
    func setVideo(video: AerialVideo) {
        self.video = video
    }

    func markAsDownloaded() {
        status = .downloaded

        debugLog("Video download finished")
        video!.updateDuration()
    }

    func markAsNotDownloaded() {
        status = .notAvailable

        debugLog("Video download finished with error/cancel")
    }

    func markAsQueued() {
        debugLog("Queued \(video!)")
        status = .queued
    }

    func queueVideo() {
        let videoManager = VideoManager.sharedInstance
        videoManager.queueDownload(video!)
    }

    @IBAction func addClick(_ button: NSButton?) {
        queueVideo()
    }

}

final class VerticallyAlignedTextFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let newRect = NSRect(x: 0, y: (rect.size.height - 20) / 2, width: rect.size.width, height: 20)
        return super.drawingRect(forBounds: newRect)
    }
}
