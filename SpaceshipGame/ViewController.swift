//
//  ViewController.swift
//  spaceship
//
//  Created by Jonathan Pang on 8/29/20.
//  Copyright © 2020 Jonathan Pang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let ship          = spaceship()
    var v_ship        = UIView()
    var v_objects     = UIView()
    var v_blocks      = UIView()
    var slider        = UISlider()
    var didChange     = false
    var label         = UILabel()
    var timer_ship    = Timer()
    var timer_objects = Timer()
    var timer_blocks  = Timer()
    
    // ship methods
    @objc func ship_displays() {
        // checks for collisions
        ship.collide()
        label.text             = ship.return_score()
        v_ship.layer.sublayers = nil
        
        // deletes ship from view
        if let viewWithTag     = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        
        // add to view
        v_ship.layer.addSublayer(ship.display_ship())
        view.addSubview(v_ship)
        view.addSubview(slider)
        
        // if game ends, player is unable to move
        if ship.block_temp.count < ship.points_of_blocks.count {
            // deletes previous views
            slider.isEnabled          = false
            if let viewWithTag        = self.view.viewWithTag(1) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag        = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag        = self.view.viewWithTag(200) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag        = self.view.viewWithTag(300) {
                viewWithTag.removeFromSuperview()
            }
            slider.isHidden           = true

            // invalidates all the timers
            timer_ship.invalidate()
            timer_objects.invalidate()
            timer_blocks.invalidate()
            
            // sets up view
            let temp_view             = UIView()
            temp_view.tag             = 20
            
            // sets up label
            let label                 = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 8 * 3, width: 400, height: 30))
            label.center              = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 8 * 3)
            label.text                = "Your score is " + ship.return_score()
            label.textAlignment       = .center
            label.tag                 = 0
            label.font                = UIFont(name: label.font.fontName, size: 25)
            label.textColor           = .black
            
            // sets up button
            let button                = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4, width: 150, height: 30))
            button.center             = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            button.tag                = 10
            button.setTitle("Play Again", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth  = 1.5
            button.layer.cornerRadius = CGFloat(150 * (sin (Double.pi / 16) / 2))
            button.isEnabled          = true
            button.addTarget(self, action: #selector(play_again), for: .touchUpInside)
            
            // resets all values
            ship.restart()
            
            // add to view
            temp_view.addSubview(label)
            view.addSubview(temp_view)
            view.addSubview(button)
        }
    }
      
    // object methods
    @objc func objects() {
        // checks for collisions
        ship.collide()
        label.text                = ship.return_score()
        v_objects.layer.sublayers = nil
        ship.set_points()
        ship.object_make()
        ship.object_moving()
        
        // displays objects
        for object in ship.display_objects() {
            let obj               = CAShapeLayer()
            obj.path              = object
            v_objects.layer.addSublayer(obj)
        }
        
        // add to view
        view.addSubview(v_objects)
        view.addSubview(slider)
    }
    
    // block methods
    @objc func blocks() {
        // checks for collisions
        ship.collide()
        label.text                = ship.return_score()
        v_blocks.layer.sublayers  = nil
        ship.block_make()
        ship.block_moving()
        
        // displays the blocks
        for block in ship.display_blocks() {
            let b                 = CAShapeLayer()
            b.path                = block
            b.fillColor           = UIColor.blue.cgColor
            v_blocks.layer.addSublayer(b)
        }
        
        // add to view
        view.addSubview(v_blocks)
        view.addSubview(slider)
    }
    
    // slider target and moves the ship
    @objc func sliderValueDidChange(_ sender: UISlider!) {
        if sender.value > 0.5 {
            ship.position_of_ship = CGPoint(x: UIScreen.main.bounds.width * CGFloat(sender.value) - UIScreen.main.bounds.width / 8, y: ship.position_of_ship.y)
        } else {
            ship.position_of_ship = CGPoint(x: UIScreen.main.bounds.width * CGFloat(sender.value) + UIScreen.main.bounds.width / 8, y: ship.position_of_ship.y)
        }
    }
    
    // plays the game again
    @objc func play_again() {
        // removes all views
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        // loads the game again
        viewDidLoad()
    }
    
    // overload
    override func viewDidLoad() {
        super.viewDidLoad()
        // gives the views tags
        v_ship.tag          = 100
        v_objects.tag       = 200
        v_blocks.tag        = 300
        
        // sets up timers
        timer_ship          = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(ship_displays), userInfo: nil, repeats: true)
        timer_objects       = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(objects), userInfo: nil, repeats: true)
        timer_blocks        = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(blocks), userInfo: nil, repeats: true)
        
        // sets up the slider
        slider = UISlider(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 8 * 7, width: UIScreen.main.bounds.width / 8 * 7, height: 25))
        slider.center       = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 8 * 7)
        slider.tintColor    = .red
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.setValue(0.5, animated: false)
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        view.addSubview(slider)
        
        // sets up the label
        label               = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 32 * 3, width: UIScreen.main.bounds.width, height: 25))
        label.center        = CGPoint(x: UIScreen.main.bounds.width / 8, y: UIScreen.main.bounds.height / 32 * 3)
        label.textAlignment = .center
        label.text          = "0"
        label.textColor     = .black
        label.font          = UIFont(name: label.font.fontName, size: 25)
        label.tag           = 1
        view.addSubview(label)
    }
}

