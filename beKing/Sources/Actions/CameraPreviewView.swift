import SwiftUI
import AVFoundation

// This view is a wrapper around NSView that allows us to display a camera preview from an AVCaptureSession.
struct CameraPreviewView: NSViewRepresentable {
    let session: AVCaptureSession

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        view.layer = previewLayer
        
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
