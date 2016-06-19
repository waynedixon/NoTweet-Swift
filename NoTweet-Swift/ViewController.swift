//
//  ViewController.swift
//  NoTweet-Swift
//
//  Created by Wayne Dixon on 6/17/16.
//  Copyright © 2016 Wayne Dixon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var characterCount: UILabel!
    
    var usernameCharacterCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tweetText.delegate = self
        
        tweetText.text = ""
        tweetText.autocorrectionType = .no
        tweetText.spellCheckingType = .no
        characterCount.text = "0"
        
        
        
        self.registerNotifications()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    internal func registerNotifications()
    {
        let nc = NotificationCenter.default()
        nc.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        nc.addObserver(self, selector: #selector(textViewTweet), name: NSNotification.Name.UITextViewTextDidChange, object:tweetText)
    }
    
    func keyboardDidShow(notif: Notification )
    {
        /*
         UIEdgeInsets insets = self.tweetText.contentInset;
         insets.bottom += [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
         self.tweetText.contentInset = insets;
         
         insets = self.tweetText.scrollIndicatorInsets;
         insets.bottom += [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
         self.tweetText.scrollIndicatorInsets = insets;

         */
        
        let userInfo = notif.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue()
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        tweetText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
       
        
        tweetText.scrollIndicatorInsets = tweetText.contentInset
        
        let selectedRange = tweetText.selectedRange
        tweetText.scrollRangeToVisible(selectedRange)
        
    }
    
    func keyboardDidHide(notif: Notification)
    {
        //let userInfo = notif.userInfo!
        
       // let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue()
       // let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        tweetText.contentInset = UIEdgeInsetsZero
        
        tweetText.scrollIndicatorInsets = tweetText.contentInset
        
        let selectedRange = tweetText.selectedRange
        tweetText.scrollRangeToVisible(selectedRange)
        

    }
    
    func textViewTweet(notif: Notification) -> Void
    {
        /*
         long charCount = [self getCharacterCount:nil];
         NSString *charCountString = [NSString stringWithFormat:@"%ld", charCount];
         characterCount.text = charCountString;
         */
        
        let charCount: Int = self.getCharacterCount()
        characterCount.text = String(charCount)
    }
    
    func getCharacterCount() -> Int
    {
        
        /*
         int charCount = 0;
         int charCountUsernames = 0;
         int charCountWords = 0;
         int charCountLinks = 0;
         
         /* Replace new lines with asterick so they will be counted in the total count */
         NSString *newText = [tweetText.text stringByReplacingOccurrencesOfString:@"\n" withString:@"*"];
         
         /*
         Explode entire text view into an array, using space as the delimiter.
         Loop through array and Search for any strings that contain @
         If they contain an @, add to charCountUSernames, these will not count towards the overall total
         If they do not contain an @ symbol, get length, and add one character to account for the space removed during explosion of array.
         */
         
         NSArray *listOfWords = [newText componentsSeparatedByString:@" "];
         for (NSString *word in listOfWords)
         {
         
             if( ([word rangeOfString:@"@"].location != NSNotFound) && ([[word lowercaseString] rangeOfString:@"http"].location == NSNotFound) )
             {
                charCountUsernames += [word length] + 1;
             }
             else if(([word rangeOfString:@"@"].location == NSNotFound) && ([[word lowercaseString] rangeOfString:@"http"].location != NSNotFound) )
             {
                charCountLinks += 21;
             }
             else
             {
                charCountWords += [word length]; // +1
             //NSLog(@"word with @: %@", word);
             }
         //NSLog(@"word: %@", word);
         }
         
         /**/
         charCount = charCountWords + charCountLinks;
         /*
         NSLog(@"original Count: %d", originalCount);
         NSLog(@"charCountUsernames: %d", charCountUsernames);
         NSLog(@"charCountWords: %d", charCountWords);
         */
         
         if(charCount < 0)
         {
         charCount = 0;
         }

         */
        var charCount: Int = 0
        var charCountUsernames: Int = 0
        var charCountWords: Int = 0
        var charCountLinks: Int = 0
        
        
        
        let newText: String = tweetText.text.replacingOccurrences(of: "\n", with: " ")
        let listOfWords: Array = newText.components(separatedBy: " ")
        
        //charCountLinks = self.countURLs(array: listOfWords)
        for word in listOfWords
        {
            if( (word.lowercased().range(of: "@") != nil) && (word.lowercased().range(of: "http") == nil) )
            {
                charCountUsernames += word.characters.count + 1
            }
            else if( (word.lowercased().range(of: "@") == nil) && (word.lowercased().range(of: "http") != nil) )
            {
                charCountLinks += 21
            }
            else
            {
                charCountWords += word.characters.count
            }
        }
        
        charCount = charCountWords + charCountLinks + listOfWords.count - 1
        
        print("listOfWords Count: ", listOfWords.count)
        print("Username Count: ", charCountUsernames)
        print("charCountWords: ", charCountWords)
        print("CharCount: ", charCount)
        
        if(charCount < 0)
        {
            charCount = 0
        }
        return charCount
    }
    
    func countURLs(array listOfWords: Array<String>!) -> Int
    {
        var urlCount: Int = 0
        
        for word in listOfWords
        {
            if (word.lowercased().range(of: "http") != nil)
            {
                urlCount += 1
            }
        }
        
        return urlCount
    }
    
    func countUsernames(array listOfWords: Array<String>!) -> Int
    {
        var usernameCount: Int = 0
        
        for word in listOfWords
        {
            if (word.lowercased().range(of: "@") != nil)
            {
                usernameCount += 1
            }
        }
        
        return usernameCount
    }
}

