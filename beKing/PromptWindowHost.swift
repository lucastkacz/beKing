import Cocoa
import SwiftUI

final class PromptWindowHost {

    private var window: NSWindow?
    private let promptEngine = PromptEngine()
    private let audioService = AudioService()
    private let cameraService = CameraService()

    func show() {
        guard let prompt = promptEngine.nextPrompt() else {
            return
        }

                let view = PromptWindow(

                    prompt: prompt,

                    audioService: audioService,

                    cameraService: cameraService,

                    onLike: { [weak self] in

                        self?.promptEngine.recordLike(for: prompt)

                    },

                    onDislike: { [weak self] in

                        self?.promptEngine.recordDislike(for: prompt)

                    },

                    onSaveJournal: prompt.type == .journal ? { text in

                        let entry = JournalEntry(promptId: prompt.id, text: text)

                        JournalStore.append(entry)

                        NSLog("[beKing] Journal: saved inline entry for prompt \(prompt.id)")

                    } : nil,

                    onComplete: { [weak self] in

                        self?.close()

                    }

                )

        

                if let existingWindow = window,

                   let hosting = existingWindow.contentViewController as? NSHostingController<PromptWindow> {

                    hosting.rootView = view

                } else {

                    let hosting = NSHostingController(rootView: view)

                    let w = NSWindow(

                        contentRect: NSRect(x: 0, y: 0, width: 480, height: 320),

                        styleMask: [.titled, .closable, .miniaturizable],

                        backing: .buffered,

                        defer: false

                    )

                    w.center()

                    w.title = "beKing Prompt"

                    w.contentViewController = hosting

                    w.isReleasedWhenClosed = false

        

                    self.window = w

                }

        

                window?.makeKeyAndOrderFront(nil)

                NSApp.activate(ignoringOtherApps: true)

            }

        

            func close() {

                window?.performClose(nil)

            }

        }
