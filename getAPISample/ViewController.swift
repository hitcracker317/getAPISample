//
//  ViewController.swift
//  getAPISample
//
//  Created by 前田 晃良 on 2015/10/22.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate,UIPickerViewDelegate/*,UIPickerViewDataSource*/{

    var musicIndex:Int = 0 //曲のインデックス番号！
    var musicCount:Int = 0 //取得した曲数
    var keyBoardRect:CGRect = CGRectMake(0, 0, 0, 0) //キーボードのRect
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var numberPicker = UIPickerView()
    var myToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberTextField.delegate = self
        
        numberPicker.delegate = self
        //numberPicker.dataSource = self

        self.numberTextField.text = "1"
        self.numberTextField.inputView = numberPicker
        //musicIndex = self.numberTextField.text.toInt()!
        
        //ToolBar作成。ニョキ担当
        myToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        myToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        myToolBar.backgroundColor = UIColor.blackColor()
        myToolBar.barStyle = UIBarStyle.Black
        myToolBar.tintColor = UIColor.whiteColor()
        
        //ToolBarを閉じるボタンを追加
        let myToolBarButton = UIBarButtonItem(title: "Close", style: .Bordered, target: self, action: "onClick:")
        myToolBarButton.tag = 1
        myToolBar.items = [myToolBarButton]
        
        numberTextField.inputAccessoryView = myToolBar
        
        self.setMusicInfo()
    }
    
    func setMusicInfo(){
        //iTunesのAPIを叩くメソッド
        
        //API(url)の文字列を生成する
        var urlString = "https://itunes.apple.com/search?term=beatles&country=JP&lang=ja_jp&media=music"
        
        //URLの文字列をURL型に変換
        var url = NSURL(string: urlString)
        
        //URLをData型に変換
        var data = NSData(contentsOfURL: url!)
        
        //jsonに変換
        let jsonDict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
        println(jsonDict)
        
        //iTunes APIから取得した曲集
        var musicCountString:NSNumber = jsonDict["resultCount"] as! NSNumber
        musicCount = Int(musicCountString) //NSNumberをIntに変換
        
        println("ヒットした曲数\(musicCount)")
        
        //ヒットした曲の名前を取得
        var musicArray = jsonDict["results"] as! NSArray
        
        var trackName = musicArray[musicIndex]["trackName"] as! String
        println("曲名:\(trackName)")
        
        //アートワークを取得(取得した値は画像のurlの文字列)
        //URLからImageを作成しImageViewに表示する
        //urlを文字列で生成
        var artworkURL = musicArray[musicIndex]["artworkUrl100"] as! String
        println(artworkURL)
        
        //url型に変換
        var imageURL = NSURL(string: artworkURL)
        
        //data型に変換
        var imageData = NSData(contentsOfURL: imageURL!)
        
        //image型に変換
        var image = UIImage(data: imageData!)
        
        //ImageViewに表示
        self.imageView.image = image
        
        //Labelにタイトルを表示
        self.trackNameLabel.text = trackName
        
        //ラベルにx/x曲目の文字列を表示
        var countString = "\(musicIndex + 1)/\(musicCount) 曲目"
        self.countLabel.text = countString
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //ピッカー内の要素の数
        return musicCount
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //ピッカーに表示する要素
        return "\(row + 1)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //ピッカーを選択した際の処理
        self.numberTextField.text = "\(row + 1)"
    }
    
    //閉じる
    func onClick(sender: UIBarButtonItem) {
        self.numberTextField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        var userNumber = numberTextField.text.toInt()
        
        if(0 <= userNumber && userNumber <= musicCount){
            println("編集終了")
            
            musicIndex = numberTextField.text.toInt()!
            musicIndex--
            setMusicInfo()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //キーボードのリターンが押された際にキーボードを閉じる
        numberTextField.resignFirstResponder();
        return true;
    }
    
    


}

