//
//  GameScene.swift
//  Rocket Shooting
//
//  Created by Faiz Ikhwan on 13/11/2019.
//  Copyright © 2019 Faiz Ikhwan. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let enemy: UInt32 = 1
    static let bullet: UInt32 = 2
    static let player: UInt32 = 3
}

class GameScene: SKScene {
            
    var player = SKSpriteNode(imageNamed: "PlayerRocket")
    var enemy = SKSpriteNode(imageNamed: "EnemyRocket")
    var scoreLabel = UILabel()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
        
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupPlayer()
        setupLabel()
        setupTimer()
        setupBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            player.position.x = touchLocation.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            player.position.x = touchLocation.x
        }
    }
    
    func setupBackground() {
        addChild(SKEmitterNode(fileNamed: "FirefliesParticle")!)
    }
    
    func setupTimer() {
        _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(spawnBullet), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
    }
    
    func setupLabel() {
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        scoreLabel.textColor = .white
        view?.addSubview(scoreLabel)
    }
    
    func setupPlayer() {
        player.position = CGPoint(x: frame.midX, y: size.height/6)
        player.size = CGSize(width: 25.0, height: 25.0)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        player.physicsBody?.isDynamic = false
        
        addChild(player)
    }
    
    @objc func spawnBullet() {
        let bullet = SKSpriteNode(imageNamed: "Bullet")
        bullet.zPosition = -5
        bullet.position = CGPoint(x: player.position.x, y: player.position.y)
        bullet.size = CGSize(width: 5.0, height: 5.0)
        
        let action = SKAction.sequence([SKAction.moveTo(y: self.size.height + 30, duration: 0.8),
                                        SKAction.removeFromParent()])
        bullet.run(action)
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        bullet.physicsBody?.isDynamic = false
        
        addChild(bullet)
    }
    
    @objc func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "EnemyRocket")
        let minValue = self.size.width / 8
        let maxValue = self.size.width - 25        
        let spawnPoint = UInt32(maxValue - minValue)
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        enemy.size = CGSize(width: 25.0, height: 25.0)
        
        let action = SKAction.sequence([SKAction.moveTo(y: -70, duration: 3.0),
                                        SKAction.removeFromParent()])
        enemy.run(action)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        enemy.physicsBody?.isDynamic = true
        
        addChild(enemy)
    }
    
    func collisionWithBullet(enemy: SKSpriteNode, bullet: SKSpriteNode) {
        enemy.removeFromParent()
        bullet.removeFromParent()
        score += 1
    }
    
    func collisionWithPlayer(enemy: SKSpriteNode, player: SKSpriteNode) {
        enemy.removeFromParent()
        player.removeFromParent()
        scoreLabel.removeFromSuperview()
        let endScene = EndScene(size: self.size)
        endScene.score = score
        storeScore()
        view?.presentScene(endScene)
    }
    
    func storeScore() {
        if let highScoreString = UserDefaults.standard.string(forKey: "highscore"), let highScore = Int(highScoreString) {
            if self.score > highScore {
                UserDefaults.standard.set(score, forKey: "highscore")
            }
        } else {
            UserDefaults.standard.set(score, forKey: "highscore")
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if (firstBody.categoryBitMask == PhysicsCategory.enemy) && (secondBody.categoryBitMask == PhysicsCategory.bullet) || (firstBody.categoryBitMask == PhysicsCategory.bullet) && (secondBody.categoryBitMask == PhysicsCategory.enemy) {
            collisionWithBullet(enemy: firstBody.node as! SKSpriteNode, bullet: secondBody.node as! SKSpriteNode)
        } else if (firstBody.categoryBitMask == PhysicsCategory.enemy) && (secondBody.categoryBitMask == PhysicsCategory.player) || (firstBody.categoryBitMask == PhysicsCategory.player) && (secondBody.categoryBitMask == PhysicsCategory.enemy) {
            collisionWithPlayer(enemy: firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
        }
    }
}
