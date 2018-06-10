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
    
    var imageWidth: CGFloat!
    var imageHeight: CGFloat!
    var screenSize: CGRect!
    
    // 描画開始の x,y 位置
    var px: CGFloat = 0.0
    var py: CGFloat = 0.0
    
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
        
        //画面サイズを取得
        screenSize = UIScreen.main.bounds
        
        //ページ単位のスクロールにするため、ScrollScreenの幅を画面の幅と同じにする
        scrollScreenWidth = screenSize.width
        
        pageNum = testImage.count  //表示予定の画像数分のページ

        scrollScreenHeight = slideImage.bounds.size.height
        
        //描画開始位置の設定
        initializeStartDrawPoint(x: slideImage.bounds.origin.x, y: slideImage.bounds.origin.y)
        
        for i in 0 ..< pageNum {
            let image: UIImage = UIImage(named: testImage[i])!
            let imageView = UIImageView(image: image)
            
            var rect:CGRect = imageView.frame
            rect.size.height = scrollScreenHeight
            rect.size.width = scrollScreenWidth
            
            imageView.frame = rect
            imageView.tag = i + 1
            
            // UIScrollViewのインスタンスに画像を貼付ける
            self.slideImage.addSubview(imageView)
        }
        
        setupScrollImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画像を画面に表示（画面１）
    func displayImage(idx: Int) {
        

        
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
    
    //「戻る」ボタンを押したとき
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
        
        if ( slideImage.frame.size.width > px ) {
            px = 0.0
        } else {
            px += (slideImage.frame.size.width)
        }
       
    }

    //画像領域タップで、拡大表示画面へ遷移
    @IBAction func tapCloseUpShow(_ sender: Any) {
        
        //拡大画面に遷移
        performSegue(withIdentifier: "closeUpShow", sender: self.testImage[index])
        
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {

        if ( segue.identifier == "closeUpShow" ) {
            let closeUpShowViewController = segue.destination as! CloseUpViewController
            closeUpShowViewController.rcvImage = sender as! String?
            
        }
    }

    @IBAction func unwind (_ segue: UIStoryboardSegue ) {

    }
    
    func setupScrollImage() {
        
        let imageDummy: UIImage = UIImage(named: testImage[0])!
        var imgView = UIImageView(image:imageDummy)
        var subviews: Array = slideImage.subviews
        
        for i in 0 ..< subviews.count {
            imgView = subviews[i] as! UIImageView
            if (imgView.isKind(of: UIImageView.self) && imgView.tag > 0){
                
                var viewFrame: CGRect = imgView.frame
                viewFrame.origin = CGPoint(x: px, y: py)
                imgView.frame = viewFrame
                
                px += (slideImage.frame.size.width)
                
            }
        }
        // UIScrollViewのコンテンツサイズを画像のtotalサイズに合わせる
        let nWidth: CGFloat = scrollScreenWidth * CGFloat(pageNum)
        slideImage.contentSize = CGSize(width: nWidth, height: scrollScreenHeight)
    }
    
    func initializeStartDrawPoint ( x: CGFloat, y: CGFloat ) {
        px = x
        py = y
    }
    
    
}


