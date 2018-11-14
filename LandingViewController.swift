//
//  LandingViewController.swift
//  SwiftSnake
//
//  Created by Ben Bauer on 11/13/18.
//  Copyright © 2018 Weizhong Yang. All rights reserved.
//

import UIKit
import CoreData

class LandingViewController: UIViewController {
    
    var users = [User]()

    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var userNameText: UITextField!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if userNameText.text == ""{
            return
        }
        else {
            let user = NSEntityDescription.insertNewObject(forEntityName : "User", into : context) as! User
            user.name = userNameText.text
            saveContext()
            delegate.name = userNameText.text
            
            performSegue(withIdentifier: "Login Segue", sender: sender)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "User")
        
        do {
            let result = try context.fetch(request)
            users = result as! [User]
            if users.count > 0 {
                delegate.name = users[0].name
                performSegue(withIdentifier: "Login Segue", sender: self)
            }
            else {
                return
            }
        }
        catch {
            print("\(error)")
        }
    }
    


}
