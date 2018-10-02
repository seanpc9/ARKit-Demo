//
//  BearViewController.swift
//  ARKitPresentation
//
//  Created by Kyle Blazier on 9/30/18.
//  Copyright © 2018 Kyle Blazier. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class BearViewController: BaseSceneViewController {
    
    private lazy var toggleShootModeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Enable shooting", for: .normal)
        button.setTitle("Disable shooting", for: .selected)
        button.backgroundColor = UIColor.willowTreeTeal
        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.addTarget(self, action: #selector(toggleModePressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var shootingEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()

        addToggleButton()
    }
    
    private func addToggleButton() {
        view.addSubview(toggleShootModeButton)
        view.safeAreaLayoutGuide.bottomAnchor
            .constraint(equalTo: toggleShootModeButton.bottomAnchor, constant: 40).isActive = true
        toggleShootModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func sceneTapped(at touchPoint: CGPoint) {
        if shootingEnabled {
            shoot()
        } else {
            if let hitTestResult = sceneView.hitTest(touchPoint, types: .existingPlane).first {
                addBear(with: hitTestResult)
            }
        }
    }
    
    private func addBear(with hitTestResult: ARHitTestResult) {
        // Create a scene with a 3D model of a bear
        let bearScene = SCNScene(named: "bear.dae")!
        
        // Grab the actual bear object from the 3D model (ignoring other objects in the model)
        let bearNode = bearScene.rootNode.childNode(withName: "bear", recursively: true)!
        
        // Scale down the bear since it's too large
        bearNode.scale = SCNVector3(0.08, 0.08, 0.08)
        
        // Add physics to the bear
        bearNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        bearNode.physicsBody?.categoryBitMask = BodyType.bear.rawValue
        
        // Position the bear relative to the hit test point
        let hitTestWorldTransform = hitTestResult.worldTransform.columns.3
        bearNode.position = SCNVector3(hitTestWorldTransform.x,
                                       hitTestWorldTransform.y,
                                       hitTestWorldTransform.z)
        
        // Add this node to the scene
        sceneView.scene.rootNode.addChildNode(bearNode)
    }
    
    private func shoot() {
        // Get the current frame of the scene session
        guard let currentFrame = self.sceneView.session.currentFrame else { return }
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.3
        
        // Create a box to shoot
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        // Add a material to the box to color it green
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        box.firstMaterial = material
        
        // Create a scene node with the box object we just created
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "Bullet"
        
        // Add physics to the box
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.categoryBitMask = BodyType.bullet.rawValue
        boxNode.physicsBody?.isAffectedByGravity = false
        boxNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
        // Most importantly, add a force vector to the box so that it will actually shoot forward
        let forceVector = SCNVector3(boxNode.worldFront.x * 2,
                                     boxNode.worldFront.y * 2,
                                     boxNode.worldFront.z * 2)
        boxNode.physicsBody?.applyForce(forceVector, asImpulse: true)
        
        // Add this box node to the scene
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    @objc private func toggleModePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        shootingEnabled = sender.isSelected
    }
}
