//
//  AuthViewController.swift
//  LessonOne
//
//  Created by user on 23.10.2021.
//

import UIKit
import WebKit
import Firebase

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let authService = Auth.auth()
    private var token: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationToVkAPI()
        if !Session.shared.token.isEmpty, Session.shared.userId > 0 {
            performSegue(withIdentifier: "showTabBarSegue", sender: nil)
            print ("Переход")
        }
    }
    //https://oauth.vk.com/authorize
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    func authorizationToVkAPI()  {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7979751"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            
            URLQueryItem(name: "scope", value: "270343"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
    private func showAlert(titile: String, text: String) {
        let alert = UIAlertController(title: titile, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard  let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String:String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        guard let token = params["access_token"], let userId = params["user_id"] else {return}
        print (token as Any)
        Session.shared.token = token
        Session.shared.userId = Int(userId) ?? 0
        performSegue(withIdentifier: "showTabBarSegue", sender: nil)
        decisionHandler(.cancel)
    }
}
