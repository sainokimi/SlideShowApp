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
    
//    var imageView: UIImageView!
    
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
            
            imageView.contentMode = .scaleAspectFit
            
            // UIScrollViewのインスタンスに画像を貼付ける
            self.slideImage.addSubview(imageView)
        }
        
        setupScrollImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //「進む」ボタンを押したとき
    @IBAction func pushFwButton(_ sender: Any) {
        
        nextImage()

    }
    
    //「戻る」ボタンを押したとき
    @IBAction func pushBwButton(_ sender: Any) {
        
        //スライドさせる位置の計算
        var offset: CGPoint = CGPoint(x: slideImage.contentOffset.x - slideImage.frame.size.width, y: 0)
        
        //現在位置が左端のとき、右端の位置を設定
        if offset.x < 0 {
            offset = CGPoint(x: slideImage.bounds.size.width * CGFloat(testImage.count), y: 0)
        }
        
        //表示画像の切り替え（スライド）
        slideImage.setContentOffset(offset, animated: true)

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
        
        //スライドさせる位置の計算
        var offset: CGPoint = CGPoint(x: slideImage.contentOffset.x + slideImage.frame.size.width, y: 0)
        
        //現在位置が右端のとき、左端の位置を設定
        if offset.x > slideImage.bounds.size.width * CGFloat(testImage.count) {
            offset = CGPoint(x: 0, y: 0)
        }
        
        //表示する画像の切り替え（スライド）
        slideImage.setContentOffset(offset, animated: true)
        
    }

    //画像領域タップで、拡大表示画面へ遷移
    @IBAction func tapCloseUpShow(_ sender: Any) {
        
        //拡大画面に遷移
        performSegue(withIdentifier: "closeUpShow", sender: testImage)
        
    }
    
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {

        if ( segue.identifier == "closeUpShow" ) {
            let closeUpShowViewController = segue.destination as! CloseUpViewController
            closeUpShowViewController.rcvImage = sender as! [String]
            closeUpShowViewController.imagePos = Int(slideImage.contentOffset.x / slideImage.bounds.size.width) + 1
            
        }
    }

    @IBAction func unwind (_ segue: UIStoryboardSegue ) {

    }
    
    func setupScrollImage() {
        
        for imageView: UIImageView in slideImage.subviews as! [UIImageView]  {
            
            var viewFrame: CGRect = imageView.frame
            viewFrame.origin = CGPoint(x: px, y: py)
            imageView.frame = viewFrame
            
            px += (slideImage.frame.size.width)
                
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


