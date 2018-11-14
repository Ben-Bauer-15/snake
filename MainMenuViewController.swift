//
//  MainMenuViewController.swift
//  SwiftSnake
//
//  Created by Ben Bauer on 11/13/18.
//  Copyright © 2018 Weizhong Yang. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    @IBAction func playButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Play Segue", sender: sender)
    }
    
    @IBAction func scoresButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Scores Segue", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
