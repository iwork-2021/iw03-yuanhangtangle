//
//  xwdtTableViewController.swift
//  ITSC
//
//  Created by yuanhang on 2021/11/9.
//

import UIKit
import SwiftSoup

class tzggTableViewController: UITableViewController{
    // 先造一些空白的空格
    var items = [NewsItem](repeating: NewsItem(), count: N)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let op = self.readNewsList()
        op.start()
        
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tzggCell", for: indexPath) as! MyTableViewCell
        let item = self.items[indexPath.row]
        cell.title.text! = item.title
        cell.date.text! = item.date
        return cell
    }
    
    func readNewsList() -> BlockOperation{
        //let operationQueue = OperationQueue()
        let operation = BlockOperation()
        for idx in 0..<NumListToFetch{
            operation.addExecutionBlock{
                // 第idx个页面, start from 0
                let url = URL(string: String(format: tzggUrl, idx + 1))
                let request = URLRequest(url: url!)
                let dataTask = URLSession.shared.dataTask(with: request,
                         completionHandler: { data, response, error  in
                             if let error = error{
                                 print("\(error.localizedDescription)")
                                 return
                             } else {
                                 let data = data
                                 let html =  String (data: data!, encoding: .utf8)
                                 self.extractInfo(idx: idx, html: html!)
                             }
                     })  as  URLSessionTask
                dataTask.resume()
            }
            //operationQueue.addOperation(operation)
        }
        return operation
    }

    func extractInfo(idx:Int, html:String){
        let operationQueue = OperationQueue()
        var operations:[BlockOperation] = []
        print("done \(idx)")
        do {
           let doc: Document = try SwiftSoup.parse(html)
            let t = try doc.select("[id = wp_news_w6]")
            let links:Elements = try t.select("li.news")
            let links_array = links.array()
            for i in 0..<NumOfNewsSingleList{
                let operation = BlockOperation{
                    do{
                        let link = links_array[i]
                        let a = try link.select("a").first()!
                        let j = idx * NumOfNewsSingleList + i
                        
                        let title = try a.attr("title")
                        let url = try BaseUrl + a.attr("href")
                        let date = try link.select("[class=news_meta]").text()
                        
                        DispatchQueue.main.async{
                            self.items[j] = NewsItem(title: title, date: date, url: url)
                            self.readNewsContent(idx: j)
                        }
                    }catch{print(error.localizedDescription)}
                }
                operations.append(operation)
            }
            for i in 0..<NumOfNewsSingleList{
                operationQueue.addOperation(operations[i])
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func readNewsContent(idx:Int){
        let url = URL(string: self.items[idx].url)
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request,
                 completionHandler: { data, response, error  in
                     if let error = error{
                         print("\(error.localizedDescription)")
                         return
                     } else {
                         let data = data
                         let html =  String (data: data!, encoding: .utf8)
                         do{
                             let doc: Document = try SwiftSoup.parse(html!)
                             let t = try doc.select("div[class=read]").text()
                             DispatchQueue.main.async {
                                 self.items[idx].text = t;
                             }
                         } catch Exception.Error(let type, let message) {
                             print(message)
                         } catch {
                             print("error")
                         }
                     }
             })  as  URLSessionTask
        dataTask.resume()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let newsViewController = segue.destination as! NewsViewController
            let cell = sender as! MyTableViewCell
            let r = tableView.indexPath(for: cell)!.row
            newsViewController.item = items[r]
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    

}
