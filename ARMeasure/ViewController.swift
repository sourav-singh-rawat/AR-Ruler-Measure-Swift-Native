//
//  ViewController.swift
//  ARMeasure
//
//  Created by Sourav Singh Rawat on 22/11/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    var textNode = SCNNode()
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - ARSCNViewDelegate methods
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        print("did add")
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//
//        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
//
//        node.addChildNode(planeNode)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2 {
            
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            
            dotNodes = [SCNNode]()
            
            textNode.removeFromParentNode()
        }
        
        guard let touch = touches.first else {return}
        
        let touchLocation = touch.location(in: sceneView)
        
        let result = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneInfinite, alignment: .horizontal)
        
        guard let hitLocation = result else {return}
        
        createDot(hitLocation.direction.x, hitLocation.direction.y, hitLocation.direction.z)
    }
    
    
    //MARK: - Dot Methods
    
    func createDot(_ x:Float,_ y:Float,_ z:Float){
        let sphare = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        sphare.materials = [material]
        
        let node = SCNNode()
        node.position = SCNVector3(x, y, z)
        node.geometry = sphare
        
        sceneView.scene.rootNode.addChildNode(node)
        
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate(){
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2)+pow(b, 2)+pow(c, 2))
        
        createText(text: "\(abs(distance)*100)",atPosition: end.position)
        
//        createPlaneLine(start: start, end: end)
    }
    
    func createText(text: String,atPosition position:SCNVector3){
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y+0.01, position.z-0.1)
        textNode.scale = SCNVector3(0.01,0.01,0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    //MARK: - Plane Methods
    
    func createPlaneLine(start: SCNNode,end: SCNNode) {
        let plane = SCNPlane(width: CGFloat(end.position.x - start.position.x),height: 0.001)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        plane.materials = [material]
        
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(end.position.x, 0, start.position.x)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        planeNode.geometry = plane
        
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
}
