//
//  WebViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/11/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var term = ""
    
    //MARK: mark:Javascript string
    
    var javascript = ""
    
    
    
    var request:URLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let request = request {
            webView.loadRequest(request)
            javascript = "document.body.innerHTML.replace(/the/g,\"<span id='myhighlight'>fox</span>\");"
            print(javascript)
            webView.stringByEvaluatingJavaScript(from: javascript)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        javascript = "<script type=\"text/javascript\" src=\"https://code.jquery.com/jquery-2.1.1.min.js\"> </script> $(document).ready(function() { document.body.innerHTML.replace(/the/g,\"<span id='myhighlight'>fox</span>\"); document.getElementById('myhighlight').style.backgroundColor='yellow';});"
        print(javascript)
        webView.stringByEvaluatingJavaScript(from: javascript)
   
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        javascript = "<script type=\"text/javascript\" src=\"https://code.jquery.com/jquery-2.1.1.min.js\"> </script> $(document).ready(function() { document.body.innerHTML.replace(/the/g,\"<span id='myhighlight'>fox</span>\"); document.getElementById('myhighlight').style.backgroundColor='yellow';});"
        print(javascript)
        webView.stringByEvaluatingJavaScript(from: javascript)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
