import Foundation
import SpriteKit
import PlaygroundSupport

public class HomeScene: SKScene {
    static let appTitles = [["Messages", "Calendar", "Photos", "Camera"],
                            ["Weather", "Clock", "Maps", "Videos"],
                            ["Wallet", "Notes","Reminders","Stocks"],
                            ["iTunes","App Store","iBooks","News"],
                            ["Health","Settings","",""],
                            ["Phone","Mail","Safari","Music"],
                            ["","","",""]]
    private var apps = [[App]]()
    private var placeHolders = [SKSpriteNode]()
    private var floor: SKSpriteNode!
    private var leftWall: SKSpriteNode!
    private var rightWall: SKSpriteNode!
    private var ceiling: SKSpriteNode!
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = NSColor.clear
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        ceiling = SKSpriteNode(color: NSColor.clear, size: CGSize(width: frame.width, height: 20))
        ceiling.position = CGPoint(x: frame.width/2, y: FRAME.height + 20)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        ceiling.physicsBody!.affectedByGravity = false
        ceiling.physicsBody!.isDynamic = false
        ceiling.physicsBody!.restitution = 0.9
        addChild(ceiling)
        
        floor = SKSpriteNode(color: NSColor.clear, size: CGSize(width: frame.width, height: 20))
        floor.position = CGPoint(x: frame.width/2, y: -20)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody!.affectedByGravity = false
        floor.physicsBody!.isDynamic = false
        floor.physicsBody!.restitution = 0.9
        addChild(floor)
        
        leftWall = SKSpriteNode(color: NSColor.clear, size: CGSize(width: 20, height: frame.height))
        leftWall.position = CGPoint(x: -20, y: frame.height/2)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody!.affectedByGravity = false
        leftWall.physicsBody!.isDynamic = false
        leftWall.physicsBody!.restitution = 0.9
        addChild(leftWall)
        
        rightWall = SKSpriteNode(color: NSColor.clear, size: CGSize(width: 20, height: frame.height))
        rightWall.position = CGPoint(x: frame.width + 20, y: frame.height/2)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody!.affectedByGravity = false
        rightWall.physicsBody!.isDynamic = false
        rightWall.physicsBody!.restitution = 0.9
        addChild(rightWall)
        
        for row in 0..<6 {
            apps.append([App]())
            for col in 0..<4 {
                if HomeScene.appTitles[row][col] == "" {continue}
                let app = App(title: HomeScene.appTitles[row][col])
                app.position = CGPoint(x: 50 + 80*col, y: 190 + 85*(5-row))
                apps[row].append(app)
                if row == 5 {
                    //Dock row
                    app.removeAllChildren()
                    app.position.y -= 130
                }
                app.originalPoint = app.position
                let ph = getPlaceholder(app: app)
                addChild(ph)
                placeHolders.append(ph)
            }
        }
        for row in apps {
            for app in row {
                addChild(app)
            }
        }
    }
    private func getPlaceholder(app: SKSpriteNode) -> SKSpriteNode {
        let ph = SKSpriteNode(texture: SKTexture(imageNamed: "placeHolder"), size: CGSize(width: 45, height: 45))
        ph.position = app.position
        return ph
    }
    
    public var blinkingApp: App?
    
    public func touch(_ loc: CGPoint) {
        for row in apps {
            for app in row {
                if app.contains(loc) {
                    if !app.blinking {
                        for r in apps {
                            for a in r {
                                a.removeAllActions()
                                a.blinking = false
                                a.colorBlendFactor = 0.0
                            }
                        }
                        app.blink()
                        blinkingApp = app
                    }
                    return //So app and placeholder can't both be clicked
                }
            }
        }
        for ph in placeHolders {
            if ph.frame.contains(loc) {
                if let selected = blinkingApp {
                    blinkingApp = nil
                    selected.launch(to: ph.position)
                    var complete = true
                    for row in apps {
                        for app in row {
                            if !app.inCorrectSpot {
                                complete = false
                            }
                        }
                    }
                    if complete {
                        winner()
                    }
                }
            }
        }
    }
    private func winner() {
        let winner = SKLabelNode(text: "You won!")
        winner.fontName = "System Black"
        winner.fontSize = 50
        winner.position = CGPoint(x: FRAME.width/2, y: FRAME.height/2)
        winner.fontColor = NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        addChild(winner)
        let group = SKAction.group([SKAction.scale(by: 2.0, duration: 0.5), SKAction.colorize(with: NSColor.black, colorBlendFactor: 1.0, duration: 0.5)])
        let sequence = SKAction.sequence([group, group.reversed()])
        winner.run(SKAction.repeatForever(sequence))
        let _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(endGame), userInfo: nil, repeats: false)
    }
    @objc public func endGame() {
        PlaygroundPage.current.finishExecution()
    }
    @objc public func physics() {
        for row in apps {
            for app in row {
                app.inCorrectSpot = false
                app.blinking = false
                app.removeAllActions()
                app.setPhysicsBody()
                app.physicsBody?.affectedByGravity = true
                app.physicsBody?.applyForce(CGVector(dx: CGFloat.random(in: -10000.0...10000.0), dy: CGFloat.random(in: -1000.0...1000.0)))
            }
        }
    }
}
