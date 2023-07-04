//
//  Movies.swift
//  MovieApp
//
//  Created by Ahmed medo 04/07/2023.
//

import Foundation

class Movies: Codable {
    var status: Stat?
    var statusMessage: String?
    var data: DataClass?
    var meta: Meta?

    enum CodingKeys: String, CodingKey {
        case status
        case statusMessage
        case data
        case meta
    }

    init(status: Stat?, statusMessage: String?, data: DataClass?, meta: Meta?) {
        self.status = status
        self.statusMessage = statusMessage
        self.data = data
        self.meta = meta
    }
}

// MARK: - DataClass
class DataClass: Codable {
    var movieCount, limit, pageNumber: Int?
    var movies: [Movie]?

    enum CodingKeys: String, CodingKey {
        case movieCount
        case limit
        case pageNumber
        case movies
    }

}

// MARK: - Movie
class Movie: Codable {
    var id: Int?
    var url: String?
    var imdbCode, title, titleEnglish, titleLong: String?
    var slug: String?
    var year: Int?
    var rating: Double?
    var runtime: Int?
    var genres: [String]?
    var summary, descriptionFull, synopsis, ytTrailerCode: String?
    var language: String?
    var mpaRating: String?
    var backgroundImage, backgroundImageOriginal, smallCoverImage, mediumCoverImage: String?
    var largeCoverImage: String?
    var state: Stat?
    var torrents: [Torrent]?
    var dateUploaded: String?
    var dateUploadedUnix: Int?

    enum CodingKeys: String, CodingKey {
            case id, url
            case imdbCode = "imdb_code"
            case title
            case titleEnglish = "title_english"
            case titleLong = "title_long"
            case slug, year, rating, runtime, genres, summary
            case descriptionFull = "description_full"
            case synopsis
            case ytTrailerCode = "yt_trailer_code"
            case language
            case mpaRating = "mpa_rating"
            case backgroundImage = "background_image"
            case backgroundImageOriginal = "background_image_original"
            case smallCoverImage = "small_cover_image"
            case mediumCoverImage = "medium_cover_image"
            case largeCoverImage = "large_cover_image"
            case state, torrents
            case dateUploaded = "date_uploaded"
            case dateUploadedUnix = "date_uploaded_unix"
        }


}

enum Stat: String, Codable {
    case ok = "ok"
}

// MARK: - Torrent
class Torrent: Codable {
    var url: String?
    var hash: String?
    var quality: String?
    var type: TypeEnum?
    var seeds, peers: Int?
    var size: String?
    var sizeBytes: Int?
    var dateUploaded: String?
    var dateUploadedUnix: Int?

    enum CodingKeys: String, CodingKey {
        case url, hash, quality, type, seeds, peers, size
        case sizeBytes
        case dateUploaded
        case dateUploadedUnix
    }


}

enum TypeEnum: String, Codable {
    case bluray = "bluray"
    case web = "web"
}

// MARK: - Meta
class Meta: Codable {
    var serverTime: Int?
    var serverTimezone: String?
    var apiVersion: Int?
    var executionTime: String?

    enum CodingKeys: String, CodingKey {
        case serverTime
        case serverTimezone
        case apiVersion
        case executionTime
    }

}
