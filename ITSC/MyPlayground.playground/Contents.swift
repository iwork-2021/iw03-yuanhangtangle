import UIKit
import SwiftSoup

var greeting = "Hello, playground"
let html: String = "<p>An <a href='http://example.com/'><b>example</b></a> link.<a>test message</a></p>";
let doc: Document = try SwiftSoup.parse(html)
let links: Elements = try doc.select("a")
var i = 0
for link in links{
    print("\(i) \(try! link.text())")
    i = i + 1
}
    

