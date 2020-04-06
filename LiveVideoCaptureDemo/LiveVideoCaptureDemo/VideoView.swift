//
//  videoView.swift
//  LiveVideoCaptureDemo
//
//  Created by Edwin Wilson on 05/04/2020.
//  Copyright © 2020 Edwin Wilson. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView, LiveVideoCapture {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var videoDataOutput: AVCaptureVideoDataOutput?
    var captureSession: AVCaptureSession?

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        ///Use Front came
        prepareForVideoCapture(on: self, cameraPostion: .front)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
