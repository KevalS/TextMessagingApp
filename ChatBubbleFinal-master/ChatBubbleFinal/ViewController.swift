//
//  ViewController.swift
//  ChatBubbleFinal
//


import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var messageComposingView: UIView!
    @IBOutlet weak var messageCointainerScroll: UIScrollView!
    @IBOutlet weak var buttomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var list : [ AnyObject ]?
    var m0 : String! = nil
    var m1 : String! = nil
    var m2 : String! = nil
    var m3 : String! = nil
    var m4 : String! = nil
    var m5 : String! = nil
    
    var selectedImage : UIImage?
    var lastChatBubbleY: CGFloat = 10.0
    var internalPadding: CGFloat = 8.0
    var lastMessageType: BubbleDataType?
    var first = 0
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
              self.parser()
   
        imagePicker.delegate = self
        imagePicker.allowsEditing = false //2
        imagePicker.sourceType = .PhotoLibrary //3
        sendButton.enabled = false

        
        self.messageCointainerScroll.contentSize = CGSizeMake(CGRectGetWidth(messageCointainerScroll.frame), lastChatBubbleY + internalPadding)
        self.addKeyboardNotifications()
        
        /*
        
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // MARK:- Notification
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

        UIView.animateWithDuration(1.0, animations: { () -> Void in
            //self.buttomLayoutConstraint = keyboardFrame.size.height
            self.buttomLayoutConstraint.constant = keyboardFrame.size.height

            }) { (completed: Bool) -> Void in
                    self.moveToLastMessage()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.buttomLayoutConstraint.constant = 0.0
            }) { (completed: Bool) -> Void in
                self.moveToLastMessage()
        }
    }
    
    @IBAction func sendButtonClicked(sender: AnyObject) {
        self.addRandomTypeChatBubble()
        textField.resignFirstResponder()
        self.showmsg()
        
    }
    
    func parser()  {
    
        let parse = Parser()
        parse.appSetting { (repos) in
            
            print(repos)
            print("Suyesh")
             if let result = repos[ "payload"  ] as? [ AnyObject ]
             {
                if result.count > 0
                {
                 if let dic : [ String : AnyObject ] = result[ 0 ]  as? [ String : AnyObject ]
                 {
                    if let categories : [ AnyObject ] = dic[ "messages" ] as? [ AnyObject ]

                    {
                        self.m0 = categories[0]["message"]as? String
                        self.m1 = categories[1]["message"]as? String
                        self.m2 = categories[2]["message"]as? String
                        self.m3 = categories[3]["message"]as? String
                        self.m4 = categories[4]["message"]as? String
                        self.m5 = categories[5]["message"]as? String
                        
                    }
                    
                    }
                    
                }
            }
        }
        
        
    }
    
    func showmsg()  {
        if first == 0
        {
            let chatBubbleData2 = ChatBubbleData(text: self.m0, image:nil, date: NSDate(), type: .Opponent)
            addChatBubble(chatBubbleData2)
            first = 1
            return
            
        }
        if first == 1
        {
            let chatBubbleData2 = ChatBubbleData(text: self.m1, image:nil, date: NSDate(), type: .Opponent)
            addChatBubble(chatBubbleData2)
            first = 2
            return
        }
        else if first == 2
        {
            let chatBubbleData2 = ChatBubbleData(text: self.m2, image:nil, date: NSDate(), type: .Opponent)
            addChatBubble(chatBubbleData2)
            first = 3
            return
        }
        else if first == 3{
            let chatBubbleData2 = ChatBubbleData(text: self.m3, image:nil, date: NSDate(), type: .Opponent)
            addChatBubble(chatBubbleData2)
            first = 4
            return
        }
        else if first == 4
        {
            let chatBubbleData2 = ChatBubbleData(text: self.m4, image:nil, date: NSDate(), type: .Opponent)
            addChatBubble(chatBubbleData2)
            first = 5
            return
        }
        else if first == 5
        {
            let chatBubbleData2 = ChatBubbleData(text: self.m5, image:nil, date: NSDate(), type: .Opponent)
            addChatBubble(chatBubbleData2)
            first = 0
            return
        }

    }
    
    @IBAction func cameraButtonClicked(sender: AnyObject) {
        self.presentViewController(imagePicker, animated: true, completion: nil)//4
    }
    
//    func messageid(completionClosure: (repos :NSDictionary) ->())  {
//        let urlPath: String = "http://hitme-dev.us-west-2.elasticbeanstalk.com/api/all-messages/"
//        let url: NSURL = NSURL(string: urlPath)!
//        let request1: NSURLRequest = NSURLRequest(URL: url)
//        let queue:NSOperationQueue = NSOperationQueue()
//     
//        
//        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//            
//            do {
//                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
//                    print("ASynchronous\(jsonResult)")
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//            
//            
//        })
//    }
    
    func addRandomTypeChatBubble() {
        let bubbleData = ChatBubbleData(text: textField.text, image: selectedImage, date: NSDate(), type: .Mine)
        addChatBubble(bubbleData)
    }
    func addChatBubble(data: ChatBubbleData) {
        
        let padding:CGFloat = lastMessageType == data.type ? internalPadding/3.0 :  internalPadding
        let chatBubble = ChatBubble(data: data, startY:lastChatBubbleY + padding)
        self.messageCointainerScroll.addSubview(chatBubble)
        
        lastChatBubbleY = CGRectGetMaxY(chatBubble.frame)
        
        
        self.messageCointainerScroll.contentSize = CGSizeMake(CGRectGetWidth(messageCointainerScroll.frame), lastChatBubbleY + internalPadding)
        self.moveToLastMessage()
        lastMessageType = data.type
        textField.text = ""
        sendButton.enabled = false
    }
    
    func moveToLastMessage() {

        if messageCointainerScroll.contentSize.height > CGRectGetHeight(messageCointainerScroll.frame) {
            let contentOffSet = CGPointMake(0.0, messageCointainerScroll.contentSize.height - CGRectGetHeight(messageCointainerScroll.frame))
            self.messageCointainerScroll.setContentOffset(contentOffSet, animated: true)
        }
    }
    func getRandomChatDataType() -> BubbleDataType {
        return BubbleDataType(rawValue: Int(arc4random() % 2))!
    }
}


// MARK: TEXT FILED DELEGATE METHODS

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Send button clicked
        textField.resignFirstResponder()
        self.addRandomTypeChatBubble()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var text: String
        
        if string.characters.count > 0 {
            text = String(format:"%@%@",textField.text!, string);
        } else {
            var string = textField.text! as NSString
            text = string.substringToIndex(string.length - 1) as String
        }
        if text.characters.count > 0 {
            sendButton.enabled = true
        } else {
            sendButton.enabled = false
        }
        return true
    }
}

extension ViewController: UIImagePickerControllerDelegate{
    //MARK: Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        let bubbleData = ChatBubbleData(text: textField.text, image: chosenImage, date: NSDate(), type: getRandomChatDataType())
        addChatBubble(bubbleData)
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}

