import SwiftUI

struct ActionPromptView: View {
    @ObservedObject var audioService: AudioService
    let prompt: Prompt

    var body: some View {
        VStack(spacing: 20) {
            if audioService.permissionStatus == .granted {
                // Recording Controls
                if audioService.isRecording {
                    Button("Stop Recording") {
                        audioService.stopRecording()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Button("Start Recording") {
                        audioService.startRecording()
                    }
                    .disabled(audioService.isPlaying) // Disable while playing
                }
                
                // Playback Controls
                if audioService.lastRecordingURL != nil {
                    if audioService.isPlaying {
                        Button("Stop") {
                            audioService.stopPlayback()
                        }
                    } else {
                        Button("Play Recording") {
                            audioService.startPlayback()
                        }
                        .disabled(audioService.isRecording) // Disable while recording
                    }
                }

            } else if audioService.permissionStatus == .denied {
                Text("Microphone access was denied. Please grant permission in System Settings > Privacy & Security.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            } else {
                Button("Grant Microphone Access") {
                    audioService.requestPermission()
                }
            }
        }
        .padding(.vertical)
    }
}
