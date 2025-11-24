import Foundation
import AVFoundation
import Combine

class AudioService: NSObject, ObservableObject, AVAudioPlayerDelegate {
    enum PermissionStatus {
        case unknown, granted, denied
    }

    // MARK: - Published Properties
    @Published var permissionStatus: PermissionStatus = .unknown
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var lastRecordingURL: URL?

    // MARK: - Private Properties
    private var audioEngine: AVAudioEngine?
    private var audioFile: AVAudioFile?
    private var audioPlayer: AVAudioPlayer?

    // MARK: - Initialization
    override init() {
        super.init()
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            self.permissionStatus = .granted
        case .denied, .restricted:
            self.permissionStatus = .denied
        case .notDetermined:
            self.permissionStatus = .unknown
        @unknown default:
            self.permissionStatus = .unknown
        }
    }

    deinit {
        if isRecording { stopRecording() }
    }

    // MARK: - Permissions
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
            DispatchQueue.main.async {
                self?.permissionStatus = granted ? .granted : .denied
            }
        }
    }
    
    // MARK: - Recording Logic
    func startRecording() {
        guard permissionStatus == .granted else { return }
        
        if isPlaying { stopPlayback() }
        
        audioEngine = AVAudioEngine()
        guard let engine = audioEngine else { return }
        
        let inputNode = engine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        guard recordingFormat.channelCount > 0 else {
            print("[beKing] Recording failed: Input node has zero channels.")
            return
        }
        
        // --- The Fix: Connect the audio graph ---
        // This is necessary on macOS to ensure the microphone's audio stream is active.
        let mainMixer = engine.mainMixerNode
        engine.connect(inputNode, to: mainMixer, format: recordingFormat)
        // We don't connect the mixer to the output, to avoid feedback. Tapping the input is sufficient.

        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("beking-recording-\(UUID().uuidString).caf")
        
        do {
            audioFile = try AVAudioFile(forWriting: fileURL, settings: recordingFormat.settings)
            
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, _) in
                do {
                    try self?.audioFile?.write(from: buffer)
                } catch {
                    print("[beKing] Error writing audio buffer to file: \(error)")
                }
            }
            
            engine.prepare()
            try engine.start()
            
            DispatchQueue.main.async {
                self.isRecording = true
                self.lastRecordingURL = nil
            }
            
        } catch {
            print("[beKing] Error starting recording setup: \(error.localizedDescription)")
            stopRecording()
        }
    }
    
    func stopRecording() {
        guard let engine = audioEngine, engine.isRunning else { return }
        
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        
        let url = audioFile?.url
        audioFile = nil
        self.audioEngine = nil
        
        DispatchQueue.main.async {
            self.isRecording = false
            self.lastRecordingURL = url
        }
    }

    // MARK: - Playback Logic
    func startPlayback() {
        guard let url = lastRecordingURL, !isRecording, !isPlaying else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            DispatchQueue.main.async {
                self.isPlaying = true
            }
        } catch {
            print("[beKing] Error starting playback: \(error.localizedDescription)")
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        // The delegate method will handle setting isPlaying to false.
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
}