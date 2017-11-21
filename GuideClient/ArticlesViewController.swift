//
//  ArticlesViewController.swift
//  GuideClient
//
//  Created by thales.garcia on 19/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import UIKit
import WebKit
import Suas

let store = Suas.createStore(reducer: ArticleReducer(), middleware: AsyncMiddleware())

//MARK: - ArticlesViewController
class ArticlesViewController: UIViewController {

    @IBOutlet weak var articlesTabelView: UITableView!
    @IBOutlet weak var articleWebView: WKWebView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    @IBOutlet weak var topLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var leftLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var rightLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutContraint: NSLayoutConstraint!
    
    var isLoading: Bool = false
    var isContentOpened: Bool = false
    
    var articles: Articles = ArticleReducer().initialState as Articles {
        didSet {
            DispatchQueue.main.async {
                self.articlesTabelView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subscription = store.addListener(forStateType: Articles.self)  { [weak self] state in
            self?.articles = state 
        }
        
        subscription.linkLifeCycleTo(object: self)
        
        store.dispatch(action:RefreshArticles(withCurrentState: articles))
        
        articlesTabelView.rowHeight = UITableViewAutomaticDimension
        articlesTabelView.estimatedRowHeight = 44
        self.dismissWebView()
        
    }
    
    @IBAction func DoneDidTouch(_ sender: Any) {
        self.articleWebView.loadEmpty()
        self.dismissWebView()
    }
    
    func presentWebViewScreen() {
        UIView.animate(withDuration: 0.5) {
            self.navigationBar.topItem?.title = ""
            self.view.bringSubview(toFront: self.articleWebView)
            self.articleWebView.isHidden = false
            self.articleWebView.alpha = 1.0
            self.doneButton.isEnabled = true
            self.doneButton.tintColor = UIColor.white
            
            self.topLayoutContraint.constant = 0
            self.rightLayoutContraint.constant = 0
            self.leftLayoutContraint.constant = 0
            self.bottomLayoutContraint.constant = 0
        }
    }
    
    func dismissWebView() {
        UIView.animate(withDuration: 0.5) {
            self.navigationBar.topItem?.title = "Articles"
            self.articleWebView.isHidden = true
            self.articleWebView.alpha = 0
            self.doneButton.isEnabled = false
            self.doneButton.tintColor = UIColor.GuideClient.turquoise
            
            self.topLayoutContraint.constant = -self.view.frame.height/2
            self.rightLayoutContraint.constant = -self.view.frame.width/2
            self.leftLayoutContraint.constant = self.view.frame.width/2
            self.bottomLayoutContraint.constant = self.view.frame.height/2
        }
    }
}

//MARK: - ArticlesViewController - UITableViewDataSource
extension ArticlesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("COUNTER: \(articles.items.count)")
        return articles.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as? ArticleTableViewCell {
            let article = self.articles.items[indexPath.row]
            print("TITLE: \(article.title)")
            print("DATE: \(article.updatedAt)")
            cell.setup(withArticle: article)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - ArticlesViewController - UITableViewDelegate
extension ArticlesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articles.items[indexPath.row]
        self.articleWebView.loadHTMLString(article.body, baseURL: nil)
        self.presentWebViewScreen()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.items.count-1 && self.isLoading == false {
            self.isLoading = true
            store.dispatch(action: RefreshArticles(withCurrentState: articles))
        }
    }
}
