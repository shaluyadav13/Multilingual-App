//
//  MutilingualViewController.swift
//  Yadav_MultilingualApp
//  @Author: s525138
//  Created by Yadav,Shalu on 3/27/16.
//  Copyright © 2016 Yadav,Shalu. All rights reserved.
//  Device: iPhone 6s Plus

import UIKit

class MutilingualViewController: UIViewController {
    
    let languageCode = ["Japanese":"ja", "French":"fr", "Hindi":"hi"]
    
    var languageSelected:String!
   var translatedText:String = ""

    @IBOutlet weak var translatedTextTV: UITextView!
    @IBOutlet weak var textToTranslateTV: UITextView!
    
    @IBOutlet weak var langSegBTN: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index:Int = langSegBTN.selectedSegmentIndex
        languageSelected = langSegBTN.titleForSegmentAtIndex(index)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTranslatedText:", name: "Text Translated", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    // detrmine the index of the selected segment in segment control button
    
    @IBAction func valueChanged(sender: AnyObject) {
        let index:Int = sender.selectedSegmentIndex
       
        languageSelected = sender.titleForSegmentAtIndex(index)
        
    }
    
    
    @IBAction func translateBTN(sender: AnyObject) {
        
        let key:String = "trnsl.1.1.20160307T213950Z.3c5c87c3e34aaaae.bfe9021dfa7e4b7e1ef4826c52e2e8781c8a1813"
        let textInTV:String = textToTranslateTV.text
        let textToTranslate:String? = textInTV.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        
        let lang:String = languageCode[languageSelected]!
        
        let request:String = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=\(key)&text=\(textToTranslate!)&lang=en-\(lang)"
        
        let url = NSURL(string: request)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!, completionHandler:translatedData).resume()
            }
    
    func translatedData(data:NSData?,response:NSURLResponse?, error:NSError?)->Void{
        let result:[String:AnyObject]!
        do
        {
        try result = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
            let translatedArray:[String] = result["text"] as! [String] // converting AnyObject to [String]
            translatedText = translatedArray[0]
            
            dispatch_async(dispatch_get_main_queue()){
                NSNotificationCenter.defaultCenter().postNotificationName("Text Translated", object: nil) // calls the Notification named as Text Translated
            }
            
        }
        catch
        {
            print("Something went wrong..")
        }
    }
    
    func showTranslatedText(notification:NSNotification){
        translatedTextTV.text = translatedText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

