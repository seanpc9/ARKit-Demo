//
//  EarthViewController.swift
//  ARKitPresentation
//
//  Created by Kyle Blazier on 9/30/18.
//  Copyright © 2018 Kyle Blazier. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class EarthViewController: BaseSceneViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addEarth()
    }
    
    private func addEarth() {
        // Create a sphere
        let sphere = SCNSphere(radius: 0.3)
        
        // Add the JPG of the Earth as a material to cover the sphere
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named :"earth.jpg")
        sphere.firstMaterial = material
        
        // Create a Scene node with this sphere
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0, 0, -1.5)
        
        // Create an action to rotate the sphere
        let rotateAction = SCNAction.rotateBy(x: 0, y: 0.25, z: 0, duration: 1.0)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        sphereNode.runAction(repeatAction)
                
        // Add this node to the scene to make it appear
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
}
