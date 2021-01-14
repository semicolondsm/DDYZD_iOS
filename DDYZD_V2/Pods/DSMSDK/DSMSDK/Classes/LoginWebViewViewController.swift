//
//  LoginWebViewViewController.swift
//  DSMSDK
//
//  Created by 김수완 on 2020/12/23.
//

import UIKit
import WebKit

class LoginWebViewViewController: UIViewController {
    
    private var _client_id: String = ""
    private var _client_secret: String = ""
    private var _redirctURL: String = ""
    
    private var wkWebView: WKWebView!
    
    private var complitionHandler: ((String)->Void)?
     
    override func viewDidLoad() {
        super.viewDidLoad()

        wkWebView = WKWebView(frame: self.view.frame)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        
        settingWKView()
    }
    
    public func initialize(client_id: String, redirctURL: String){
        _client_id = client_id
        _redirctURL = redirctURL
    }

}

extension LoginWebViewViewController : WKUIDelegate, WKNavigationDelegate {
    func settingWKView(){
        let URL = "http://193.123.237.232/external/login?redirect_url="+_redirctURL+"&client_id="+_client_id
        
        let request: URLRequest = URLRequest.init(url: NSURL.init(string: URL)! as URL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        wkWebView.load(request)
        
        wkWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.view?.addSubview(self.wkWebView!)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        wkWebView.reload()
    }
    
    func getCode(handler: @escaping (String)->Void){
        complitionHandler = handler
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            let url = String(describing: wkWebView.url!)
            let code = url.split(separator: "=")[1]
            if complitionHandler != nil {
                complitionHandler!(String(code))
                complitionHandler = nil
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }

}
