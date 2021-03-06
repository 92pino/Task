//
//  ViewController.swift
//  20190507 TouchesBegan과제
//
//  Created by hyeoktae kwon on 07/05/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var second = CGPoint()
    var first = CGPoint() {
        didSet(old){
            second = old
        }
    }
    
    var countNum: Int = 0
    
    let count: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let location: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(count)
        view.addSubview(location)
        autoLayout()
        count.text = "count: 0"
        location.text = "Location: ()"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        first = (touches.first?.location(in: self.view))!
        
        if abs(second.x - first.x) > 10 || abs(second.y - first.y) > 10 {
            countNum = 1
        } else {
            countNum += 1
        }
        count.text = "count: \(countNum)"
        location.text = "Location: " + String(format: "%.1f", (touches.first?.location(in: self.view))!.x) + ", " + String(format: "%.1f", (touches.first?.location(in: self.view))!.y)
    }
    
    func autoLayout() {
        count.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        count.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        count.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        count.bottomAnchor.constraint(equalTo: location.topAnchor, constant: -20).isActive = true
        
        location.topAnchor.constraint(equalTo: count.bottomAnchor, constant: 20).isActive = true
        location.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        location.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }

}

