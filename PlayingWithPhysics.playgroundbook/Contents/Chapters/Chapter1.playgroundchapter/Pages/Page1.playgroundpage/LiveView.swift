//#-hidden-code
//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit



var projectileIsDragged = false
var touchCurrentPoint: CGPoint!
var touchStartingPoint: CGPoint!
// In crazy mode the game physics change!
var isCrazyWorld = false


//It will start when the ball falls to the ground. it is used to put the ball in the rest position
var countDown: TimeInterval = costants.maxcountdow {
    
    didSet {
        if countDown > costants.maxcountdow {
            countDown = costants.maxcountdow
        }
        if countDown < 0 {
            countDown = 0
        }
        
    }
}


var isOnTheGround = false

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    let worldNode:SKNode = SKNode()
    
    var projectile: Projectile!
    var slingShot: SlingShot!
    
    
    
    override func didMove(to view: SKView) {
        
//      I save the view to know some of its parameters in Settings
        Settings.gameView = view
        
        backgroundColor = .blue
        
//      Declaration of Background, slingshot and projectile
        var imageBackground = SKSpriteNode(imageNamed: "background")
        
        imageBackground.position.x = view.frame.midX
        imageBackground.position.y = view.frame.midY
        imageBackground.size = view.frame.size
        addChild(worldNode)
        
        
        slingShot = SlingShot()
        projectile = Projectile(imageNamed: "ball")
        
        
//      Setup all elements
        setScenePhysicsProperty()
        projectile.setupProjectile()
        slingShot.setupSling()
        setupBoxes()
        
        
//      Insert all elements in the scene
        worldNode.addChild(imageBackground)
        worldNode.addChild(slingShot)
        worldNode.addChild(projectile)
        
        
    
        
    }
    
    
//  setup the physics of screen edge
    func setScenePhysicsProperty(){
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0 , dy: Settings.Game.gravity)
        physicsWorld.speed = 0.5
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.density = 10000
        physicsBody!.restitution = 0.1
        physicsBody?.friction = 1
        physicsBody!.categoryBitMask = BodyType.ground
        physicsBody!.collisionBitMask = BodyType.projectile
        physicsBody!.contactTestBitMask =  BodyType.projectile
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*  When the user is touching the screen, we need to find out whether we must start the dragging process or not.
            The function shouldStartDragging will give us this information
        */
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if !projectileIsDragged && shouldStartDragging(touchLocation: touchLocation, threshold: Settings.Metrics.projectileTouchThreshold)  {
                touchStartingPoint = touchLocation
                touchCurrentPoint = touchLocation
                projectileIsDragged = true
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*
             If we are under a dragging process, we calculate the distance A→B and if this distance is larger than the rLimit
             we setting the projectile’s position on the perimeter of the circle with radius rLimit.
        */
        
        if projectileIsDragged {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchLocation, fingerPosition: touchStartingPoint)
                if distance < Settings.Metrics.rLimit  {
                    touchCurrentPoint = touchLocation
                } else {
                    touchCurrentPoint = projectilePositionForFingerPosition(
                        fingerPosition: touchLocation,
                        projectileRestPosition: touchStartingPoint,
                        rLimit: Settings.Metrics.rLimit
                    )
                }
                
            }
            
            projectile.position = touchCurrentPoint
            
            slingShot.update(projectilePosition: projectile.position)
            
            
