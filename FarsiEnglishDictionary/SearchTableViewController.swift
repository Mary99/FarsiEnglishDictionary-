//
//  SearchTableViewController.swift
//  FarsiEnglishDictionary
//
//  Created by Maryam Rajaei on 2017-11-04.
//  Copyright © 2017 veddes. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController,UISearchResultsUpdating, NSFetchedResultsControllerDelegate {

    var searchController:UISearchController!
    var fetchResultController: NSFetchedResultsController<MyWordRefMO>!
    var searchList :[MyWordRefMO] = []
    var wordList  :[MyWordRefMO] = []
    var cellExpandedIndicator:NSInteger = -1
    var speackVoice:Speech!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure search Bar
        configureSearchBar()
        
        // Fetch data from data store
        fetchData()
        
        speackVoice = Speech(rate:0.25,pitch:0.25,volume:0.25)
        speackVoice.initialSpeechSettings()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return searchList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "myMainTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        let myCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! myMainTableViewCell
        
        // Determine if we get the restaurant from search result or the original array
       // let myWord = (searchController.isActive) ? searchList[indexPath.row]
        //    : wordList[indexPath.row]
        
       //let displaylist = whichListToDisplay()
        
        myCell.farsiLable.text  = searchList[indexPath.row].english!
        myCell.englishLable.text = searchList[indexPath.row].farsi!
        
        return myCell
    }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Mark: - Table view cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightOfCell = (cellExpandedIndicator==indexPath.row) ? 150.00 : 50.00
        return CGFloat(heightOfCell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //user tap on the cell that is already expanded and it will be collapse(close)
        if (cellExpandedIndicator == indexPath.row) {
            cellExpandedIndicator = -1;
            tableView.reloadRows(at: [indexPath], with:UITableViewRowAnimation.fade)
            return
        }
        //user tap different row
        if (cellExpandedIndicator != -1) {
            cellExpandedIndicator = indexPath.row;
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        //user tap new row for first time meaning cellExpandedIndicator is -1
        //cellExpandedIndicator is equal indexpath.row and voice is played
        cellExpandedIndicator=indexPath.row;
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        //play the voice here
        speackVoice.speak(a: searchList[indexPath.row].english!)
    }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //MARK: - Filter & Search
   
    func filterContent(for searchText: String) {
      searchList = wordList.filter({ (theWord) -> Bool in
         if let fWord = theWord.farsi, let eWord = theWord.english {
            let isMatch = fWord.localizedCaseInsensitiveContains(searchText) || eWord.localizedCaseInsensitiveContains(searchText)
         return isMatch
            
        }
         return false
    })
   }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - Fetching data and Updating tableView
    func fetchData() {
        //fetch request object from RestaurantMO
        let fetchRequest: NSFetchRequest<MyWordRefMO> = MyWordRefMO.fetchRequest()
        //what way to sort
        let sortDescriptor = NSSortDescriptor(key: "english", ascending: true)
        //fetch request object and sort instuction you made
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //get refrence to app delegate to persistentcontainer object and it context
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
        //create fetchresultController object
        fetchResultController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                managedObjectContext: context,
                                sectionNameKeyPath: nil,
                                cacheName: nil)
            
            //who is monitoring data change
            fetchResultController.delegate = self
            
            //here we finally perform  performFetch()
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    wordList = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            wordList = fetchedObjects as! [MyWordRefMO]
        }
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - Search bar Configuration
    func configureSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "کلمه  فارسی یا انگلیسی را اینجا جستجو کنید"
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 218.0/255.0, green:
            100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    }
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
