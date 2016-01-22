//
//  DetailsViewController.swift
//  HelloWorld
//
//  Created by macbookpro1 on 22/01/2016.
//  Copyright © 2016 macbookpro1. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var album: Album?
    var tracks = [Track]()
    var previousTrack: NSIndexPath!
    
    var api: APIController!
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var tracksTableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previousTrack = nil;
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        // Load in tracks
        if self.album != nil {
            api = APIController(delegate: self)
            api.lookupAlbum(self.album!.collectionId)
        }
    }
    
    // MARK: Table View methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = tracks[indexPath.row]
        
        if self.previousTrack != nil {
            if let previousCell = tableView.cellForRowAtIndexPath(self.previousTrack) as? TrackCell {
                previousCell.playIcon.text = "▶️"
            }
        }
        
        mediaPlayer.stop()
        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "⏹"
        }
        
        self.previousTrack = indexPath
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}