//
//  GameScene.swift
//  testing
//
//  Created by Anil on 02/06/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var monster : SKSpriteNode!
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    var pauseBG = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let background = SKSpriteNode(imageNamed: "wallpapers-cool-green-desktop-background-wallpaper-papers-games-wallwuzz-hd-wallpaper-15963")
        background.anchorPoint = CGPointMake(0, 1)
        background.position = CGPointMake(0, size.height)
        background.zPosition = -5
        background.size = CGSize(width: self.view!.bounds.size.width, height:self.view!.bounds.size.height)
        addChild(background)
        addPauseButton()
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addMonster), SKAction.waitForDuration(1.0)])))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location) == pauseButton {
                
                pauseScreen()
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        
        if nodeAtPoint(touchLocation) == pauseButton {
            
            scene?.view?.paused = !scene!.view!.paused
        }

    }
    
    
    func addPauseButton() {

        pauseButton.position = CGPointMake(self.frame.size.width - 100, self.frame.size.height - 40)
        pauseButton.xScale = 0.3
        pauseButton.yScale = 0.3
        addChild(pauseButton)
    }
    
    func addMonster() {
        
        // Create sprite
        
        monster = SKSpriteNode(imageNamed: "monster")

        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        let loseAction = SKAction.runBlock() {
            
            
            //            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            //            let gameOverScene = GameOverScene(size: self.size, won: false)
            //            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    func pauseScreen() {
        
        pauseBG = SKSpriteNode(texture: SKTexture(image: self.getBluredScreenshot()))
        pauseBG.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        pauseBG.alpha = 0
        pauseBG.zPosition = 2
        pauseBG.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.01))
        self.addChild(pauseBG)
    }
    
    func getBluredScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.view!.bounds.size, false, 1)
        self.view?.drawViewHierarchyInRect(self.view!.frame, afterScreenUpdates: true)
        let ss = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
        gaussianBlurFilter.setDefaults()
        gaussianBlurFilter.setValue(CIImage(image: ss), forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue("10", forKey: kCIInputRadiusKey)
        
        let outputImage = gaussianBlurFilter.outputImage
        let context = CIContext(options: nil)
        var rect = outputImage.extent()
        rect.origin.x += (rect.size.width  - ss.size.width ) / 2
        rect.origin.y += (rect.size.height - ss.size.height) / 2
        rect.size = ss.size
        let cgimg = context.createCGImage(outputImage, fromRect: rect)
        let image = UIImage(CGImage: cgimg)
        return image!
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}