//          We change the Position of projectile to give the user the impression that the ball is between the elastic band
            projectile.zPosition = zPositions.projectile
            
            
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        slingShot.restSling()
        
        
        
        
        if projectileIsDragged {
            projectileIsDragged = false
            let distance = fingerDistanceFromProjectileRestPosition(projectileRestPosition: touchCurrentPoint, fingerPosition: touchStartingPoint)
            if distance > Settings.Metrics.projectileSnapLimit {
                let vectorX = touchStartingPoint.x - touchCurrentPoint.x
                let vectorY = touchStartingPoint.y - touchCurrentPoint.y
                
//              we set the physics of the projectile after the throw, so that it remains in the resting position if it is not throw
                projectile.setPhysicsProperty()
                projectile.physicsBody!.affectedByGravity = true
                projectile.zPosition = zPositions.elasticBandright + 1
                
                
//              We check if the crazy mode is on , in this case the game physics change!
                
                if isCrazyWorld {
                    projectile.physicsBody!.restitution = 1
                    projectile.physicsBody?.mass = 0.04
                    
                    
                    projectile.physicsBody?.applyImpulse(
                        CGVector(
                            dx: vectorX * 3,
                            dy: vectorY * slingShot.slingSpringiness
                        )
                    )
                    
                    
                    
                }else{
                    projectile.physicsBody!.restitution = Settings.Game.projectileSpringiness
                    projectile.physicsBody?.mass = Settings.Game.projectileMass
                    
                    
                    projectile.physicsBody?.applyImpulse(
                        CGVector(
                            dx: vectorX * slingShot.slingSpringiness,
                            dy: vectorY * slingShot.slingSpringiness
                        )
                    )
                }
                
            } else {
                projectile.physicsBody = nil
                projectile.setupProjectile()
            }
        }
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
//      We check the counter and at of its  expiry we put the ball in the rest position
        
        if isOnTheGround {
            countDown = countDown - 0.1
            print("countDown : \(countDown)")
        }
        if countDown == 0 {
            resetProjectile(projectile: projectile)
            countDown = costants.maxcountdow
            isOnTheGround = false
        }
        
 
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
//       contact  between box and projectile
        if (contact.bodyA.categoryBitMask == BodyType.box  && contact.bodyB.categoryBitMask == BodyType.projectile ) {
            
            
            
            let box = contact.bodyA.node! as! Box
            
            if isCrazyWorld == true {
                
                box.isIndestructible = true
                box.physicsBody!.restitution = 1
                
            }else {
                
                box.isIndestructible = false
                box.integrity =  box.integrity - 1
                box.physicsBody!.restitution = 0
                
            }
            
            
           
            
        } else if (contact.bodyA.categoryBitMask == BodyType.projectile   && contact.bodyB.categoryBitMask == BodyType.box ) {
            
            let box = contact.bodyB.node! as! Box
            if isCrazyWorld == true {
                
                box.isIndestructible = true
                box.physicsBody!.restitution = 1
                
            }else {
                
                box.isIndestructible = false
                box.integrity =  box.integrity - 1
                box.physicsBody!.restitution = 0.2
            }
            
            
        }
        
        
        //  if  the ball falls to the ground
        
        if (contact.bodyA.categoryBitMask == BodyType.ground  && contact.bodyB.categoryBitMask == BodyType.projectile) {
            
            isOnTheGround = true

        } else if (contact.bodyA.categoryBitMask == BodyType.projectile  && contact.bodyB.categoryBitMask == BodyType.ground ) {
            
            isOnTheGround = true
            
        }
 
    }
    
    
    
    
 /*  When the user is touching the screen, we need to find out whether we must start the dragging process or not.
     The function shouldStartDragging will give us this information
 */
    func shouldStartDragging(touchLocation:CGPoint, threshold: CGFloat) -> Bool {
        let distance = fingerDistanceFromProjectileRestPosition(
            projectileRestPosition: Settings.Metrics.projectileRestPosition,
            fingerPosition: touchLocation
            
        )
        return distance < Settings.Metrics.projectileRadius + threshold
    }
    
    
    //The function will return the Eucledian distance between the projectile’s rest position and the finger.
    
    func fingerDistanceFromProjectileRestPosition(projectileRestPosition: CGPoint, fingerPosition: CGPoint) -> CGFloat {
        return sqrt(pow(projectileRestPosition.x - fingerPosition.x,2) + pow(projectileRestPosition.y - fingerPosition.y,2))
    }
    
   
    /*The function will give us the position the projectile has to be (even if our finger is outside rLimit.
    First, we calulating the angle θ by using the arctangent function atan2(). Then, we calculating the points that the projectile has to be*/
    
    func projectilePositionForFingerPosition(fingerPosition: CGPoint, projectileRestPosition:CGPoint, rLimit:CGFloat) -> CGPoint {
        let θ = atan2(fingerPosition.x - projectileRestPosition.x, fingerPosition.y - projectileRestPosition.y)
        let cX = sin(θ) * rLimit
        let cY = cos(θ) * rLimit
        return CGPoint(x: cX + projectileRestPosition.x, y: cY + projectileRestPosition.y)
    }
    
    
    
    @objc func setupBoxes() {
        
        var textures = ["boxY" , "boxB", "boxG","boxB" , "boxY", "boxG" ]
//     Inserts boxes in the scene and set the colors randomly
        
        for i in 1...2 {
            for j in 1...8 {
                var textureName = textures[ Int(arc4random_uniform(5)) ]
                let box = Box(imageNamed: textureName)
                box.integrity = 2
                box.size.height = view!.bounds.size.height / 16
                box.size.width = view!.bounds.size.height / 16
                
                let boxWidth = Int(box.size.width)
                let boxHeight = Int(box.size.height)
                let positionX = Int((view!.bounds.midX) + view!.bounds.midX / 3 ) + (i * boxWidth + 5 * i)
                let positionY = Int(UIScreen.main.bounds.minY) + j * boxHeight
                
                
                box.position = CGPoint(x: positionX, y: positionY )
                
                box.setPhysicsProperty()
                
                if isCrazyWorld {
                    box.physicsBody!.restitution = 1
                    box.isIndestructible = true
                    box.physicsBody!.mass = 0.5
                 
                    
                }else{
                    box.physicsBody!.restitution = 0.3
                    box.physicsBody!.mass = 1
                    
                   
                    box.isIndestructible = false
                    
                }
                
                
                
                worldNode.addChild(box)
                Box.numberOfBox += 1
            }
        }
    }
    
    
    
    
    
    func resetProjectile(projectile: SKNode) {

        let fadeOut:SKAction = SKAction.fadeOut(withDuration: 0.2)
        let wait:SKAction = SKAction.wait(forDuration: 0.1)
        let move:SKAction = SKAction.move(to: Settings.Metrics.projectileRestPosition, duration: 0.2)
        projectile.zPosition = zPositions.elasticBandright + 1
        let fadeIn:SKAction = SKAction.fadeIn(withDuration: 0.2)
        let seq:SKAction = SKAction.sequence([ fadeOut , wait , move, wait ,fadeIn])
        projectile.run(seq)
        
        
        projectile.physicsBody = nil
        
        
    }
    
