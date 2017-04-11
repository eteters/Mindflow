//
//  AlchemyNewsGetter.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/9/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import Foundation
//MARK: mark: fields
class AlchemyNewsGetter { //reference type I think

    static var searchTerm = ""
    static var apiKeys = ["5bbcf2bb3d9f0afedb5672b0d787cc2c6207553a", "30929c0c0eb414a6b01db1542387f69e7263f41a", "f5943c50c5fa75575aed82097e65d82cbf31d90f", "43475467de10b00c9f6aa5a5daa5ed6110e34316", "fa916d3396de9eb70a3b85ea0b4109cb5a852c6d", "c4d7ddd19a12a535b37e8101e5464d0c3a47b254", "52a01b6df923b428f424a6d7822eab2ad141a099", "bec96835971acbb685966db5ffa6c003261ed507", "5d6f80f568b05611fad5eff95366d728f1699d8e", "3e7dabbe5a0f198fbc53730e1b8cbd98b6621b78"]
    //"5bbcf2bb3d9f0afedb5672b0d787cc2c6207553a"  //  5bbcf2bb3d9f0afedb5672b0d787cc2c6207553a
    //NO longer works: 45b5c28f7ecf35b31792fc2ed970d5b6a3da3d0b  HUMERA'S CODE: 30929c0c0eb414a6b01db1542387f69e7263f41a
    static var baseUrlString = "https://gateway-a.watsonplatform.net/calls/data/GetNews?"
    static var start = "now-1d"
    static var end = "now"
    static var currentKey = 0;
    //maxResults may need to be "count" or vice versa. Find the difference between the two.
    static var maxResults = "2" //easier to keep this as a string or convert to string??

    static var returnTypes = "enriched.url.title,"
        + "enriched.url.entities.entity.text,"
        + "enriched.url.entities.entity.sentiment,"
        + "enriched.url.entities.entity.relevance,"
        + "enriched.url.entities.entity.count,"
        + "enriched.url.entities.entity.type,"
        //    + "enriched.url.entities.entity,"
        + "enriched.url.publicationDate.date,"
        + "enriched.url.url"


    //current default returns

    var searchLoc = "body" //Not currently using, not sure if we or anyone would ever decide to look for mention in the title


    static var allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)


    static let dateTimeFormatter = DateFormatter()



    //MARK: mark:search function
    class func search(searchText: String, userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, [Entity]?,[Article]?, String?) -> Void) {
        guard let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, nil, "problem preparing search text")
            })
            return
        }
        //MARK: THIS CODE MIGHT NOT WORK, DO I USE COUNT OR MAXRESULTS IDK "&rank=high^medium" +"&rank=high" +
        let urlString = baseUrlString + "apikey=" + apiKeys[currentKey] + "&outputMode=json&start=" + start + "&end=" + end +  "&maxResults=" + maxResults + "&q.enriched.url.enrichedTitle.keywords.keyword.text=" + escapedSearchText + "&return=" + returnTypes + "&dedup=1"
        
        print(urlString)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, nil, "the url for searching is invalid" )
            })
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                var errorString = "data not available from search"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, nil,  errorString)
                })
                return
            }
            
            
            
            let (entities, articles, errorString) = parseJson(with: data)
            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, nil, errorString)
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, entities, articles, nil)
                })
            }
        }
        
        task.resume()
    }


    //MARK: mark: internal parse function
    class func parseJson(with data: Data) -> ([Entity]?, [Article]?, String?) {
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []), let rootNode = json as? [String:Any] else {
            return (nil, nil, "unable to parse response from news server")
        }
        
        guard let status = rootNode["status"] as? String, status == "OK" else {
            return (nil, nil, "server did not return OK")
        }
        
        var entityArray = [Entity]()
        var articleArray = [Article]()
        //if let responseDictionary = json as? [String: Any]
        
        dateTimeFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let responseDictionary = json as? [String: Any] {
                if let result = responseDictionary["result"] as? [String:Any]{
                    if let docs = result["docs"] as? [Any]{
                        for article in docs {
                            if let article = article as? [String:Any],
                                let source = article["source"] as? [String:Any],
                                let enriched = source["enriched"] as? [String:Any],
                                let url = enriched["url"] as? [String:Any],
                                let articleTitle = url["title"] as? String,
                                let articleURL = url["url"] as? String,
                                let publicationNode = url["publicationDate"] as? [String:Any],
                                let publicationDateString = publicationNode["date"] as? String,
                                let publicationDate = dateTimeFormatter.date(from: publicationDateString),
                                let entities = url["entities"] as? [Any] {
                                var tempArticle = Article(title: articleTitle, url: articleURL, author: "", pubDate: publicationDate)
                                articleArray.append(tempArticle)
                                for ent in entities {
                                    if let ent = ent as? [String:Any],
                                        let count = ent["count"] as? Int,
                                        let relevance = ent["relevance"] as? Double,
                                        tempArticle.addEntityRelevance(relevance: relevance),
                                        let entName = ent["text"] as? String,
                                        let entType = ent["type"] as? String,
                                        let sentimentNode = ent["sentiment"] as? [String:Any],
                                        let sentimentType = sentimentNode["type"] as? String,
                                        let sentimentScore = sentimentNode["score"] as? Double{
                                        let tempEntity = Entity(AlchemyWithCount: count, relevance: relevance, sentimentType: sentimentType, sentimentScore: sentimentScore, entityName: entName, entityType: entType, article: tempArticle)
                                        
                                        
                                        if entityArray.contains(where: { $0.entityName.lowercased() == tempEntity.entityName.lowercased() }) {
                                            if let ind = entityArray.index(where: {$0.entityName == tempEntity.entityName}) {
                                                entityArray[ind].count += tempEntity.count
                                                entityArray[ind].articles.append(contentsOf: tempEntity.articles)
                                                entityArray[ind].relevance = (tempEntity.relevance + entityArray[ind].relevance * (Double(entityArray[ind].articles.count - 1)) ) / Double(entityArray[ind].articles.count)
                                                //entityArray[ind].sentimentScore = (tempEntity.sentimentScore + entityArray[ind].sentimentScore)/2
                                            }
                                            
                                        }
                                        else { entityArray.append(tempEntity) }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return (entityArray, articleArray, nil)
    }

    //let articleAuthor = url["author"] as? String,
}

