//
//  ChangeWorldOriginViewController.swift
//  TestSCNView
//
//  Created by Zhang xiaosong on 2018/5/9.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

/// 改变世界原点
class ChangeWorldOriginViewController: ARSCNBaseViewController {

    var node: SCNNode!
    
    var changeWorldOrignBtn: UIButton!
    
    /// MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        changeWorldOrignBtn = UIButton(frame: CGRect(x: 20, y: self.view.frame.size.height - 100, width: self.view.frame.size.width - 40, height: 50))
        changeWorldOrignBtn.setTitle("改变世界坐标", for: .normal)
        changeWorldOrignBtn.setTitleColor(UIColor.blue, for: .normal)
        self.view.addSubview(changeWorldOrignBtn)
        changeWorldOrignBtn.addTarget(self, action: #selector(changeWorldOrigin), for: .touchUpInside)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /// MARK: - 重构
    // 配置会话
    override func setupSession() {
        if ARWorldTrackingConfiguration.isSupported {//判断是否支持6个自由度
            let worldTracking = ARWorldTrackingConfiguration()
            worldTracking.planeDetection = .horizontal//平面检测
            worldTracking.isLightEstimationEnabled = true //光估计
            sessionConfiguration = worldTracking
        }
        else{
            let orientationTracking = AROrientationTrackingConfiguration()//3DOF
            sessionConfiguration = orientationTracking
        }
        gameView.session.run(sessionConfiguration)
        
        addBoxNode()
        
    }
    
    
    /// MARK: - ARSCNViewDelegate
    

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let anchor = anchor as? ARPlaneAnchor else {
            return nil
        }
        
//        gameView.session.setWorldOrigin(relativeTransform: anchor.transform)
//        var translation = matrix_identity_float4x4
        
        
        
        
        
        return nil
        
    }
    
    
    /// 添加立方体
    private func addBoxNode() {
        let geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        let material1 = SCNMaterial()
        material1.diffuse.contents = UIColor.gray
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.blue
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIColor.yellow
        let material4 = SCNMaterial()
        material4.diffuse.contents = UIColor.brown
        let material5 = SCNMaterial()
        material5.diffuse.contents = UIColor.black
        geometry.materials = [material,material1,material2,material3,material4,material5]
        
        node = SCNNode(geometry: geometry)
        node.position = SCNVector3Make(0.0, 0.0, 0.0)
        gameView.scene.rootNode.addChildNode(node)
        
    }
    
    
    @objc func changeWorldOrigin() {
        let matrix4_X = SCNMatrix4MakeRotation(0.0, 1.0, 0.0, 0.0)
        let matrix4_Y = SCNMatrix4MakeRotation(0.0, 0.0, 1.0, 0.0)
        let matrix4_Z = SCNMatrix4MakeRotation(0.0, 0.0, 0.0, 1.0)
        let matrix4_T = SCNMatrix4MakeTranslation(0.1, 0.1, -0.1)
        
        let mXY =  SCNMatrix4Mult(matrix4_X, matrix4_Y)
        let mXYZ = SCNMatrix4Mult(mXY, matrix4_Z)
        let mT = SCNMatrix4Mult(mXYZ, matrix4_T)
        
        gameView.session.setWorldOrigin(relativeTransform: simd_float4x4(mT))
    }
    
    
    

}
