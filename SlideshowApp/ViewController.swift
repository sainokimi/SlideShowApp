//
//  ViewController.swift
//  SlideshowApp
//
//  Created by 菅原俊彦 on 2018/05/22.
//  Copyright © 2018年 sainokimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slideImage: UIScrollView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var scrollScreenHeight:CGFloat! // ScrollScreenの高さ
    var scrollScreenWidth:CGFloat!  // ScrollScreenの幅
    
    
    var pageNum: Int!    //ページ数
    
    //画像（の名前）を配列に保持
    let testImage: [String] = [
        "ACS_wp_a_1536_2048",
        "ACS_wp_b_1536_2048",
        "ACS_wp_c_1920_1080",
        "ACS_wp_d_1366_768"
    ]
    
    var timer: Timer!       //タイマインスタンス保持用
    var timerVal: Int = 0   //タイマの割り込み時間
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //再生/停止ボタン状態初期化
        ppButtonInit()
        
        //ページ単位のスクロールにするため、ScrollScreenの幅を画面の幅と同じにする
        scrollScreenWidth = UIScreen.main.bounds.width
        
        pageNum = testImage.count  //表示予定の画像数分のページ

        scrollScreenHeight = slideImage.bounds.size.height
        
        //最初の画像の初期位置（中央座標）を設定
        var imageCenterPointX: CGFloat = scrollScreenWidth / CGFloat(2)
        let imageCenterPointY: CGFloat = scrollScreenHeight
        
        //画像を数分だけ配置
        for imageName in testImage {
            let image: UIImage = UIImage(named: imageName)!
            let imageView = UIImageView(image: image)
            
            imageView.center = CGPoint(x: imageCenterPointX, y: imageCenterPointY / CGFloat(2))
            imageView.bounds.size = CGSize(width: scrollScreenWidth, height: scrollScreenHeight)
            imageView.contentMode = .scaleAspectFit
            
            // UIScrollViewのインスタンスに画像を貼付ける
            slideImage.addSubview(imageView)
            
            imageCenterPointX = imageCenterPointX + scrollScreenWidth
        }

        slideImage.contentSize = CGSize(width: scrollScreenWidth * CGFloat(pageNum), height: scrollScreenHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //「進む」ボタンを押したとき
    @IBAction func pushFwButton(_ sender: Any) {
        
        nextImage()

    }
    
    //次の画像を表示（右に1ページ分スライドさせる）
    @objc func nextImage() {
        
        //スライドさせる位置の計算
        var offset: CGPoint = CGPoint(x: slideImage.contentOffset.x + slideImage.frame.size.width, y: 0)
        
        //現在位置が右端のとき、左端の位置を設定
        if offset.x > slideImage.bounds.size.width * CGFloat(testImage.count - 1) {
            offset = CGPoint(x: 0, y: 0)
        }
        
        //表示する画像の切り替え（スライド）
        slideImage.setContentOffset(offset, animated: true)
        
    }
    
    //「戻る」ボタンを押したとき
    @IBAction func pushBwButton(_ sender: Any) {
        
        //スライドさせる位置の計算
        var offset: CGPoint = CGPoint(x: slideImage.contentOffset.x - slideImage.frame.size.width, y: 0)
        
        //現在位置が左端のとき、右端の位置を設定
        if offset.x < 0 {
            offset = CGPoint(x: slideImage.bounds.size.width * CGFloat(testImage.count - 1), y: 0)
        }
        
        //表示画像の切り替え（スライド）
        slideImage.setContentOffset(offset, animated: true)

    }
    
    //「再生/停止」ボタンに表示されるテキストの初期化
    func ppButtonInit() {
        playPauseButton.setTitle("再生", for: .normal)
    }
    
    //「再生/停止」ボタンを押したとき
    @IBAction func ppButtonWork(_ sender: Any) {
        
        if playPauseButton.currentTitle == "再生"  {   //スライドショーの開始
            
            //2秒間隔を計測するタイマを生成、始動
            if ( self.timer == nil ) {
                self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
            }

            //ボタンのタイトルを変更
            playPauseButton.setTitle("停止", for: .normal)
            
            //"進む"ボタンと"戻る"ボタンを無効化
            buttonEnableSwitch(flag: false)
            
            
        } else {    //スライドショーの停止
            
            //タイマを破棄
            if ( self.timer != nil ) {
                self.timer.invalidate()
                self.timer = nil
            }
            
            //ボタンのタイトルを変更
            playPauseButton.setTitle("再生", for: .normal)
            
            //"進む"ボタンと"戻る"ボタンを有効化
            buttonEnableSwitch(flag: true)
            
        }
        
    }
    
    //「進む」、「戻る」ボタンの有効/無効を切り替え
    func buttonEnableSwitch( flag: Bool ) {
        
        self.forwardButton.isEnabled = flag     //「進む」ボタン
        self.backwardButton.isEnabled = flag    //「戻る」ボタン
        
    }

    //画像領域タップで、拡大表示画面へ遷移
    @IBAction func tapCloseUpShow(_ sender: Any) {
        
        //拡大画面に遷移
        performSegue(withIdentifier: "closeUpShow", sender: nil)
        
    }
    
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {

        if ( segue.identifier == "closeUpShow" ) {
            let closeUpShowViewController = segue.destination as! CloseUpViewController
            closeUpShowViewController.closeUpImageNames = testImage
            closeUpShowViewController.imageIndex = Int(round(slideImage.contentOffset.x / slideImage.bounds.size.width))
            
        }
    }

    @IBAction func unwind (_ segue: UIStoryboardSegue ) {

    }
    
}


