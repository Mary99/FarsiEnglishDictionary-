//
//  myMainViewController.swift
//  FarsiEnglishDictionary
//
//  Created by Maryam Rajaei on 2017-11-04.
//  Copyright © 2017 veddes. All rights reserved.
//

import UIKit
import CoreData


class MyMainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate
{
    //create fetchResultControllerObject
    var fetchResultController: NSFetchedResultsController<MyWordRefMO>!
    //track if cell is expanded or not
    var cellExpandedIndicator:NSInteger = -1
    var passedTitle :ListMO!
    var wordList :[MyWordRefMO] = []
    //voice playing obj from Speech Class
    var speackVoice:Speech!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title of dictionary will be added to the middle of VC navigation bar
        title = passedTitle.listingName
        
        //Obj of Speech class and initial settings
        speakVoiceSetup()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
       getData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       tableView.register(UINib(nibName: "myMainTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
       let myCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! myMainTableViewCell
        
        myCell.farsiLable.text   = wordList[indexPath.row].english!
        myCell.englishLable.text = wordList[indexPath.row].farsi!
        
        myCell.favoriteButton.isUserInteractionEnabled = true
        myCell.favoriteButton.tag = indexPath.row
        myCell.favoriteButton.addTarget(self, action: #selector(addF(_:)),for: UIControlEvents.touchUpInside)
        
        return myCell
    }
    
    @objc func addF(_ sender: UIButton) {
        print("button is clicked")
        print("Tapped at row \(sender.tag)")
        print("Favorite word \(wordList[sender.tag])")
    }
    
  
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //MARK: - TableView cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let heightOfCell = (cellExpandedIndicator==indexPath.row) ? 150.00 : 50.00
        return CGFloat(heightOfCell)
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
        speackVoice.speak(a: wordList[indexPath.row].english!)
    }
    
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: Fetch data from data store
    func getData() {
    let fetchRequest: NSFetchRequest<MyWordRefMO> = MyWordRefMO.fetchRequest()
     fetchRequest.predicate = NSPredicate(format: "toListFromDic == %@", passedTitle)
    let sortDescriptor = NSSortDescriptor(key: "itemNumber", ascending: true)
     fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext

            fetchResultController = NSFetchedResultsController(fetchRequest:fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,
                              cacheName: nil)
            fetchResultController.delegate = self

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
    
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    func speakVoiceSetup() {
        speackVoice = Speech(rate:0.25,pitch:0.25,volume:0.25)
        speackVoice.initialSpeechSettings()
    }
}
