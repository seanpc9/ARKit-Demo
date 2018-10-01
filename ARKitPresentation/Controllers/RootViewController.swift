//
//  RootViewController.swift
//  ARKitPresentation
//
//  Created by Kyle Blazier on 9/30/18.
//  Copyright © 2018 Kyle Blazier. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    private enum SceneType: Int {
        // Note: not 0 indexed because this will be used for a button's tag and the default
        //  value for tag is 0
        case earth = 1
        case text = 2
        case bear = 3
    }
    
    @IBOutlet var earthSceneButton: UIButton!
    @IBOutlet var textSceneButton: UIButton!
    @IBOutlet var bearSceneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        earthSceneButton.tag = SceneType.earth.rawValue
        textSceneButton.tag = SceneType.text.rawValue
        bearSceneButton.tag = SceneType.bear.rawValue
        
        for button in [earthSceneButton, textSceneButton, bearSceneButton] {
            button?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button?.layer.cornerRadius = 20
        }
        
        // Disable automatic screen sleep
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard let selectedScene = SceneType(rawValue: sender.tag) else {
            print("Unknown Scene selected")
            return
        }
        
        let viewController: UIViewController
        switch selectedScene {
        case .earth:
            viewController = EarthViewController()
        case .text:
            viewController = TextViewController()
        case .bear:
            viewController = BearViewController()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
