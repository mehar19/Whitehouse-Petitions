//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Mehar on 26/09/2021.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var orignalPetitions = [Petition]()
    var filteredPetition = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterTapped))
       
        
        let urlString : String
        if navigationController?.tabBarItem.tag == 0{
           urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json" //"https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
            parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func filterTapped(){
        let ac = UIAlertController(title: "What are you looking for? ", message: nil, preferredStyle: .alert)
        ac.addTextField()

            let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0]
                // do something interesting with "answer" here
             //   print( answer.text)
                self.filterPetitions(searchWord: answer.text!)
    }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func filterPetitions(searchWord: String){
        filteredPetition.removeAll()
        for  petition in orignalPetitions{
            if petition.title.contains(searchWord) {
                filteredPetition.append(petition)
                
            }
        }
        petitions = filteredPetition
        tableView.reloadData()
    }
    @objc  func addTapped(){
        
        let ac = UIAlertController(title: "Source", message: " We The People API of the Whitehouse", preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            orignalPetitions = jsonPetitions.results
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

