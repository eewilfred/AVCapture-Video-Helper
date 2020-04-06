# AVCapture Video Helper

Protocol-based easy setup for enabling preview of live video from camera on your view, that cna be used for recording or processing

## Usage:


Step 1:
 Confirm your view / view controller to `LiveVideoCapture`
 
```swift
class ViewController: UIViewController, LiveVideoCapture {}
```

Step 2: 
Allow xcode to fill all needed variables and methodes

step 3:
add intilizers (if you dont need custom intilizer use the example code)

```swift
class ViewController: UIViewController, LiveVideoCapture {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var videoDataOutput: AVCaptureVideoDataOutput?

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {}
}
```

step 4:
in the view didload or the place were you are plannig to start video playback call `prepareForVideoCapture()`

```swift
    override func viewDidLoad() {
    
        super.viewDidLoad()
        prepareForVideoCapture(on: view)
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

For detailed information on how to add prototcol on view follow sample application `VideoView.swift`
