//
//  MovieTableController.swift
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

class MovieTableController: UITableViewController {
    
    @IBOutlet var movieTable: UITableView!
    var urlString:String = "http://localhost:8080"
    
    var movies:[String : MovieDescription] = [String:MovieDescription]()
    
    //var movieLibrary : MovieLibrary?
    //var allMovieKeys : NSMutableArray = NSMutableArray()
    var selectedMovie : String = ""
    var allMovies:[String] = [String]()
    
    override func viewDidLoad() {
     super.viewDidLoad()
        
        //movieLibrary = MovieLibrary.init()
        //self.movies = (movieLibrary?.movies)!
        if let infoPlist = NSBundle.mainBundle().infoDictionary {
            self.urlString = ((infoPlist["ServerURLString"]) as?  String!)!
            NSLog("The default urlString from info.plist is \(self.urlString)")
        }else{
            NSLog("error getting urlString from info.plist")
        }
        let movieConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
        let resultNames:Bool = movieConnect.getNames({ (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                    do{
                        let dict = try NSJSONSerialization.JSONObjectWithData(data,options:.MutableContainers) as?[String:AnyObject]
                        self.allMovies = (dict!["result"] as? [String])!
                        self.tableView.reloadData()
                        
                        //self.studSelectTF.text = ((self.students.count>0) ? self.students[0] : "")
                        //self.studentPicker.reloadAllComponents()
                        //if self.allMovies.count > 0 {
                        //    self.callGetNPopulatUIFields(self.students[0])
                        //}
                    } catch {
                        print("unable to convert to dictionary")
                    }
                }
                
            }
        })
        self.navigationItem.leftBarButtonItem = editButtonItem()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        viewDidLoad()
        //self.movieTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allMovies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        var cell : UITableViewCell = UITableViewCell()
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "tableCell")
        
        //cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.allMovies[indexPath.row]
        //cell.detailTextLabel?.text = self.allMovies[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedMovie = self.allMovies[indexPath.row] 
        performSegueWithIdentifier("movieDetail", sender: self)
        self.movieTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func addClicked(sender: AnyObject) {
        performSegueWithIdentifier("addMovie", sender: self)
    }
    
    @IBAction func refreshClicked(sender: AnyObject) {
        viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "movieDetail"){
            let destinationViewController =  segue.destinationViewController as! ViewController
            destinationViewController.selectedMovie = self.selectedMovie
            destinationViewController.urlString = self.urlString
            destinationViewController.movies = self.movies
        } else if(segue.identifier == "addMovie") {
            let destinationViewController =  segue.destinationViewController as! AddMovieController
            destinationViewController.movies = self.movies
            destinationViewController.movieTable = self
        }
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //var name : String = self.studSelectTF.text!
            if let infoPlist = NSBundle.mainBundle().infoDictionary {
                self.urlString = ((infoPlist["ServerURLString"]) as?  String!)!
                NSLog("The default urlString from info.plist is \(self.urlString)")
            }else{
                NSLog("error getting urlString from info.plist")
            }
            let movieConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
            let resGet:Bool = movieConnect.remove(self.allMovies[indexPath.row], callback: { (res: String, err: String?) -> Void in
            })
            self.allMovies.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}