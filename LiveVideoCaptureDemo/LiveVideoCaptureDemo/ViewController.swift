//
//  ViewController.swift
//  LiveVideoCaptureDemo
//
//  Created by Edwin Wilson on 05/04/2020.
//  Copyright © 2020 Edwin Wilson. All rights reserved.
//
// video on viewController 

import UIKit
import AVFoundation

class ViewController: UIViewController, LiveVideoCapture {

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var videoDataOutput: AVCaptureVideoDataOutput?

    override func viewDidLoad() {

        super.viewDidLoad()
        prepareForVideoCapture(on: view)
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        stopSession()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        startSession()
    }

    /// If not added will crash (as per Apple docs)
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {}
}

