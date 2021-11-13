//
//  gyITSCViewController.swift
//  ITSC
//
//  Created by yuanhang on 2021/11/13.
//

import UIKit
import SwiftSoup

class gyITSCViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getInfo()
        // Do any additional setup after loading the view.
    }
    
    func getInfo(){
        let url = URL(string: gyITSCUrl)
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request,
                 completionHandler: { data, response, error  in
                     if let error = error{
                         print("\(error.localizedDescription)")
                         return
                     } else {
                         let data = data
                         let html =  String (data: data!, encoding: .utf8)
                         self.readContent(html: html!)
                     }
             })  as  URLSessionTask
        dataTask.resume()
    }
    
    func readContent(html:String){
        do{
            let doc: Document = try SwiftSoup.parse(html)
            let elem = try doc.select("div[id=wp_news_w91]")
            let elems = try elem.select("li[class~=news]")
            var t = ""
            /*
             
             */
            t = try elem.text()
            DispatchQueue.main.async {
                self.text.text = t.replacingOccurrences(of: " ", with: "\n")
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
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
