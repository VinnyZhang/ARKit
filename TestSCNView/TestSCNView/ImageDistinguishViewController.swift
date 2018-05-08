//
//  ImageDistinguishViewController.swift
//  TestSCNView
//
//  Created by Zhang xiaosong on 2018/5/7.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


/// 图片识别
class ImageDistinguishViewController: ARSCNBaseViewController {
    
    var distinguishImage = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /// MARK: - 多态
    override func setupSession() {
        if ARWorldTrackingConfiguration.isSupported {//判断是否支持6个自由度
            let worldTracking = ARWorldTrackingConfiguration()
            //            worldTracking.planeDetection = .//平面检测
            worldTracking.isLightEstimationEnabled = true //光估计
            worldTracking.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
            sessionConfiguration = worldTracking
        }
        else{
            let orientationTracking = AROrientationTrackingConfiguration()//3DOF
            sessionConfiguration = orientationTracking
        }
        gameView.session.run(sessionConfiguration, options: .removeExistingAnchors)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        let refrenceImage = imageAnchor.referenceImage
        if refrenceImage.name == "imagelog" {
            self.distinguishImage = true
        }
        if refrenceImage.name == "WechatIMG1" {
            DispatchQueue.main.async {
                self.addGeometry(imageAnchor: imageAnchor)
            }
            
        }
        
        
        
        
    }
    
    
    /// MARK: - private methods
    
    /// 添加3D立方体
    private func addGeometry(imageAnchor: ARImageAnchor) {
        //      添加3D立方体
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        let material = SCNMaterial()
        let img = UIImage(named: "gc.png")
        material.diffuse.contents = img
        material.lightingModel = .physicallyBased
        boxGeometry.materials = [material]
        
        let boxNode = SCNNode(geometry: boxGeometry)
    
        boxNode.position = SCNVector3Make(imageAnchor.transform.columns.3.x, imageAnchor.transform.columns.3.y, imageAnchor.transform.columns.3.z)
        gameView.scene.rootNode.addChildNode(boxNode)
    }
    
    
    /// 添加红包
    private func addNode() {
        for i in -2..<2 {
            for j in -2..<2 {
                let position = SCNVector3Make(Float(i*5 + self.getRandomNumber(from: -3, to: 3)), 30, Float(j*5 + self.getRandomNumber(from: -3, to: 3)))
                if(position.x != 0 && position.z != 0) {
                    initNote(withPosition: position)
                }
            }
        }
    }
    
    /// 获取一个随机整数，范围在【from，to）
    ///
    private func getRandomNumber(from: Int , to: Int) -> Int{
        var randomNum = Int(arc4random() % UInt32(to))
        randomNum += from
        return randomNum
    }
    
    
    /// 初始化红包
    ///
    private func initNote(withPosition position: SCNVector3) {
        let geometry = SCNBox(width: CGFloat(1.0), height: CGFloat(1.0), length: CGFloat(0.01), chamferRadius: CGFloat(0.0))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "honbao")
        geometry.materials = [material]
        let node = SCNNode(geometry: geometry)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        //设置力
        let X = Int(Int(arc4random_uniform(9)) - 4)
        let Y = Int(1)
        let Z = Int(Int(arc4random_uniform(9)) - 4)
        
        node.physicsBody?.applyForce(SCNVector3Make(Float(X), Float(Y), Float(Z)), asImpulse: true)
        node.position = position
        self.gameView.scene.rootNode.addChildNode(node)
    }
    
    func clean(){
        for node in gameView.scene.rootNode.childNodes {
            if node.presentation.position.y < -26.0 {
                
                node.removeFromParentNode()
                
            }
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if distinguishImage {
            self.addNode()
            self.clean()
        }
    }
    

}
