//
//  ITunesSearchProvider.swift
//  iTunesSearch
//
//  Created by Doba Duc on 12/25/15.
//  Copyright © 2015 Ducky Duke. All rights reserved.
//

import Foundation
import Moya


// MARK:- Shared provider declaration
let ItunesProvider = MoyaProvider<ItunesAPITarget>()


// MARK:- iTunes enum declaration
enum ItunesSearchLanguage {
    case EN, JA
    var stringValue: String {
        return self == .JA ? "ja_jp" : "en_us"
    }
}

enum ItunesFeedType: String {
    // Audiobooks
    case TopAudiobooks          = "topaudiobooks"

    // EBooks
    case TopFreeEbooks          = "topfreeebooks"
    case TopPaidEbooks          = "toppaidebooks"
    case TopTextbooks           = "toptextbooks"

    // iOS Apps
    case NewApps                = "newapplications"
    case NewFreeApps            = "newfreeapplications"
    case NewPaidApps            = "newpaidapplications"
    case TopFreeApps            = "topfreeapplications"
    case TopFreeIPadApps        = "topfreeipadapplications"
    case TopGrossingApps        = "topgrossingapplications"
    case TopGrossingIPadApps    = "topgrossingipadapplications"
    case TopPaidApps            = "toppaidapplications"
    case TopPaidIPadApps        = "toppaidipadapplications"

    // Movies
    case TopMovies              = "topmovies"

    // Musics
    case TopSongs               = "topsongs"
    case TopAlbums              = "topalbums"
    case TopIMixes              = "topimixes"

    // Music videos
    case TopMusicVideos         = "topmusicvideos"

    // Podcasts
    case TopPodcasts            = "toppodcasts"

    // TV shows
    case TopTVEpisodes          = "toptvepisodes"
    case TopTVSeasons           = "toptvseasons"

    // TODO: Add iTunesU, Mac Apps, Video rental... later
    static func associatedModel(forFeedType feedType: ItunesFeedType) -> ItunesFeedEntry.Type {
        switch feedType {
        case .NewApps, .NewFreeApps, .NewPaidApps, .TopFreeApps, .TopFreeIPadApps, .TopGrossingApps, .TopGrossingIPadApps, .TopPaidApps, .TopPaidIPadApps:
            return IOSAppFeedEntry.self
        default:
            return ItunesFeedEntry.self
        }
    }
}

protocol ItunesQueryProtocol {
    var apiPath: String { get }
    var dictionary: [String: String] { get }
    var sampleData: NSData { get }
}

struct ItunesSearchQuery: ItunesQueryProtocol {
    var apiPath: String { return "search" }

    //-- Required parameters
    let term: String

    // Default is `us`. Keep this simple for now instead of craeting an enum type to list all possible country codes
    let country: String

    //-- Optional parameters
    // Type of media we want to search for
    var media: String?
    // The type of response we want to get
    var entity: ItunesEntity?
    var attribute: String?
    var limit: Int?
    var lang: ItunesSearchLanguage?
    var version: Int?
    var explicit: Bool?

    init(term: String,
        country: String = "us",
        media: String?,
        entity: ItunesEntity?,
        attribute: String?,
        limit: Int?,
        lang: ItunesSearchLanguage?,
        version: Int? = 2,
        explicit: Bool?) {

            self.term = term
            self.country = country

            if let media = media {
                self.media = media
            }

            if let entity = entity {
                self.entity = entity
            }

            if let attribute = attribute {
                self.attribute = attribute
            }

            if let limit = limit {
                self.limit = limit
            }

            if let lang = lang {
                self.lang = lang
            }

            if let version = version {
                self.version = version
            }

            if let explicit = explicit {
                self.explicit = explicit
            }
    }

    var dictionary: [String: String] {
        var dict = ["term": term, "country": country]

        if let media = media {
            dict["media"] = media
        }

        if let entity = entity {
            dict["entity"] = entity.name
        }

        if let attribute = attribute {
            dict["attribute"] = attribute
        }

        if let limit = limit {
            dict["limit"] = "\(limit)"
        }

        if let lang = lang {
            dict["lang"] = lang.stringValue
        }

        if let version = version {
            dict["version"] = "\(version)"
        }

        if let explicit = explicit {
            dict["explicit"] = explicit ? "true" : "false"
        }

        return dict
    }

    var sampleData: NSData {
        return dataFromJSONFile("searchResults")!
    }
}


struct ItunesLookUpQuery: ItunesQueryProtocol {
    var apiPath: String { return "lookup" }

    // App/Artist/Song/Album... ID
    let id: String

    // Ignore this parameter for now because lookup API returns the same result for both Artist ID and corresponding amgArtistId
    //let amgArtistId: String? = ""

    var dictionary: [String: String] {
        return [:]
    }

    var sampleData: NSData {
        return dataFromJSONFile("lookup_" + id)!
    }
}

// References:
// - Feed generator: https://rss.itunes.apple.com/us/?genre=6014&limit=300&urlDesc=%2Ftoppaidapplications

struct ItunesFeedQuery: ItunesQueryProtocol {
    var apiPath: String {
        return country + "/rss/" + feedType.rawValue + "/limit=\(limit)" + (genre != nil ? "/genre=\(genre)" : "") + "/json"
    }
    var dictionary: [String: String] {
        return [:]
    }

    var country: String = "us"
    var feedType: ItunesFeedType
    var genre: String?

    var limit: Int = 50

    var sampleData: NSData {
        return dataFromJSONFile("feedResults")!
    }
}


// enum ItunesEntityAttribute
enum ItunesEntity {
    // Refer to: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
    case Movie, Podcast, Music, MusicVideo, AudioBook, ShortFilm, TVShow, Software, Ebook, All

    // Entity name will be used as search parameter later
    var name: String {
        switch self {
        case .Movie:        return "movie"
        case .Podcast:      return "podcast"
        case .Music:        return "music"
        case .MusicVideo:   return "musicVideo"
        case .AudioBook:    return "audiobook"
        case .ShortFilm:    return "shortFilm"
        case .TVShow:       return "tvShow"
        case .Software:     return "software"
        case .Ebook:        return "ebook"
        default:            return "all"
        }
    }
}

struct ItunesAPITarget: TargetType {
    let query: ItunesQueryProtocol

    // MARK:- TargetType protocol
    var baseURL: NSURL {
        return NSURL(string: "https://itunes.apple.com/")!
    }

    var path: String {
        return query.apiPath
    }

    var method: Moya.Method { return Moya.Method.GET }

    var parameters: [String: AnyObject]? {
        return query.dictionary
    }

    var sampleData: NSData {
        return query.sampleData
    }

    init(query: ItunesQueryProtocol) {
        self.query = query
    }
}

private func dataFromJSONFile(name: String) -> NSData? {
    let filePath = NSBundle.mainBundle().pathForResource(name, ofType: "json")!
    let jsonString: String? = try? String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
    return jsonString == nil ? nil : jsonString!.dataUsingEncoding(NSUTF8StringEncoding)
}