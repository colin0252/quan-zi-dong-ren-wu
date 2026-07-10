import AVFoundation
import UIKit

class AudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    func startSilentAudio() {
        guard let url = Bundle.main.url(forResource: "silence", withExtension: "mp3") else {
            print("缺少 silence.mp3")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.01
            audioPlayer?.play()
            UIApplication.shared.isIdleTimerDisabled = true
        } catch {
            print("音频错误: \(error)")
        }
    }
}
