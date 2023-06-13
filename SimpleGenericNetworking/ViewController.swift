//
//  ViewController.swift
//  SimpleGenericNetworking
//
//  Created by GuestUser on 13/06/2023.
//

import UIKit

// Models
struct Post: Codable {
    let userId: Int
    let title: String
}

struct User: Codable {
    let id: Int
    let name: String
}

class ViewController: UIViewController {

    let postsUrl =  URL(string: "https://jsonplaceholder.typicode.com/posts")
    let usersUrl = URL(string: "https://jsonplaceholder.typicode.com/users")
    let models : [Codable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        URLSession.shared.request ( url: postsUrl, expecting: [Post].self) { result in
            switch result{
            case .success(let posts):
                DispatchQueue.main.async {
                    print(posts)
                }
            case .failure(let error):
                print(error)
            }
        }
        URLSession.shared.request ( url: usersUrl, expecting: [User].self) { result in
            switch result{
            case .success(let users):
                DispatchQueue.main.async {
                    print(users)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension URLSession{
    
    enum CustomError: Error {
        case invalidURL
        case invalidData
    }
    
    func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure (error))
                } else {
                    completion(.failure (CustomError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder() . decode (expecting, from: data)
                completion(.success (result))
            }
            catch {
                completion(.failure (error))
            }
        }
        task.resume()
    }
}
