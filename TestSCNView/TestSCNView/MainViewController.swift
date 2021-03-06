//
//  MainViewController.swift
//  TestSCNView
//
//  Created by Zhang xiaosong on 2018/4/9.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - life cycl


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let alertView = UIAlertController(title: "提示", message: "请站在原地对准地面，我们将为您加载导航", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (cancelAction) in
//            
//        }
//        alertView.addAction(cancelAction)
////        alertView.show(self, sender: nil)
//        self.present(alertView, animated: true) {
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - IBAction
    
    //MARK:  ScenceKit 3D立体
    @IBAction func goSCNView(_ sender: Any){
        let scnViewController = SCNViewController()
        self.navigationController?.pushViewController(scnViewController, animated: true)
    }
    
    //MARK: 向墙上添加 壁画
    @IBAction func gotoArtPic (_ sender: Any){
        print("0")
        let artTreeView = ArtTreeViewController()
        artTreeView.arIndex = 0
        self.navigationController?.pushViewController(artTreeView, animated: true)
    }
    
    //MARK: 平面检测 /视觉效果 
    @IBAction func goDetectionPlane (_ sender: Any) {
        let detectionPlaneViewController = DetectionPlaneViewController()
        self.navigationController?.pushViewController(detectionPlaneViewController, animated: true)
    }
    
    @IBAction func gotoPlaneBox (_ sender: Any) {
        let boxController = SCNBoxViewController()
        self.navigationController?.pushViewController(boxController, animated: true)
    }
    
    @IBAction func gotoCompass (_ sender: Any) {
        let compassController = CompassViewController()
        self.navigationController?.pushViewController(compassController, animated: true)
    }
    
    @IBAction func gotoImageDistinguish (_ sender: Any) {
        let imageDistinguish = ImageDistinguishViewController()
        self.navigationController?.pushViewController(imageDistinguish, animated: true)
    }
    
    @IBAction func gotoChangeWorldOrign (_ sender: Any) {
        let changeWorldOrign = ChangeWorldOriginViewController()
        self.navigationController?.pushViewController(changeWorldOrign, animated: true)
    }
    

}
