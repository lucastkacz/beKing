import Foundation
import AVFoundation
import Combine
import AppKit // Required for NSImage

class CameraService: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    enum PermissionStatus {
        case unknown, granted, denied
    }

    // MARK: - Published Properties
    @Published var permissionStatus: PermissionStatus = .unknown
    @Published var capturedImage: NSImage?
    
    // MARK: - Session Management
    let session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()

    override init() {
        super.init()
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.permissionStatus = .granted
        case .denied, .restricted:
            self.permissionStatus = .denied
        case .notDetermined:
            self.permissionStatus = .unknown
        @unknown default:
            self.permissionStatus = .unknown
        }
        
        if permissionStatus == .granted {
            configureSession()
        }
    }

    // MARK: - Permissions
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.permissionStatus = granted ? .granted : .denied
                if granted {
                    self?.configureSession()
                }
            }
        }
    }
    
    // MARK: - Session Configuration
    private func configureSession() {
        session.beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoDeviceInput) else {
            print("[beKing] CameraService: Could not add video device input.")
            session.commitConfiguration()
            return
        }
        session.addInput(videoDeviceInput)
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        } else {
            print("[beKing] CameraService: Could not add photo output.")
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    // MARK: - Photo Capture
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        // The delegate method will be called when the photo is processed.
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("[beKing] CameraService: Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("[beKing] CameraService: Could not get image data.")
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = NSImage(data: imageData)
        }
    }

    func clearCapturedPhoto() {
        DispatchQueue.main.async {
            self.capturedImage = nil
        }
    }
}
