//
//  CloseUpViewController.swift
//  SlideshowApp
//
//  Created by 菅原俊彦 on 2018/05/27.
//  Copyright © 2018年 sainokimi. All rights reserved.
//

import UIKit

class CloseUpViewController: UIViewController {
    
    @IBOutlet weak var closeUpImage: UIImageView!
    
    var closeUpImageNames: [String]! = nil
    var imageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeUpImage.contentMode = .scaleAspectFit
        closeUpImage.image = UIImage(named: closeUpImageNames[imageIndex])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigationb

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
