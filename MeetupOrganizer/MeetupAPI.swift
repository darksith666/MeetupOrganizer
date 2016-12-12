//
//  MeetupAPI.swift
//  MeetupOrganizer
//
//  Created by Ayuna NYC on 11/29/16.
//  Copyright © 2016 Ayuna NYC. All rights reserved.
//

import UIKit
import Alamofire

// construct URL to make API requests
// validate JSON response
// pass to the Store to convert into Meetup objects ?
// OR convert into meetup projects , pass to the store the array of objects if validation is successful


struct MeetupAPI
{
    private static let APIKey = "4131436d16334b6c5f3c2b4630685a29"
    private static let baseURLString = "https://api.meetup.com"
    
    private static let member_id = "136388792"  // member_id
    private static let rsvp = "yes"  // rsvp
    private static let page = "15"  // results per page
    private static let status = "upcoming"  // past also? comma delimited?
    
    // MARK: - URL
    
    var urlComponents = URLComponents()
    
    init()
    {
        urlComponents.scheme = "https"
        urlComponents.host = "api.meetup.com"
        urlComponents.queryItems = [URLQueryItem(name: "key", value: MeetupAPI.APIKey)]
    }
    

    // MARK: - Upload Photos
    
    // Meetup API - Upload Photos - Documentation: http://www.meetup.com/meetup_api/docs/:urlname/events/:event_id/photos/#upload

    mutating func uploadPhotosURLWithComponents(groupName: String?, eventID: String?) -> URL! // bang?
    {
        guard let _groupName = groupName, let _eventID = eventID else { return nil } // return nil ?
        urlComponents.path = "/\(_groupName)/events/\(_eventID)/photos"
        return urlComponents.url // ? !
    }

    
    mutating func uploadImageData(image: UIImage, groupName: String, eventID: String) // ?
    {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
       
        // gemma barlow event
        let url = self.uploadPhotosURLWithComponents(groupName: groupName, eventID: eventID)!
                
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            multipartFormData.append("true".data(using: .utf8)!, withName: "await")
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
            }
        })
    }
 
    
    
    // MARK: - Events

    // get authenticated member id
    // pull events of an authenticated member -> events array
    // dispaly events
    // event detail vc
    // upload photos
    
    
    // to get events photos
    
    let getEventsPhotosURLRequest = "https://api.meetup.com/iOSoho/events/235269311/photos?&sign=true&photo-host=public&page=20&fields=self"
    
    // returns an array of dictionaries
    // each dictionary contains: https://api.meetup.com/iOSoho/events/235269311/photos?photo-host=public&page=20&sig_id=136388792&fields=self&sig=cab57496b1a0feac30138e37029d9f5e8ea3a3e2
    //        / id: 456316179,
    //    highres_link: "http://photos1.meetupstatic.com/photos/event/3/f/3/3/highres_456316179.jpeg",
    //    photo_link: "http://photos1.meetupstatic.com/photos/event/3/f/3/3/600_456316179.jpeg",
    //    thumb_link: "http://photos1.meetupstatic.com/photos/event/3/f/3/3/thumb_456316179.jpeg",
    //    type: "event",
    //    base_url: "http://photos1.meetupstatic.com",
    //    link: "https://www.meetup.com/iOSoho/photos/27444613/456316179/", and other params
}
