import SwiftUI
import AVFoundation
import AppKit

struct CameraPreviewView: NSViewRepresentable {
    let session: AVCaptureSession

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        previewLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        previewLayer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))

        view.layer?.addSublayer(previewLayer)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
