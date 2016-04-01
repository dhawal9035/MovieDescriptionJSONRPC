//
//  AddMovieController.swift
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

class AddMovieController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var releasedTF: UITextField!
    @IBOutlet weak var runTF: UITextField!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var genreTF: UITextField!
    @IBOutlet weak var actorTF: UITextField!
    @IBOutlet weak var plotTF: UITextField!
    @IBOutlet var genrePicker: UIPickerView!
    
    var movieTable: MovieTableController?
    var movies:[String : MovieDescription] = [String:MovieDescription]()
    var genreArray : [String] = ["Action","Drama","Adventure","Thriller","Comedy","Biography"]
    var urlString:String = "http://localhost:8080"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.genrePicker = UIPickerView()
        self.genrePicker.delegate = self
        self.genrePicker.dataSource = self
        self.genreTF.inputView = self.genrePicker
        self.title = "Add Movie"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.titleTF.resignFirstResponder()
        self.releasedTF.resignFirstResponder()
        self.yearTF.resignFirstResponder()
        self.ratingTF.resignFirstResponder()
        self.runTF.resignFirstResponder()
        self.plotTF.resignFirstResponder()
        self.actorTF.resignFirstResponder()
        self.genreTF.resignFirstResponder()
        self.ratingTF.resignFirstResponder()
    }
    
    
    

    @IBAction func buttonClicked(sender: AnyObject) {
        let title = self.titleTF.text! as String
        let year = self.yearTF.text! as String
        let runTime = self.runTF.text! as String
        let released = self.releasedTF.text! as String
        let actors = self.actorTF.text! as String
        let plot = self.plotTF.text! as String
        let genre = self.genreTF.text! as String
        let rated = self.ratingTF.text! as String
        
        if let infoPlist = NSBundle.mainBundle().infoDictionary {
            self.urlString = ((infoPlist["ServerURLString"]) as?  String!)!
            NSLog("The default urlString from info.plist is \(self.urlString)")
        }else{
            NSLog("error getting urlString from info.plist")
        }
        let movieConnect:MovieCollectionStub = MovieCollectionStub(urlString: self.urlString)
        let movie = MovieDescription(title: title, year: year, released: released, runtime: runTime, rated: rated, genre: genre, actors: actors, plot: plot)
        let resGet:Bool = movieConnect.add(movie, callback: { (res: String, err: String?) -> Void in
        })
        
       // self.movies[md.title] = md
        //self.movieTable?.movies = self.movies
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // functions for the picker view delegate and datasource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreArray.count
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genreTF.text = genreArray[row]
        self.genreTF.resignFirstResponder()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
