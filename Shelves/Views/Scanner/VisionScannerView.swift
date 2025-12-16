import SwiftUI
import VisionKit
import Vision

struct VisionScannerView: UIViewControllerRepresentable {
    var onScan: (String) -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.ean13])],
            qualityLevel: .balanced,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        try? scanner.startScanning()
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: VisionScannerView
        var lastScanned: Date = Date.distantPast
        
        init(parent: VisionScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processItems(addedItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
           processItems([item])
        }
        
        func processItems(_ items: [RecognizedItem]) {
            for item in items {
                switch item {
                case .barcode(let code):
                    guard let value = code.payloadStringValue else { continue }
                    // Simple debounce: don't scan same code twice in 2 seconds? 
                    // For now, just send it up.
                    // Ideally we debounce in the logic layer, but let's debounce strictly here to avoid rapid firing
                    if Date().timeIntervalSince(lastScanned) > 2.0 {
                        lastScanned = Date()
                        parent.onScan(value)
                        
                        // Haptic Feedback
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                default:
                    break
                }
            }
        }
    }
}
