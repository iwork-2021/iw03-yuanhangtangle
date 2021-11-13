//
//  NewsViewController.swift
//  ITSC
//
//  Created by yuanhang on 2021/11/13.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var titleInput: UILabel!
    @IBOutlet weak var textInput: UITextView!
    var item:NewsItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil{
            self.titleInput!.text = item!.title
            self.textInput!.text = item!.text
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
