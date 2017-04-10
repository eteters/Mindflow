//
//  AylienNewsGetter.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 4/8/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import Foundation

class AylienNewsGetter {
    
    static var searchTerm = ""
    
    static var baseUrlString = "https://api.newsapi.aylien.com/api/v1"
    
    static var allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
    
    //https://api.newsapi.aylien.com/api/v1/stories?text=Syria%20&language%5B%5D=en&published_at.start=NOW-30DAYS&published_at.end=NOW&categories.confident=true&cluster=false&cluster.algorithm=lingo&sort_by=hotness&sort_direction=desc&cursor=*&per_page=5


    
    static var text = ""
    
    static var language = "en"
    
    static var pubStart = "NOW-1DAY&"
    
    static var pubEnd = "NOW"
    
//    static var categoriesConfident = true is default
    
    static var clusterEnabled = "false"
    
    static var clusterAlg = "lingo"
    
    static var sortBy = "hotness" //relevance -- story relevance I suppose, recency, published_at (default), social_shares_count, media, source links, lots of alexa ranks
    
    static var sortDir = "desc" //or asc
    
    static var perPage = "2"
    
    
    
    class func search(searchText: String, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping ([Entity]?, [Article]?, String?) -> Void) {
        
        let urlString = "https://api.newsapi.aylien.com/api/v1/stories?text=" + searchText +  "&language%5B%5D=" + language + "&published_at.start=" + pubStart + "&published_at.end=" + "&categories.confident=true&cluster=" + clusterEnabled + "&cluster.algorithm=" + clusterAlg + "&sort_by=" + sortBy + "&sort_direction=" + sortDir + "&cursor=*&per_page=" + perPage

        
        guard let escapedUrl = urlString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(nil, nil, "problem preparing search text")
            })
            return

        }
        
        
    //Define and send URL request? 
        let config = URLSessionConfiguration.default // Session Configuration
        
        let appId = "b5a4d764"
        let appKey = "36e44dc21a27649b2712016964459ea3"
        let appIdData = appId.data(using: String.Encoding.utf8)!
        let appKeyData = appKey.data(using: String.Encoding.utf8)!
        
        
        config.httpAdditionalHeaders = ["X-AYLIEN-NewsAPI-Application-ID" : "\(appIdData)", "X-AYLIEN-NewsAPI-Application-Key": "\(appKeyData)"]
        
        
        let session = URLSession(configuration: config) // Load configuration into Session
        
        if let url = URL(string: escapedUrl) {
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
//            var params: Dictionary<String, String> = Dictionary<String, String>()
//            params["text"] = sourceText
//            
//            if let jsonPostData = try? JSONSerialization.data(withJSONObject: params, options: []) {
//                urlRequest.httpBody = jsonPostData
//            }
//            
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    print("error")
                    DispatchQueue.main.sync(execute: {
                        completionHandler(nil, nil, error!.localizedDescription)
                    })
                } else {
                    print("data")
                    if let data = data {
                        let (entities, articles, errorString) = self.parseJson(with: data)
                        if let errorString = errorString {
                            dispatchQueueForHandler.async(execute: {
                                completionHandler(nil, nil, errorString)
                            })
                        } else {
                            dispatchQueueForHandler.async(execute: {
                                completionHandler(entities, articles, nil)
                            })
                        }
                    }
                }
                
            })
            

        }
        //task.resume()

    }
    
    
    
    
    class func parseJson(with data: Data) -> ([Entity]?, [Article]?, String?) {
        
        var entityArray = [Entity]()
        var articleArray = [Article]()
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let responseDictionary = json as? [String: Any] {
                if let stories = responseDictionary["stories"] as? [Any] {
                    for story in stories {
                        if let story = story as? [String:Any],
                        let entities = story["entities"] as? [String: Any],
                        let titleEntities = entities["title"] as? [Any],
                        let bodyEntities = entities["body"] as? [Any],
                        let keywords = story["keywords"] as? [String],
                        let pubDateString = story["published_at"] as? String,
                        let publicationDate = dateTimeFormatter.date(from: pubDateString),
                        let articleTitle = story["title"] as? String,
                        let articleBody = story["body"] as? String,
                        let source = story["source"] as? [String:Any],
                        let articleSourceName = source["name"] as? String,
                        let links = story["links"] as? [String:Any],
                        let articleUrl = links["permalink"] as? String{
                            var tempArticle = Article(title: articleTitle, url: articleUrl, author: articleSourceName, pubDate: publicationDate)
                            //TODO: Todo. Add body to articles data. Add source to article data. Maybe add image url to article data. Change the way article author works, or its name
                            
                            for entity in titleEntities {
                                if let entity = entity as? [String:Any],
                                    let entityName = entity["text"] as? String,
                                let indices = entity["indices"] as? [Any]{
                                    var tempEntity:Entity
                                    let count = indices.count
                                    if let entityScore = entity["score"] as? Double {
                                        tempEntity = Entity(count: count, relevance: entityScore, sentimentType: "aylien", sentimentScore: 0, entityName: entityName, entityTypes: <#T##String#>, article: <#T##Article#>)
                                    }
                                    else {
                                        tempEntity = Entity(count: <#T##Int#>, relevance: <#T##Double#>, sentimentType: <#T##String#>, sentimentScore: <#T##Double#>, entityName: <#T##String#>, entityType: <#T##String#>, article: <#T##Article#>)
                                    }
                                    
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
            }
        }

    }
    
}
