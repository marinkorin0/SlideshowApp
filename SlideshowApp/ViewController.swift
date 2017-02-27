//
//  ViewController.swift
//  SlideshowApp
//
//  Created by 小林真理子 on 2017/02/25.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // １枚目の画面の構造物．ボタン(next, back, play)と、画像
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var img: UIImage!// = nil 空が入ってもいいよ、でも落ちる
    var num: Int = 0//(-_-;)
    let maxPhoto: Int = 5 //最大５枚の写真、letは定数
    let photos = ["A", "B", "C", "D", "E"]//写真はA,B,C,D,Eを使います
    
    var timer: Timer! //タイマーアプリ
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.img = UIImage(named: photos[num])//UIImageの写真
        imageView.image = self.img
        imageView.isUserInteractionEnabled = true//tapした時の操作をenableにする
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))//tapをジェスチャー認識させる
        self.imageView.addGestureRecognizer(tap)//imageViewに追加
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func slideShow(timer: Timer!){
        //スライドショーのタイマー
        if num < photos.count-1{ //もし写真枚数が~だったら
            num += 1
            self.img = UIImage(named: photos[num])
        }else{ //逆に
            num = 0
            self.img = UIImage(named: photos[num])
        }
        imageView.image = self.img
        
    }

    
    @IBAction func nextButton(_ sender: Any) {
        //next進むボタンのアクション
            
            if num < maxPhoto-1{
                self.num += 1
                self.img = UIImage(named: photos[num]) //  = nil じゃなくなる
            }else{
                self.num = 0
                self.img = UIImage(named: photos[num])
            }
            imageView.image = self.img
        }
        
        //back戻るボタン
        @IBAction func prevButton(_ sender: Any) {
            if num != 0{
                num -= 1
                self.img = UIImage(named: photos[num])
            }else{
                num = maxPhoto - 1
                self.img = UIImage(named: photos[num])
            }
            imageView.image = self.img
        }
        
    
    // showボタンを押すと自動送りが再生
    @IBAction func showButton(_ sender: Any) {
        
        let button = sender as! UIButton
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(slideShow), userInfo: nil, repeats: true)
            //インターバルは2秒、slideshow自動送り、userInfoは不要なのでnil、リピートします
            self.nextButton.isEnabled = false //自動送り中は、nextボタンは無効
            self.prevButton.isEnabled = false //自動送り中は、prev(back)ボタンは無効
            button.setTitle("stop", for: .normal)//自動送り中のボタン表示はストップ
        } else{
            //逆に...
            self.timer.invalidate()
            self.timer = nil
            self.nextButton.isEnabled = true//自動送りでなければnextボタンは有効
            self.prevButton.isEnabled = true//自動送りでなければprevボタンは有効
            self.showButton.setTitle("play", for: .normal)//自動送りでなければボタン表示はプレイ
        }
    }
    
    /// 画面をタップした時の処理
    func viewTap(sender: UITapGestureRecognizer){
        //自動送り再生中は、tapをジェスチャー認識させて止める
        if self.timer != nil{
            self.timer.invalidate() //タイマーを破棄
            self.timer = nil
            self.nextButton.isEnabled = true//nextButtonはenable
            self.prevButton.isEnabled = true//prevButoonはenable
            self.showButton.setTitle("play", for: .normal)//showButtonの表示はplay
        }
        
        //値の受け渡し処理
        performSegue(withIdentifier: "segue",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            let nv: nextViewController = (segue.destination as? nextViewController)!
            //セグエを使ってnv:nextViewControllerへ
            nv.nextImg = self.img
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {// 他からsegueで戻ってきた時に呼ばれる
    }
    
   
    
}

