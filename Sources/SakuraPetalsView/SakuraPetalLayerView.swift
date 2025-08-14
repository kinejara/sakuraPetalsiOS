import UIKit
import SwiftUI

// MARK: - UIKit: Falling petals UIView
public final class SakuraPetalLayerView: UIView {

    public struct Config: Equatable {
        public var imageName: String = "petal"
        public var birthRate: Float = 4
        public var lifetime: Float = 12
        public var velocity: CGFloat = 30
        public var velocityRange: CGFloat = 20
        public var emissionLongitude: CGFloat = .pi
        public var emissionRange: CGFloat = .pi / 4
        public var spin: CGFloat = 0.5
        public var spinRange: CGFloat = 1.0
        public var scale: CGFloat = 0.8
        public var scaleRange: CGFloat = 0.02
        public var alphaSpeed: Float = -0.02
        public var yAcceleration: CGFloat = 15
        public var xAcceleration: CGFloat = 5

        public init() {}
    }

    public var config: Config {
        didSet { rebuildEmitterIfNeeded(oldValue: oldValue) }
    }

    private var emitter: CAEmitterLayer?
    private var isRunning = true

    public override init(frame: CGRect) {
        self.config = .init()
        super.init(frame: frame)
        backgroundColor = .clear
        buildEmitter()
    }

    public required init?(coder: NSCoder) {
        self.config = .init()
        super.init(coder: coder)
        backgroundColor = .clear
        buildEmitter()
    }

    public convenience init(frame: CGRect, config: Config) {
        self.init(frame: frame)
        self.config = config
        rebuildEmitter()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let emitter else { return }
        emitter.frame = bounds
        emitter.emitterPosition = CGPoint(x: bounds.width / 2, y: -10)
        emitter.emitterSize = CGSize(width: bounds.width, height: 1)
    }

    // MARK: Controls
    public func start() {
        isRunning = true
        emitter?.setValue(config.birthRate, forKeyPath: "emitterCells.petal.birthRate")
    }

    public func stop() {
        isRunning = false
        emitter?.setValue(0, forKeyPath: "emitterCells.petal.birthRate")
    }

    // MARK: Private
    private func buildEmitter() {
        guard let cg = Self.loadImage(named: config.imageName)?.cgImage else {
            print("❌ SakuraPetalLayerView: image '\(config.imageName)' not found")
            return
        }

        let layer = CAEmitterLayer()
        layer.frame = bounds
        layer.emitterPosition = CGPoint(x: bounds.width / 2, y: -10)
        layer.emitterSize = CGSize(width: bounds.width, height: 1)
        layer.emitterShape = .line

        let cell = CAEmitterCell()
        cell.name = "petal"
        cell.contents = cg
        cell.birthRate = config.birthRate
        cell.lifetime = config.lifetime
        cell.velocity = config.velocity
        cell.velocityRange = config.velocityRange
        cell.emissionLongitude = config.emissionLongitude
        cell.emissionRange = config.emissionRange
        cell.spin = config.spin
        cell.spinRange = config.spinRange
        cell.scale = config.scale
        cell.scaleRange = config.scaleRange
        cell.alphaSpeed = config.alphaSpeed
        cell.yAcceleration = config.yAcceleration
        cell.xAcceleration = config.xAcceleration

        layer.emitterCells = [cell]
        self.layer.addSublayer(layer)
        self.emitter = layer
        if !isRunning { stop() }
    }

    private func rebuildEmitter() {
        emitter?.removeFromSuperlayer()
        emitter = nil
        buildEmitter()
    }

    private func rebuildEmitterIfNeeded(oldValue: Config) {
        guard config != oldValue else { return }
        rebuildEmitter()
    }

    /// Load image from SwiftPM module or CocoaPods resource bundle (fallbacks to main).
    private static func loadImage(named: String) -> UIImage? {
        #if SWIFT_PACKAGE
        return UIImage(named: named, in: .module, with: nil)
        #else
        // Try the CocoaPods-created bundle named "SakuraPetalsView.bundle", else use class bundle, else main.
        let classBundle = Bundle(for: BundleToken.self)
        if
            let url = classBundle.url(forResource: "SakuraPetalsView", withExtension: "bundle"),
            let podBundle = Bundle(url: url),
            let img = UIImage(named: named, in: podBundle, compatibleWith: nil)
        {
            return img
        }
        if let img = UIImage(named: named, in: classBundle, compatibleWith: nil) {
            return img
        }
        return UIImage(named: named) // main bundle fallback
        #endif
    }
}

// Token class to locate the bundle in CocoaPods
private final class BundleToken {}


// MARK: - SwiftUI wrapper
public struct SakuraPetalView: UIViewRepresentable {
    public typealias UIViewType = SakuraPetalLayerView

    private let config: SakuraPetalLayerView.Config
    private let isRunning: Bool

    public init(config: SakuraPetalLayerView.Config = .init(), running: Bool = true) {
        self.config = config
        self.isRunning = running
    }

    public func makeUIView(context: Context) -> SakuraPetalLayerView {
        let v = SakuraPetalLayerView(frame: .zero, config: config)
        v.translatesAutoresizingMaskIntoConstraints = false
        if isRunning { v.start() } else { v.stop() }
        return v
    }

    public func updateUIView(_ uiView: SakuraPetalLayerView, context: Context) {
        uiView.config = config
        isRunning ? uiView.start() : uiView.stop()
    }
}

