//
//  PostDetailController.swift
//  NetworkingURLSession
//
//  Created by Minaya Yagubova on 27.03.23.
//

import UIKit

struct Comment: Codable {
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
}

/*
 {
     "postId": 3,
     "id": 11,
     "name": "fugit labore quia mollitia quas deserunt nostrum sunt",
     "email": "Veronica_Goodwin@timmothy.net",
     "body": "ut dolorum nostrum id quia aut est\nfuga est inventore vel eligendi explicabo quis consectetur\naut occaecati repellat id natus quo est\nut blanditiis quia ut vel ut maiores ea"
   }
 */

class PostDetailController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
//    var postId = 0
    var postId: Int?
    var commentItems = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCommentItems()
    }
    
    func getCommentItems() {
//        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId ?? 0)/comments")!
        let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId ?? 0)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    self.commentItems = try JSONDecoder().decode([Comment].self, from: data)
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

extension PostDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = commentItems[indexPath.row].name
        return cell
    }
}
