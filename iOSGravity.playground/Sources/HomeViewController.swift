import Foundation
import AppKit
import SpriteKit

public let FRAME = NSRect(x: 0.0, y: 0.0, width: 340, height: 700)

public class HomeViewController: NSViewController {
    private var scrollView: NSScrollView!
    private var sceneView: SKView!
    public override func loadView() {
        self.view = NSView(frame: FRAME)
    }
    private var recognizer: NSClickGestureRecognizer!
    private var tabRecognizer: NSPanGestureRecognizer!
    private var keyButton: NSButton!
    private var tab: CAShapeLayer!
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = NSImageView(frame: FRAME)
        backgroundImage.imageScaling = .scaleAxesIndependently
        backgroundImage.image = NSImage(imageLiteralResourceName: "wallpaper")
        backgroundImage.wantsLayer = true
        backgroundImage.layer?.zPosition = 0
        view.addSubview(backgroundImage)
        
        scrollView = NSScrollView(frame: view.frame)
        view.addSubview(scrollView)
        scrollView.backgroundColor = NSColor.clear
        scrollView.drawsBackground = false
        scrollView.hasHorizontalScroller = true
        scrollView.wantsLayer = true
        scrollView.layer?.zPosition = 1
        
        let dock = NSVisualEffectView()
        dock.frame = CGRect(x: 15, y: 20, width: FRAME.width - 30, height: 75)
        dock.wantsLayer = true
        dock.layer?.cornerRadius = 20
        dock.layer?.masksToBounds = true
        dock.layer?.zPosition = 0
        dock.blendingMode = .withinWindow
        dock.material = .light
        view.addSubview(dock)
        
        sceneView = SKView(frame: FRAME)
        let homeScene = HomeScene(size: FRAME.size)
        sceneView.presentScene(homeScene)
        sceneView.allowsTransparency = true
        sceneView.scene!.backgroundColor = NSColor.clear
        sceneView.wantsLayer = true
        scrollView.documentView = sceneView
        
        let notch = NSImageView(frame: FRAME)
        notch.image = NSImage(imageLiteralResourceName: "notch")
        view.addSubview(notch)
        notch.wantsLayer = true
        notch.layer?.zPosition = 1000
        
        view.wantsLayer = true
        view.layer?.cornerRadius = 40
        view.layer?.masksToBounds = true
        
        let clock = ClockLabel()
        clock.frame = NSRect(x: 25, y: FRAME.height - 25, width: 80, height: 25)
        clock.start()
        view.addSubview(clock)
        
        let cellular = NSImageView(frame: NSRect(x: 263, y: FRAME.height - 30, width: 26, height: 26))
        cellular.image = NSImage(imageLiteralResourceName: "Cellular")
        cellular.wantsLayer = true
        cellular.layer?.zPosition = 2
        view.addSubview(cellular)
        
        let wifi = NSImageView(frame: NSRect(x: 282, y: FRAME.height - 30, width: 26, height: 26))
        wifi.image = NSImage(imageLiteralResourceName: "Wifi")
        wifi.wantsLayer = true
        wifi.layer?.zPosition = 2
        view.addSubview(wifi)
        
        let battery = NSImageView(frame: NSRect(x: 302, y: FRAME.height - 38, width: 28, height: 38))
        battery.image = NSImage(imageLiteralResourceName: "Battery")
        battery.wantsLayer = true
        battery.layer?.zPosition = 2
        view.addSubview(battery)
        
        recognizer = NSClickGestureRecognizer(target: self, action: #selector(touch))
        view.addGestureRecognizer(recognizer)
        
        tab = CAShapeLayer()
        tab.zPosition = 4
        tab.path = CGPath(roundedRect: CGRect(x: FRAME.width/2 - 60, y: 7, width: 120, height: 5), cornerWidth: 2.5, cornerHeight: 2.5, transform: nil)
        tab.fillColor = CGColor.white
        view.layer?.addSublayer(tab)
        
        tabRecognizer = NSPanGestureRecognizer(target: self, action: #selector(tabSwiped(pan:)))
        tabRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tabRecognizer)
    }
    @objc public func tabSwiped(pan:NSPanGestureRecognizer) {
        tab.position.y = pan.translation(in: view).y
        if tab.position.y > 20 {
            pan.isEnabled = false
            view.removeGestureRecognizer(pan)
            tab.position.y = 7
            if let scene = sceneView.scene as? HomeScene {
                scene.physics()
            }
        }
    }
    @objc public func touch() {
        let loc = recognizer.location(in: view)
        if let scene = sceneView.scene as? HomeScene {
            scene.touch(loc)
        }
    }
}
