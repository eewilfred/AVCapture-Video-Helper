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

protocol LiveVideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate  {

    var captureSession: AVCaptureSession? {get set}
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {get set}
    var videoDataOutput: AVCaptureVideoDataOutput? {get set}

    /// Must implement this on VC / View to avoid crash as per Apple docs
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection)
}

//MARK: Public API

extension LiveVideoCapture {

    /// To prepare for video playback
    /// - Parameter cameraPostion: camera you want to use to capture, Default is .unspecified (back camera if both are avilable)
    ///  - Note: This is a mandatory fuction, if this is not called playback will not work
    public func prepareForVideoCapture(on view: UIView?, cameraPostion: AVCaptureDevice.Position = .unspecified) {

        if Bundle.main.infoDictionary?["NSCameraUsageDescription"] == nil {
            fatalError(infoPlistEntryNotMade)
        }

        DispatchQueue.global().async { [weak self] in
            self?.initializeVideoCapture(cameraPostion)
            self?.showCameraFeed(on: view)
        }
    }

    /// To stop video session, must be called when view disappeared or video not needed
    public func stopSession() {

        if captureSession?.isRunning ?? false {
            DispatchQueue.global().async {
                self.captureSession?.stopRunning()
            }
        }
    }

    /// To start a video session for playback , call this when ever you need to start / restart video
    public func startSession() {

        if !(captureSession?.isRunning ?? true) {
            DispatchQueue.global().async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
    }

    /// To start video playback on the screen
    public func showCameraFeed(on view: UIView?) {

        guard let previewView = view,
        let previewLayer = videoPreviewLayer else {
            return
        }

         DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            previewView.layer.addSublayer(previewLayer)
            strongSelf.videoPreviewLayer?.frame = previewView.frame
        }
    }
}

//MARK: Private API

extension LiveVideoCapture {

    fileprivate func initializeVideoCapture(_ cameraPostion: AVCaptureDevice.Position) {

        captureSession = AVCaptureSession()
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoDataOutput = AVCaptureVideoDataOutput()
        videoPreviewLayer?.videoGravity = .resizeAspectFill

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
        captureSession?.addInput(cameraInput)
    }

    private func getCameraFrames() {

        videoDataOutput?.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoDataOutput?.alwaysDiscardsLateVideoFrames = true
        videoDataOutput?.setSampleBufferDelegate(
            self,
            queue: DispatchQueue(label: "live_Video_Preview")
        )
        if let outPut = videoDataOutput {
            captureSession?.addOutput(outPut)
        }
    }
}
