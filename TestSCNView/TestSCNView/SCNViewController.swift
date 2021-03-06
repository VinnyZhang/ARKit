//
//  SCNViewController.swift
//  TestSCNView
//
//  Created by Zhang xiaosong on 2018/4/10.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

/// ScenceKit 3D立体
class SCNViewController: UIViewController,ARSCNViewDelegate {

     var sceneView = ARSCNView()
    
    var changeSkin = UIButton()
    
    
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.frame = self.view.frame
        
        self.view.addSubview(sceneView)
        
        //Set the view's delegate
        sceneView.delegate = self
        
        //Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        changeSkin.frame = CGRect(x: 20, y: self.view.frame.size.height - 100, width: self.view.frame.size.width - 40, height: 50)
        self.view.addSubview(changeSkin)
        changeSkin.setTitle("换肤", for: .normal)
        changeSkin.setTitleColor(UIColor.blue, for: .normal)
        changeSkin.addTarget(self, action: #selector(changeSkin(_:)), for: .touchUpInside)
        
        
        //Create a new scene
//        let scene = SCNScene(named:"art.scnassets/test11.scn")!
        let scene = SCNScene(named: "art.scnassets/flight.scn")!
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
//        scene.rootNode.childNodes.last?.position = SCNVector3Make(0, 0, -20)

        
        
//      添加3D立方体
//        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
//        let material = SCNMaterial()
//        let img = UIImage(named: "gc.png")
//        material.diffuse.contents = img
////        boxGeometry.materials
//        material.lightingModel = .physicallyBased
//        boxGeometry.materials = [material]
//
//        let boxNode = SCNNode(geometry: boxGeometry)
//
//
//
//        boxNode.position = SCNVector3Make(-0.5, 0, -0.5)
//        sceneView.scene.rootNode.addChildNode(boxNode)
//
//        sceneView.autoenablesDefaultLighting = true
        
        //Set the scene to the view
        sceneView.scene = scene
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Create a session configuration
        var configuration : ARConfiguration!
        if ARWorldTrackingConfiguration.isSupported {
            configuration = ARWorldTrackingConfiguration()//6DOF【3个旋转轴 3个平移轴】
//            configuration.worldAlignment = .gravity
            
        }
        else {
            configuration = AROrientationTrackingConfiguration()//3DOF 【3个旋转轴】
        }

        //Run the view's session
        sceneView.session.run(configuration)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Present an error message to the user")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Inform the user that the session has been interrupted,for example,by presenting an overlay")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Reset tracking and/or remove existing anchors if consistent tracking is required")
    }
    
    
    
    @objc func changeSkin(_ sender: Any){
        
        let material2 = SCNMaterial()
        let imager = UIImage(named: "gc.png")
        material2.diffuse.contents = imager
        
        let shipNode = self.sceneView.scene.rootNode.childNodes.first?.childNodes.first
        shipNode?.geometry?.materials = [material2]
        
    }
    

}
