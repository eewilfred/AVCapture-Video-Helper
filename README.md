# Easy Live Video

Protocol-based easy setup for enabling live video from camera on your view or view controller

## Usage:

**on your View Controller:**

Step 1:
 Confirm your view controller to `LiveVideoCaptureOnVC`
 
```swift
class ViewController: UIViewController, LiveVideoCaptureOnVC {}
```

Step 2: 
Allow xcode to fill all needed variables and methodes

step 3:
add intilizers (if you dont need custom intilizer use the example code)

```swift
class VideoView: UIView, LiveVideoCaptureOnVC {
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    lazy var videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    var videoDataOutput = AVCaptureVideoDataOutput()

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {}
}
```

step 4:
in the view didload or the place were you are plannig to start video playback call `prepareForVideoCapture()`

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForVideoCapture()
    }
```

step 5:
if View is getting dissapeared or needs to stop video,
call `stopSession()`

```swift
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }
```
step 6:
if video needs to be restarted,
call `startSession()`

```swift
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSession()
    }
```

------------

**On your View**

Step 1:
Conform your view to `LiveVideoCapture`
```swift
class VideoView: UIView, LiveVideoCapture {}
```
*follow step 2 and 3 as for view controller*

step 4:
place were you are plannig to start video playback call `prepareForVideoCapture()`

```swift
override init(frame: CGRect) {
        super.init(frame: frame)
        ///Use Front came
        prepareForVideoCapture(cameraPostion: .front)
    }
```

------------

For detailed information refer to the sample application.
