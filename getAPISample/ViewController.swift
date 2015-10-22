//
//  ViewController.swift
//  getAPISample
//
//  Created by 前田 晃良 on 2015/10/22.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate{

    var musicIndex:Int = 0 //曲のインデックスは0~49まで！
    var musicCount:Int = 0 //取得した曲数
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberTextField.delegate = self

        self.numberTextField.text = "0"
        musicIndex = self.numberTextField.text.toInt()!
        
        
        self.setMusicInfo()
    }
    
    func setMusicInfo(){
        //API(url)の文字列を生成する
        var urlString = "https://itunes.apple.com/search?term=beatles&country=JP&lang=ja_jp&media=music"
        
        //曲のインデックス番号
        
        
        //URLの文字列をURL型に変換
        var url = NSURL(string: urlString)
        
        //URLをData型に変換
        var data = NSData(contentsOfURL: url!)
        
        //jsonに変換
        let jsonDict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
        println(jsonDict)
        
        //iTunes APIから取得した曲集
        musicCount = jsonDict["resultCount"]!
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
        var countString = "\(musicIndex+1)/\(musicCount) 曲目"
        self.countLabel.text = countString

    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        var userNumber = numberTextField.text.toInt()
        
        if(0 <= userNumber && userNumber <= musicCount){
            println("編集終了")
            
            musicIndex = numberTextField.text.toInt()!
            setMusicInfo()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //キーボードのリターンが押された際にキーボードを閉じる
        numberTextField.resignFirstResponder();
        return true;
    }
    
    


}

