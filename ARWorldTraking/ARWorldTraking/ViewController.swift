//
//  ViewController.swift
//  ARWorldTraking
//
//  Created by GoldenCentury on 2018/3/27.
//  Copyright © 2018年 GC. All rights reserved.
//

//AR世界追踪

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController,ARSCNViewDelegate {
    
    var scnView = ARSCNView()//AR视图
    var sessionConfig: ARConfiguration? //会话配置
    var maskView = UIView() // 遮罩视图
    var tipLabel = UILabel()//提示标签
    var infoLabel = UILabel() //信息展示标签

    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutMySubItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {//判断是否支持6个自由度
            let worldTracking = ARWorldTrackingConfiguration()//6DOF【3个旋转轴 3个平移轴】
            worldTracking.planeDetection = .horizontal
            worldTracking.isLightEstimationEnabled = true
            sessionConfig = worldTracking
        }
        else {
            let orientationTracking = AROrientationTrackingConfiguration()//3DOF 【3个旋转轴】
            sessionConfig = orientationTracking
            tipLabel.text = "当前设备不支持6DOF跟踪"
        }
        scnView.session.run(sessionConfig!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scnView.session.pause()
    }

    
    //MARK: - 布局
    
    func layoutMySubItems()
    {
        scnView.frame = self.view.frame
        self.view.addSubview(scnView)
        scnView.delegate = self
        scnView.showsStatistics = true
        
        maskView.frame = self.view.frame
        maskView.backgroundColor = UIColor.white
        maskView.alpha = 0.6
        self.view.addSubview(maskView)
        
        self.view.addSubview(tipLabel)
        tipLabel.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 50)
        tipLabel.textColor = UIColor.black
        tipLabel.numberOfLines = 0
        
        self.view.addSubview(infoLabel)
        infoLabel.frame = CGRect(x: 0, y: tipLabel.frame.origin.y + tipLabel.frame.size.height + 5, width: self.view.frame.size.width, height: 150)
        infoLabel.numberOfLines = 0
        infoLabel.textColor = UIColor.black
        
    }
    
    //MARK: - ARSCNViewDelegate
    
    //相机状态变化
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //判断状态
        switch camera.trackingState{
        case .notAvailable:
            tipLabel.text = "跟踪不可用"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.7
            }
        case .limited(ARCamera.TrackingState.Reason.initializing):
            let title = "有限的跟踪，原因是："
            let desc = "正在初始化，请稍后"
            tipLabel.text = title + desc
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.6
            }
        case .limited(ARCamera.TrackingState.Reason.relocalizing):
            tipLabel.text = "有限的跟踪，原因是：重新初始化"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.6
            }
        case .limited(ARCamera.TrackingState.Reason.excessiveMotion):
            tipLabel.text = "有限的跟踪，原因是：设备移动过快请注意"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.6
            }
        case .limited(ARCamera.TrackingState.Reason.insufficientFeatures):
            tipLabel.text = "有限的跟踪，原因是：提取不到足够的特征点，请移动设备"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.6
            }
        case .normal:
            tipLabel.text = "跟踪正常"
            UIView.animate(withDuration: 0.5) {
                self.maskView.alpha = 0.6
            }
//        default:
//            print("cameraDidChange unknow")
//        }
        }
    }
        
        //会话被中断
    func sessionWasInterrupted()
    {
        
        tipLabel.text = "会话中断"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        tipLabel.text = "会话中断结束，已重置会话"
        scnView.session.run(self.sessionConfig!, options: .resetTracking)
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        print(error.localizedDescription)
        tipLabel.text  = error.localizedDescription
    }
    
    //MARK: - 触控
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //当用户点击屏幕时，取出会话输出的帧
        var transform = self.scnView.session.currentFrame!.camera.transform
        
        var infoStr = String()
        for index in 0..<4 {
            if index == 0 {
                infoStr.append("\(transform.columns.0.x) , \(transform.columns.0.y) , \(transform.columns.0.z) , \(transform.columns.0.w)")
            }
            else if index == 1 {
                infoStr.append("\n \(transform.columns.1.x) , \(transform.columns.1.y) , \(transform.columns.1.z) , \(transform.columns.1.w)")
            }
            else if index == 2 {
                infoStr.append("\n \(transform.columns.2.x) , \(transform.columns.2.y) , \(transform.columns.2.z) , \(transform.columns.2.w)")
            }
            else if index == 3 {
                infoStr.append("\n \(transform.columns.3.x) , \(transform.columns.3.y) , \(transform.columns.3.z) , \(transform.columns.3.w)")
            }
        }
        
        infoLabel.text = infoStr
        
    }
    
    

}