class spaceship {
    var position_of_ship : CGPoint // position of the ship
    var points_of_ship   : [CGPoint] // points to make the ship
    var tip              : CGPoint // tip of the ship
    var points_of_objects: [CGPoint] // points to make the objects
    var points_of_blocks : [CGPoint] // points to make blocks
    var score            : Int // score of the game
    var block_temp       : [CGPoint] // storage of blocks
    
    // initializer
    init() {
        position_of_ship  = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4 * 3)
        points_of_ship    = []
        tip               = CGPoint(x: 0, y: 0)
        points_of_objects = []
        points_of_blocks  = []
        score             = 0
        block_temp        = []
        set_points()
    }
    
    // sets the points of the ship
    func set_points() {
        tip            = CGPoint(x: position_of_ship.x, y: position_of_ship.y - 45)
        points_of_ship = [CGPoint(x: position_of_ship.x - 15, y: position_of_ship.y), CGPoint(x: position_of_ship.x, y: position_of_ship.y - 45), CGPoint(x: position_of_ship.x + 15, y: position_of_ship.y)]
    }
    
    // displays the ship
    func display_ship() -> CAShapeLayer {
        let path = UIBezierPath()
        let ship = CAShapeLayer()
        
        // creates the paths
        for index in 0..<points_of_ship.count {
            if index == 0 {
                path.move(to: points_of_ship[index])
            } else {
                path.addLine(to: points_of_ship[index])
            }
        }
        
        // draws the ships
        ship.path = path.cgPath
        ship.fillColor = UIColor.gray.cgColor
        
        return ship
    }
        
    // makes objects
    func object_make() {
        points_of_objects.append(CGPoint(x: tip.x - 2.5, y: tip.y - 15))
    }
    
    // makes object move
    func object_moving() {
        // adds objects to list of positions
        for index in 0..<points_of_objects.count {
            points_of_objects[index] = CGPoint(x: points_of_objects[index].x, y: points_of_objects[index].y - 15)
        }
        var object_temp: [CGPoint] = []
        for point in points_of_objects {
            if point.y >= 0 {
                object_temp.append(point)
            }
        }
        points_of_objects = object_temp
    }
    
    // displays objects
    func display_objects() -> [CGPath] {
        var objects: [CGPath] = []
        let shape      = CAShapeLayer()
    
        // creates path
        for center in points_of_objects {
            shape.path = UIBezierPath(ovalIn: CGRect(x: center.x, y: center.y, width: 5, height: 5)).cgPath
            objects.append(shape.path!)
        }
        return objects
    }
    
    // makes block
    func block_make() {
        let x = CGFloat.random(in: UIScreen.main.bounds.width / 8 ... UIScreen.main.bounds.width / 8 * 7)
        for index in 0..<points_of_blocks.count {
            if abs(points_of_blocks[index].x - x) <= 20 && abs(points_of_blocks[index].y - UIScreen.main.bounds.height / 8) <= 20 {
                return
            }
        }
        points_of_blocks.append(CGPoint(x: x, y: UIScreen.main.bounds.height / 8))
    }
    
    // makes block move
    func block_moving() {
        for index in 0..<points_of_blocks.count {
            points_of_blocks[index] = CGPoint(x: points_of_blocks[index].x, y: points_of_blocks[index].y + 15)
        }
        block_temp = []
        for point in points_of_blocks {
            if point.y <= UIScreen.main.bounds.height / 4 * 3 - 45 {
                block_temp.append(point)
            }
        }
        if block_temp.count < points_of_blocks.count {
            return
        }
        points_of_blocks = block_temp
    }
    
    // displays objects
    func display_blocks() -> [CGPath] {
        var block: [CGPath] = []
        let shape           = CAShapeLayer()
    
        for center in points_of_blocks {
            shape.path      = UIBezierPath(rect: CGRect(x: center.x, y: center.y, width: 20, height: 20)).cgPath
            block.append(shape.path!)
        }
        return block
    }
    
    // collisions
    func collide() {
        var index_of_object = 0
        var index_of_block  = 0
        outerloop:
        for object in points_of_objects {
            index_of_object += 1
            index_of_block  = 0
            for block in points_of_blocks {
                if abs(object.x - block.x) <= 12.5 && abs(object.y - block.y) <= 12.5 {
                    if index_of_object < points_of_objects.count && index_of_block < points_of_blocks.count {
                        points_of_objects.remove(at: index_of_object)
                        points_of_blocks.remove(at: index_of_block)
                        score += 1
                        break outerloop
                    }
                }
                index_of_block += 1
            }
        }
    }
    
    // returns the score
    func return_score() -> String {
        return String(score)
    }
    
    // restarts the game
    func restart() {
        position_of_ship  = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4 * 3)
        points_of_ship    = []
        tip               = CGPoint(x: 0, y: 0)
        points_of_objects = []
        points_of_blocks  = []
        score             = 0
        block_temp        = []
        set_points()
    }
}
