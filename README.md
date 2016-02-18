     # Swift-iTunesAPI-Demo
An iTunes API demo written in Swift.

# Screenshots
- Top screen

<img src="https://github.com/dobaduc/Swift-iTunesAPI-Demo/blob/master/screenshots/TopScreen.png" width="340">

# APIs

- [iTunes RSS Feed](https://rss.itunes.apple.com/us/?genre=6014&limit=300&urlDesc=/toppaidapplications)
- [iTunes Search](https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html)

# Objects
- iTunes Feed types:
  - TopAudiobooks
  - TopFreeEbooks
  - TopPaidEbooks
  - TopTextbooks
  - NewApps
  - NewFreeApps
  - NewPaidApps
  - TopFreeApps
  - TopFreeIPadApps
  - TopGrossingApps
  - TopGrossingIPadApps
  - TopPaidApps
  - TopPaidIPadApps
  - TopMovies
  - TopSongs
  - TopAlbums
  - TopIMixes
  - TopMusicVideos
  - TopPodcasts
  - TopTVEpisodes
  - TopTVSeasons
- iTunes Search result types:
  - Movie    
  - Podcast
  - Music
  - MusicVideo
  - AudioBook
  - ShortFilm
  - TVShow
  - Software
  - Ebook:    

# Sample code

```swift
// Get entries from a specific RSS feed type
let target = ItunesAPITarget(query: ItunesFeedQuery(country: "us",feedType: feedType, genre: nil, limit: 50))

ItunesProvider.request(target, completion: { (result) -> () in
	switch result {
	case let .Success(response):
		do {
			let json = try response.mapJSON() as! [String: AnyObject]
			let ModelClass = ItunesFeedType.associatedModel(forFeedType: self.feedType)
			switch ModelClass {
			case is IOSAppFeedEntry.Type:
				self.items = Mapper<IOSAppFeedEntry>().mapArray(json["feed"]!["entry"])!
			default:
				self.items = Mapper<ItunesFeedEntry>().mapArray(json["feed"]!["entry"])!
			}
		} catch {
			// Error
			self.items = []
		}
	case let .Failure(error):
		// Do something to handle error
	}
})
```

# Libraries

This demo uses:
- [Moya](https://github.com/Moya/Moya) as the network layer
- [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) for JSON mapping

# License
SegmentedController is released under the MIT license. See LICENSE for details.
