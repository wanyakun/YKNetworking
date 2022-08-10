//
//  ViewController.swift
//  YKNetworking
//
//  Created by wanyakun on 09/07/2021.
//  Copyright (c) 2021 wanyakun. All rights reserved.
//

import UIKit
import YKNetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func getButtonTouchUpInside(_ sender: UIButton) {
        let request = GetRequest()
        request.success { request in
            print(request.responseJSON)
        }.start()
    }
    
    @IBAction func postButtonDidTouchUpInside(_ sender: UIButton) {
        let request = PostRequest()
        request.success { request in
            print(request.responseJSON)
        }.failed({ request in
            print(request.error)
            print(request.responseJSON)
        }).start()
    }
}
