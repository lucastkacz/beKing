import SwiftUI

struct ActionPromptView: View {
    @ObservedObject var audioService: AudioService
    @ObservedObject var cameraService: CameraService
    let prompt: Prompt
    let onComplete: () -> Void

    @State private var isCompleting = false

    // A simple way to decide which UI to show
    private var isCameraPrompt: Bool {
        let text = prompt.text.lowercased()
        return text.contains("smile") || text.contains("photo") || text.contains("picture")
    }

    var body: some View {
        Group {
            if isCameraPrompt {
                cameraView
            } else {
                microphoneView
            }
        }
        .padding(.vertical)
    }

    // MARK: - Camera UI
    @ViewBuilder
    private var cameraView: some View {
        VStack(spacing: 15) {
            if isCompleting {
                Text("Great!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .frame(height: 200)
            } else if cameraService.permissionStatus == .granted {
                ZStack {
                    if let image = cameraService.capturedImage {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        CameraPreviewView(session: cameraService.session)
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                HStack {
                    if cameraService.capturedImage != nil {
                        Button("Retake") {
                            cameraService.clearCapturedPhoto()
                        }
                        Spacer()
                        Button("Use Photo") {
                            completeAction()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Spacer()
                        Button("Capture") {
                            cameraService.capturePhoto()
                        }
                        Spacer()
                    }
                }

            } else if cameraService.permissionStatus == .denied {
                Text("Camera access was denied. Please grant permission in System Settings > Privacy & Security.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            } else {
                Button("Grant Camera Access") {
                    cameraService.requestPermission()
                }
            }
        }
    }

    // MARK: - Microphone UI
    @ViewBuilder
    private var microphoneView: some View {
        VStack(spacing: 20) {
            // ... (microphone UI remains the same)
        }
    }

    private func completeAction() {
        isCompleting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            onComplete()
        }
    }
}