//   if you want the boxes appear again when you destroy them completely you can use this . But i prefer don't  because we have just 3 minutes to use this playgroundbook
    @objc func resetBox(){
        
        let fadeOut:SKAction = SKAction.fadeOut(withDuration: 0.2)
        let wait:SKAction = SKAction.wait(forDuration: 0.3)
  
        
        let fadeIn:SKAction = SKAction.fadeIn(withDuration: 0.2)
        let seq:SKAction = SKAction.sequence([ fadeOut , wait ])
        projectile.run(seq)
        setupBoxes()
        let seq2:SKAction = SKAction.sequence([ wait , fadeIn ])
        projectile.run(seq2)
        
        
    }
    
    func crazyModeOn (){
        
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsBody!.restitution = 1
        isCrazyWorld = true
        
        
    }
    
    func crazyModeOff (){
        
        physicsWorld.gravity = CGVector(dx: 0 , dy: Settings.Game.gravity)
        physicsBody!.restitution = 0
        isCrazyWorld = false
        
        
    }
    
    
    
    
}




let sceneView =  SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))

// Load the Scene from GameScene
let scene = GameScene(size: sceneView.frame.size)
scene.scaleMode = .aspectFit// Fit the window


// Present the scene
sceneView.presentScene(scene)
sceneView.ignoresSiblingOrder = true

sceneView.showsFPS = false
sceneView.showsNodeCount = false
sceneView.autoresizingMask = [.flexibleLeftMargin , .flexibleTopMargin ]
sceneView.autoresizesSubviews = false

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


