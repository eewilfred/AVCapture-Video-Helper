//
//  LiveVideoCapture.swift
//
//  Created by Edwin Wilson on 31/03/2020.
//
// Add This file to your project and use it as protocol

import UIKit
import AVFoundation

fileprivate let infoPlistEntryNotMade = """
 'Privacy - Camera Usage Description' , with value as reason for the access inside you application Info.plist as per Apple mandate
"""

//MARK:- UIView based VideoCapture protocol

protocol LiveVideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate where Self: UIView  {

    var captureSession: AVCaptureSession {get set}
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {get set}
    var videoDataOutput: AVCaptureVideoDataOutput {get set}

    /// Must implement this on VC / View to avoid crash as per Apple docs
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection)
}

//MARK: Public API

extension LiveVideoCapture {

    /// To start playBack Call this Function
    /// - Parameter cameraPostion: camera you want to use to capture, Default is .unspecified (back camera if both are avilable)
    public func prepareForVideoCapture(cameraPostion: AVCaptureDevice.Position = .unspecified) {

        if Bundle.main.infoDictionary?["NSCameraUsageDescription"] == nil {
            fatalError(infoPlistEntryNotMade)
        }

        initializeVideoCapture(cameraPostion)
        showCameraFeed()
    }

    /// To stop video session, must be called when view disappeared or video not needed
    public func stopSession() {

        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
    }

    /// To start a video playback , call this when ever you need to start / restart video
    public func startSession() {

        if !captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        }
    }
}

//MARK: Private API

extension LiveVideoCapture {

    private func showCameraFeed() {
        videoPreviewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.frame = frame
    }

    fileprivate func initializeVideoCapture(_ cameraPostion: AVCaptureDevice.Position) {

        addCameraInput(cameraPostion)
        getCameraFrames()
        startSession()
    }

    private func addCameraInput(_ cameraPostion: AVCaptureDevice.Position) {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: cameraPostion).devices.first else {
                fatalError("No supported camera Found")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }

    private func getCameraFrames() {
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(
            self,
            queue: DispatchQueue(label: "live_Video_Preview")
        )
        captureSession.addOutput(videoDataOutput)

        guard let connection = videoDataOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }
}
