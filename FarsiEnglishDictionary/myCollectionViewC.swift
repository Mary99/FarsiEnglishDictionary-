//
//  myCollectionViewC.swift
//  FarsiEnglishDictionary
//
//  Created by Maryam Rajaei on 2017-11-03.
//  Copyright © 2017 veddes. All rights reserved.
//

import UIKit
import CoreData

class MyCollectionViewC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

    var imageList :[ListMO] = []
    var fetchResultController: NSFetchedResultsController<ListMO>!
    
    @IBOutlet var collectionView: UICollectionView!
    //var imageList = [String]()
    
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        
    //load the array with name of pictures.
// +++++++++++++++imageList=      ["common","greeting","eating","shopping","date","number","animal","studies","color","transportation","sightseeing","hotel","occupation","fruit","weather","time","hobbies","health","romance","emergency","favorite"]
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            .plain, target: nil, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     //for iphone portrait the cell size is 140*140 and for the rest is 180*180
        let sideSize = (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 140.0 : 180.0
        
        return CGSize(width: sideSize, height: sideSize)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: UICollectionViewDataSource
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
        
        // Configure the cell
        cell.collectionImage.image = UIImage (named:imageList[indexPath.row].listingName!)
        
        return cell
    }
    
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - Fetch data from data store
    func getData() {
       
        let fetchRequest: NSFetchRequest<ListMO> = ListMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "listingName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest:
                fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,
                              cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    imageList = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToWordList" ){
            if let indexPath = collectionView?.indexPathsForSelectedItems  {
               let destinationController = segue.destination as! MyMainViewController
               //destinationController.dictionaryTitle = imageList[indexPath[0].row].listingName
                destinationController.passedTitle = imageList[indexPath[0].row]
            }
        }
    }//end of segue method

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    

}
