//
//  ViewController.swift
//  getAPISample
//
//  Created by 前田 晃良 on 2015/10/22.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate,UIPickerViewDelegate/*,UIPickerViewDataSource*/{

    var musicIndex:Int = 0 //曲のインデックス番号
    var musicCount:Int = 0 //取得した曲数
    
    var jsonDict = [:] //APIから取得したデータを保持し続けるDictionary型の変数
    
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

        self.numberTextField.text = "1"
        self.numberTextField.inputView = numberPicker
        
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
        
        self.getAPI()
    }
        
    func getAPI(){
        //iTunesのAPIを叩いてJSONを取得するメソッド
        
        var urlString = "https://itunes.apple.com/search?term=fear-and-loathing-in-las-vegas&country=JP&lang=ja_jp&media=music" //API(url)の文字列を生成する
        var url = NSURL(string: urlString) //URLの文字列をURL型に変換
        var data = NSData(contentsOfURL: url!) //URLをData型に変換
        jsonDict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary //jsonに変換
        println(jsonDict)
        
        setMusicInfo()
    }
    
    func setMusicInfo(){
        //曲情報を切り替えた際に取得した曲情報をセットするメソッド
        
        //iTunes APIから取得した曲数
        var musicCountString:NSNumber = jsonDict["resultCount"] as! NSNumber
        musicCount = Int(musicCountString) //NSNumberをIntに変換
        println("取得した曲数\(musicCount)")
        
        //ラベルにx/x曲目の文字列を表示
        var countString = "\(musicIndex + 1)/\(musicCount) 曲目"
        self.countLabel.text = countString
        
        
        var musicArray = jsonDict["results"] as! NSArray //API叩いて取得した曲の情報(NSDictionary)を格納する配列
        
        //Labelに曲名を表示
        var trackName = musicArray[musicIndex]["trackName"] as! String
        self.trackNameLabel.text = trackName //曲名
        println("曲名:\(trackName)")
        
        //アートワークを取得&表示(取得した値は画像のurlの文字列)
        var artWorkURL = musicArray[musicIndex]["artworkUrl100"] as! String //urlを文字列で取得
        var imageURL = NSURL(string: artWorkURL) //stringをurl型に変換
        var imageData = NSData(contentsOfURL: imageURL!) //data型に変換
        var image = UIImage(data: imageData!) //image型に変換
        self.imageView.image = image //ImageViewに表示
        
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
    
    //ピッカービューを閉じる
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
    
    @IBAction func backTrack(sender: AnyObject) {
        //前の曲を表示
        if(0 < musicIndex){
            musicIndex--
            setMusicInfo()
            self.numberTextField.text = "\(musicIndex + 1)"
        }
    }

    @IBAction func nextTrack(sender: AnyObject) {
        //次の曲を表示
        if(musicIndex < musicCount - 1){
            musicIndex++
            setMusicInfo()
            self.numberTextField.text = "\(musicIndex + 1)"
        }
    }
}

