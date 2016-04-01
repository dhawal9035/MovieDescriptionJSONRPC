//
//  ViewController.swift
//  MovieDescriptionNavigation
//  Copyright 2016 Dhawal Soni
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Created by dssoni on 2/22/16.
//  Copyright © 2016 dssoni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var releasedLbl: UILabel!
    @IBOutlet weak var runLbl: UILabel!
    @IBOutlet weak var ratedLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var actorTV: UITextView!
    @IBOutlet weak var plotTV: UITextView!
    
    var urlString:String = ""
    var selectedMovie : String = ""
    var movies:[String : MovieDescription] = [String:MovieDescription]()
    //let urlString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = selectedMovie
        if let infoPlist = NSBundle.mainBundle().infoDictionary {
            self.urlString = ((infoPlist["ServerURLString"]) as?  String!)!
            NSLog("The default urlString from info.plist is \(self.urlString)")
        }else{
            NSLog("error getting urlString from info.plist")
        }
        let movieConnect:MovieCollectionStub = MovieCollectionStub(urlString: self.urlString)
        let resGet:Bool = movieConnect.get(selectedMovie, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                    do{
                        let dict = try NSJSONSerialization.JSONObjectWithData(data,options:.MutableContainers) as?[String:AnyObject]
                        let aDict:[String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        let aStud:MovieDescription = MovieDescription(dict: aDict)

                        self.yearLbl.text = aStud.year
                        self.releasedLbl.text = aStud.released
                        self.ratedLbl.text = aStud.rated
                        self.runLbl.text = aStud.runTime
                        self.actorTV.text = aStud.actors
                        self.plotTV.text = aStud.plot
                        self.genreLbl.text = aStud.genre
                    } catch {
                        NSLog("unable to convert to dictionary")
                    }
                }
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

