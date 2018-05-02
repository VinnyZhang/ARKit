//
//  CompassViewController.swift
//  TestSCNView
//
//  Created by Zhang xiaosong on 2018/4/27.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation

/// 指南针
class CompassViewController: UIViewController {

    var sceneView = ARSCNView()
    var configuration: ARConfiguration?
    var compassImage = UIImageView()
    var CLManager = CLLocationManager()
    
    /// MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScene()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScene() {
        
        sceneView.frame = self.view.frame
        self.view.addSubview(sceneView)
        sceneView.autoenablesDefaultLighting = true
        // 开启 debug 选项以查看世界原点并渲染所有 ARKit 正在追踪的特征点
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // 设置 ARSCNViewDelegate——此协议会提供回调来处理新创建的几何体
        sceneView.delegate = self
        

        self.view.addSubview(compassImage)
        compassImage.frame = CGRect(x: (self.view.frame.size.width - 160)/2, y: self.view.frame.size.height - 200, width: 160.0, height: 160.0)
        compassImage.image = UIImage(named: "compass")
        
        CLManager.delegate = self
        CLManager.startUpdatingHeading()
        
        
    }
    
    func setupSession()
    {
        if ARWorldTrackingConfiguration.isSupported {
            let worldTracking = ARWorldTrackingConfiguration()
//            worldTracking.planeDetection = .horizontal
            worldTracking.isLightEstimationEnabled = true
            self.configuration = worldTracking
        }
        else{
            let orientationTracking = AROrientationTrackingConfiguration()
            self.configuration = orientationTracking
        }
        
        // 运行 view 的 session
        sceneView.session.run(self.configuration!)
        
        
    }

}

// MARK: - CLLocationManagerDelegate

extension CompassViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading.headingAccuracy > 0 else {
            return
        }
//        获取设备方向
//        1度 = pi/180度
//        弧度 = 弧长 / 半径
//        周长 = 2*pi*半径
        let direction = newHeading.magneticHeading// 0 - 359.9度，0为磁北
        let angle = direction/180.0 * .pi //计算上北偏移的弧长
        
        UIView.animate(withDuration: 0.3) {
            self.compassImage.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
        }
        
    }
}

// MARK: - ARSCNViewDelegate
extension CompassViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    /**
     实现此方法来为给定 anchor 提供自定义 node。
     
     @discussion 此 node 会被自动添加到 scene graph 中。
     如果没有实现此方法，则会自动创建 node。
     如果返回 nil，则会忽略此 anchor。
     @param renderer 将会用于渲染 scene 的 renderer。
     @param anchor 新添加的 anchor。
     @return 将会映射到 anchor 的 node 或 nil。
     */
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        return nil
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if self.sceneView.session.currentFrame != nil {
            DispatchQueue.main.async {
//                self.compassImage.transform = CGAffineTransform(rotationAngle: -CGFloat((self.sceneView.session.currentFrame?.camera.eulerAngles.y)!))
            }
        }
        
    }
    
    
    /**
     将新 node 映射到给定 anchor 时调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 映射到 anchor 的 node。
     @param anchor 新添加的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    /**
     使用给定 anchor 的数据更新 node 时调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 更新后的 node。
     @param anchor 更新后的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    /**
     从 scene graph 中移除与给定 anchor 映射的 node 时调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 被移除的 node。
     @param anchor 被移除的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        
    }
    
    /**
     将要用给定 anchor 的数据来更新时 node 调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 即将更新的 node。
     @param anchor 被更新的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
    }
    
    
}
