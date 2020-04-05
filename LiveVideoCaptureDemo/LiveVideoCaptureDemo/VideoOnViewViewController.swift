//
//  VideoOnViewViewController.swift
//  LiveVideoCaptureDemo
//
//  Created by Edwin Wilson on 05/04/2020.
//  Copyright © 2020 Edwin Wilson. All rights reserved.
//

import UIKit

class VideoOnViewViewController: UIViewController {

    let videoView = VideoView(frame: CGRect(x: 5, y: 50, width: 300, height: 400))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoView.stopSession()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoView.startSession()
    }
}
