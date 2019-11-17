//
//  EndScene.swift
//  Rocket Shooting
//
//  Created by Faiz Ikhwan on 14/11/2019.
//  Copyright © 2019 Faiz Ikhwan. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene: SKScene {
    
    var restartButton: UIButton!
    var highscoreLabel: UILabel!
    var scoreLabel: UILabel!
    var highscore: String?
    var score: Int?
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .white
        setupButton()
        setupLabelScore()
        getHighScore()
        setupLabelHighscore()
    }
    
    func getHighScore() {
        highscore = UserDefaults.standard.string(forKey: "highscore")
    }
    
    func setupLabelHighscore() {
        guard let view = view else { return }
        guard let highscore = highscore else { return }
        highscoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 30))
        highscoreLabel.center = CGPoint(x: frame.midX, y: frame.midY + 40)
        highscoreLabel.text = "Highscore: \(highscore)"
        highscoreLabel.textAlignment = .center
        highscoreLabel.textColor = .black
        view.addSubview(highscoreLabel)
    }
    
    func setupButton() {
        guard let view = view else { return }
        restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: 30))
        restartButton.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.width / 7)
        restartButton.setTitle("Restart", for: .normal)
        restartButton.setTitleColor(.darkGray, for: .normal)
        restartButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        view.addSubview(restartButton)
    }
    
    func setupLabelScore() {
        guard let view = view else { return }
        guard let score = score else { return }
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 30))
        scoreLabel.center = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .black
        view.addSubview(scoreLabel)
    }
    
    @objc func restart() {
        let gameScene = GameScene(size: self.size)
        view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.3))
        restartButton.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        highscoreLabel.removeFromSuperview()
    }
}
