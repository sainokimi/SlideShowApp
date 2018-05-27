//
//  ViewController.swift
//  SlideshowApp
//
//  Created by 菅原俊彦 on 2018/05/22.
//  Copyright © 2018年 sainokimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    //画像を配列に保持
    let testImage: [String] = [
        "ACS_wp_a_1536_2048",
        "ACS_wp_b_1536_2048",
        "ACS_wp_c_1920_1080",
        "ACS_wp_d_1366_768"
    ]
    
    var index: Int = 0  //表示する画像のインデックス(配列内の先頭画像を指定)
    
    var timer: Timer!   //タイマインスタンス保持用
    var timerVal: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //再生/停止ボタン状態初期化
        ppButtonInit()
        
        //アプリ起動直後の最初の画像を表示
        displayImage(idx: self.index)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画像を画面に表示（画面１）
    func displayImage(idx: Int) {
        
        //画面に画像を出力
        slideImage.image = UIImage(named: testImage[idx])
        
    }
    
    //「進む」ボタンを押したとき
    @IBAction func pushFwButton(_ sender: Any) {
        
        //表示画像指定インデックスを+1
        self.index += 1
        
        //画像指定インデックスの上限判定
        if ( self.index > testImage.count - 1) {
            self.index = 0
        }
        
        //更新したインデックスで指定した画像を表示
        displayImage(idx: self.index)
        
    }
    
    @IBAction func pushBwButton(_ sender: Any) {
        
        //表示画像指定インデックスを-1
        self.index -= 1
        
        //画像指定インデックスの下限判定
        if ( self.index < 0 ) {
            self.index = (testImage.count - 1)
        }
        
        //更新したインデックスで指定した画像を表示
        displayImage(idx: self.index)
    }
    
    func ppButtonInit() {
        playPauseButton.setTitle("再生", for: .normal)
    }
    
    @IBAction func ppButtonWork(_ sender: Any) {
        
        if ( playPauseButton.currentTitle == "再生" ) {   //スライドショーの開始
            
            //2秒間隔を計測するタイマを生成、始動
            if ( self.timer == nil ) {
                self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
            }
            
            //ボタンのタイトルを変更
            playPauseButton.setTitle("停止", for: .normal)
            
            //"進む"ボタンと"戻る"ボタンを無効化
            self.forwardButton.isEnabled = false
            self.backwardButton.isEnabled = false
            
            //2秒間隔を計測するタイマを生成、始動 -> @objc属性ではなく、@IBActionを指定しても動く？
            //Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(pushFwButton), userInfo: nil, repeats: true)
            
        } else {    //スライドショーの停止
            
            //タイマを破棄
            if ( self.timer != nil ) {
                self.timer.invalidate()
                self.timer = nil
            }
            
            //ボタンのタイトルを変更
            playPauseButton.setTitle("再生", for: .normal)
            
            //"進む"ボタンと"戻る"ボタンを有効化
            self.forwardButton.isEnabled = true
            self.backwardButton.isEnabled = true
            
        }
        
    }
    
    @objc func nextImage() {
        
        //スライドショーで表示する画像の表示
        displayImage(idx: self.index)
        
        //次に表示する画像を指定するようにインデックスを+1
        self.index += 1
        
        //画像指定インデックスの上限判定
        if ( self.index > testImage.count - 1) {
            self.index = 0
        }
        
    }

    
    @IBAction func tapCloseUpShow(_ sender: AnyObject) {
        
        //拡大画面に遷移
        performSegue(withIdentifier: "closeUpShow", sender: nil)
        
    }
    
    @IBAction func unwind (_ segue: UIStoryboardSegue ) {
        
    }

}



