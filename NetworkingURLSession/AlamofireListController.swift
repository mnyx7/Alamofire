//
//  AlamofireListController.swift
//  NetworkingURLSession
//
//  Created by Minaya Yagubova on 27.03.23.
//

import UIKit
import Alamofire

class AlamofireListController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var items = [Post]()
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        getPostItems()
        getPostItemsWithResponseDecodable()
    }
    
    func getPostItems() {
        AF.request(url).response { object in            
            if object.response?.statusCode == 200 {
                if let data = object.data {
                    do {
                        self.items = try JSONDecoder().decode([Post].self, from: data)
                        self.table.reloadData()
                    } catch {
                        print(error.localizedDescription)
                        self.showErrorMessage(message: error.localizedDescription)
                    }
                }
            } else {
                
            }
        }
    }
    
    func getPostItemsWithResponseDecodable() {
        AF.request(url).responseDecodable(of: [Post].self) { object in
            switch object.result {
            case .success(let items):
                self.items = items
                self.table.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                self.showErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OKAY", style: .default)
        alertController.addAction(cancel)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
    func createNewPostItem() {
//        ["userId": 1, "data": "asdasd"]
        let newPost = Post(userId: 111, id: 111, title: "Hello World", body: "this is my post")
        /*
         {
            "userId": 111,
            "id": 111,
            "ttole"
         }
         */
        let newItem: [String: Any] = ["userId": 111, "id": 111, "title": "Hello World", "body": "this is my post"]
        //Query Params
        //Body Param
        
        //request body - gonderilen data (encode)
        //response body - gelen data (decode)
        
        AF.request(url,
                   method: .post,
                   parameters: newPost,
//                   encoding: JSONEncoding.default,
                   encoder: JSONParameterEncoder.default).responseDecodable(of: Post.self) { object in
            switch object.result {
            case .success(let item):
                self.items.insert(item, at: 0)
                self.table.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                self.showErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func addPostAction(_ sender: Any) {
        createNewPostItem()
    }        
}

extension AlamofireListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(PostDetailController.self)") as! PostDetailController
        controller.postId = items[indexPath.row].id
        navigationController?.show(controller, sender: nil)
    }
}
