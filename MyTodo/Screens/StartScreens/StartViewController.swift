//
//  StartViewController.swift
//  MyTodo
//
//  Created by Minh Tan Vu on 22/06/2023.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var warningLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTF.layer.cornerRadius = nameTF.bounds.height/2
        nameTF.clipsToBounds = true
        nameTF.borderStyle = .line
        nameTF.layer.borderWidth = 3
        nameTF.layer.borderColor = UIColor.darkGray.cgColor
        nameTF.textColor = .darkGray
        
        startBtn.clipsToBounds = true
        startBtn.layer.cornerRadius = startBtn.bounds.height/2
        warningLb.isHidden = true
        navigationController?.isNavigationBarHidden = true
//        navigationController?.title = "\(nameTF.text!)'s Todo"
        
    }
    
    @IBAction func nameTFDidEndEditing(_ sender: UITextField) {
        warningLb.isHidden = true
    }
    
    @IBAction func startBtnTapped(_ sender: UIButton) {
        if nameTF.text == "" {
            warningLb.isHidden = false
            warningLb.text = "*Please input your name"
            
        } else {
            warningLb.isHidden = true
            UserDefaultsService.shared.completedInputName = true
            routeToMain()
        }
        
    }
    
    func routeToMain() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myTodoVC = mainStoryboard.instantiateViewController(withIdentifier: "MyTodoViewController")
        navigationController?.pushViewController(myTodoVC, animated: true)
//        let nav = UINavigationController(rootViewController: myTodoVC)
//        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {return}
//        window.rootViewController = nav
//        window.makeKeyAndVisible()
    }
}
