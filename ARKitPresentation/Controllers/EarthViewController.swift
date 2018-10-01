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
        
        sceneView.autoenablesDefaultLighting = false
        sceneView.automaticallyUpdatesLighting = false
    }
    
    override func sceneTapped(at touchPoint: CGPoint) {
        addEarth()
    }
    
    private func addEarth() {
        // Create a sphere
        let sphere = SCNSphere(radius: 0.3)
        
        // Color the sphere
        sphere.firstMaterial?.diffuse.contents = UIColor.orange
        
        // Add the JPG of the Earth as a material to cover the sphere
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named :"earth.jpg")
//        sphere.firstMaterial = material
        
        // Create a Scene node with this sphere
        //  Note that this point is 1.5 meters away from the origin of the scene always!
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0, 0, -1.5)
        
        // Create an action to rotate the sphere
//        let rotateAction = SCNAction.rotateBy(x: 0, y: 0.25, z: 0, duration: 1.0)
//        let repeatAction = SCNAction.repeatForever(rotateAction)
//        sphereNode.runAction(repeatAction)
        
        // Add this node to the scene to make it appear
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
//        addLight()
    }
    
    private func addLight() {
        // Create a scene light
        let light = SCNLight()
        light.type = .spot
        light.spotInnerAngle = 45
        light.spotOuterAngle = 45
        
        // Create the light node and position it above the sphere
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 1.5, -1.5)
        lightNode.eulerAngles = SCNVector3((-(Double.pi)) / 2, 0, 0)
        
        // Add the light node to the scene
        sceneView.scene.rootNode.addChildNode(lightNode)
    }
}
