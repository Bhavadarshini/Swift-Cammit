import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var secondsRemaining: Int = 0
    @Published var isRunning = false
    private var timer: Timer?

    var formattedTime: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d min %02d sec", minutes, seconds)
    }

    func start(minutes: Int) {
        secondsRemaining = minutes * 60
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.isRunning = false
            }
        }
    }

    func pause() {
        timer?.invalidate()
        isRunning = false
    }

    func resume() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.isRunning = false
            }
        }
    }
}
