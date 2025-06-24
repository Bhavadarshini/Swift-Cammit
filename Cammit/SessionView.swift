import SwiftUI
import Combine
import AVFoundation

struct SessionView: View {
    let focusMinutes: Int
    let breakMinutes: Int

    @StateObject private var timerManager = TimerManager()
    @StateObject private var cameraManager = CameraManager()

    var body: some View {
        ZStack {
            cameraBackground
            sessionOverlay
        }
        .onAppear {
            startSession()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
        .onChange(of: cameraManager.isFaceVisible) { isVisible in
            handleFaceVisibilityChange(isVisible)
        }
    }

    private var cameraBackground: some View {
        CameraPreviewView(session: cameraManager.session)
            .ignoresSafeArea()
    }

    private var sessionOverlay: some View {
        VStack(spacing: 20) {
            timerDisplay
            Spacer()

            if !cameraManager.isFaceVisible {
                faceNotDetectedWarning
            }

            controlButtons
                .padding(.bottom, 30)
        }
    }

    private var timerDisplay: some View {
        Text(timerManager.formattedTime)
            .font(.system(size: 36, weight: .bold, design: .rounded))
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .foregroundColor(.white)
            .background(Color.pink.opacity(0.9))
            .cornerRadius(16)
            .padding(.top, 40)
    }

    private var faceNotDetectedWarning: some View {
        Text("⛔ Timer Paused — User’s Face Not Shown")
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .medium))
            .padding()
            .background(Color.red.opacity(0.85))
            .cornerRadius(12)
            .padding(.bottom, 12)
    }

    private var controlButtons: some View {
        VStack(spacing: 15) {
            Button("Take a Break") {
                timerManager.pause()
            }
            .styledButton(backgroundColor: .pink)
            .buttonStyle(PlainButtonStyle())

            Button("Resume") {
                timerManager.resume()
            }
            .styledButton(backgroundColor: .green)
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func startSession() {
        cameraManager.startSession()
        timerManager.start(minutes: focusMinutes)
    }

    private func handleFaceVisibilityChange(_ isVisible: Bool) {
        if isVisible {
            timerManager.resume()
        } else {
            timerManager.pause()
        }
    }
}

private extension View {
    func styledButton(backgroundColor: Color) -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .frame(width: 220, height: 50)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}
