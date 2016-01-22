//
//  Album.swift
//  HelloWorld
//
//  Created by macbookpro1 on 22/01/2016.
//  Copyright © 2016 macbookpro1. All rights reserved.
//

import Foundation

struct Album {
    let title: String
    let price: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let itemURL: String
    let artistURL: String
    let collectionId: Int
    
    init(title: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int) {
        self.title = title
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    static func albumsWithJSON(results: NSArray) -> [Album] {
        // Create an empty array of Albums to append to from this list
        var albums = [Album]()
        
        // Store the results in our table data array
        if results.count > 0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in results {
                
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        let priceFloat: Float? = result["collectionPrice"] as? Float
                        let nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                if let collectionId = result["collectionId"] as? Int {
                    let newAlbum = Album(title: name!,
                        price: price!,
                        thumbnailImageURL: thumbnailURL,
                        largeImageURL: imageURL,
                        itemURL: itemURL!,
                        artistURL: artistURL,
                        collectionId: collectionId)
                    albums.append(newAlbum)
                }
            }
        }
        
        return albums
    }
}