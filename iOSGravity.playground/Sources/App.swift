import Foundation
import SpriteKit
import CoreGraphics

public class App: SKSpriteNode {
    //Width and height
    static let dimension: CGFloat = 50.0
    //Size
    static let size = CGSize(width: App.dimension, height: App.dimension)
    //References image and is title that appears below app
    public var title: String
    public var label: SKLabelNode!
    public func setPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.5
    }
    
    public init(title: String) {
        self.title = title
        let texture = SKTexture(imageNamed: title)
        super.init(texture: texture, color: NSColor.black, size: App.size)
        setPhysicsBody()
        
        label = SKLabelNode(text: title)
        label.position = CGPoint(x: self.position.x, y: self.position.y - 40)
        label.fontSize = 10.5
        label.fontName = "System Bold"
        label.fontColor = NSColor.white
        addChild(label)
    }
    required public init?(coder aDecoder: NSCoder) {
        self.title = "Title"
        super.init(coder: aDecoder)
    }
    public var originalPoint: CGPoint!
    public var blinking = false
    @objc public func blink() {
        let colorAction = SKAction.colorize(with: NSColor.black, colorBlendFactor: 1.0, duration: 0.3)
        let sequence = SKAction.sequence([colorAction, colorAction.reversed()])
        let blink = SKAction.repeatForever(sequence)
        self.run(blink)
        blinking = true
    }
    
    public var inCorrectSpot = false
    public func launch(to: CGPoint) {
        var blinkColor = NSColor.init(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
        if to == originalPoint {
            blinkColor = NSColor.init(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
            inCorrectSpot = true
        }
        self.physicsBody = nil
        self.zRotation = 0.0
        let action = SKAction.group([SKAction.scale(to: CGSize(width: self.size.width*1.5, height: self.size.height*1.5), duration: 0.25), SKAction.colorize(with: blinkColor, colorBlendFactor: 1.0, duration: 0.1), SKAction.move(to: CGPoint(x: FRAME.width/2, y: FRAME.height/2), duration: 0.25)])
        self.run(action) {
            self.run(SKAction.scale(to: App.size, duration: 0.25))
            self.run(SKAction.colorize(with: blinkColor, colorBlendFactor: 0.0, duration: 0.25))
            self.run(SKAction.move(to: to, duration: 0.25)) {
                self.removeAllActions()
                if to != self.originalPoint {
                    if let homeScene = self.scene as? HomeScene {
                        homeScene.physics()
                    }
                }
            }
        }
    }
    @objc public func launch() {
        //App was clicked - open it
        self.launch(to: originalPoint)
    }
}
