import SwiftUI

@main
struct AutoTaskApp: App {
    @StateObject private var audioManager = AudioManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    audioManager.startSilentAudio()
                }
        }
    }
}
