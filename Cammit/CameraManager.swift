import AVFoundation
import Vision
import SwiftUI

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let detectionQueue = DispatchQueue(label: "FaceDetectionQueue")

    @Published var isFaceVisible = false

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(videoOutput) else {
            print("❌ Error setting up camera input/output")
            return
        }

        session.addInput(input)
        videoOutput.setSampleBufferDelegate(self, queue: detectionQueue)
        session.addOutput(videoOutput)
        session.startRunning()
    }

    func startSession() {
        if !session.isRunning { session.startRunning() }
    }

    func stopSession() {
        if session.isRunning { session.stopRunning() }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }

            if let results = request.results as? [VNFaceObservation] {
                DispatchQueue.main.async {
                    // You can add confidence checks here if needed
                    self.isFaceVisible = !results.isEmpty
                }
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:])
        try? handler.perform([request])
    }
}
