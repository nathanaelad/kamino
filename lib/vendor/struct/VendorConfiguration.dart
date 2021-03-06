import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

abstract class VendorConfiguration {

  String tmdbKey;
  TraktCredentials traktCredentials;

  final String name;

  ///
  /// A VendorConfiguration should be used to change the default settings in the
  /// ApolloTV app. Simply create your own class and extend [VendorConfiguration].
  ///
  /// [name] - The name of the vendor. If you are developing this independently,
  ///           use your GitHub name.
  ///
  VendorConfiguration({
    @required this.name,

    this.tmdbKey,
    this.traktCredentials
  });

  ///
  /// Returns the name of the Vendor, as provided when the configuration object
  /// was initialized.
  ///
  String getName(){
    return name;
  }

  ///
  /// This method will be called in order to authenticate with the vendor API.
  /// All keys generated by this method should be stored internally.
  /// However, they will not be used until this has completed.
  ///
  /// This method returns a [bool] to determine whether authentication was
  /// successful.
  ///
  Future<bool> authenticate();

  Future<dynamic> playMovie(String title, BuildContext context);
  Future<dynamic> playTVShow(
      String title,
      String releaseDate,
      int seasonNumber,
      int episodeNumber,
      BuildContext context
    );

  String getTMDBKey(){
    if(tmdbKey != null){
      return tmdbKey;
    }else{
      throw new Exception("Invalid TMDB API key for provider ${getName()}.");
    }
  }

  /// Whether this vendor configuration supports resolving on the client-side.
  bool get supportsClientSideResolver {
    return false;
  }

  TraktCredentials getTraktCredentials(){
    if(traktCredentials != null){
      return traktCredentials;
    }else{
      throw new Exception("Invalid TMDB API key for provider ${getName()}.");
    }
  }

  /// Format a TV/Movie title.
  ///
  /// If a [seasonNumber] and [episodeNumber] is specified (not null), it formats
  /// the title as "Title S01E01".
  /// However if only a [releaseDate] is specified, it's formatted as "Title (yyyy)".
  ///
  /// The [releaseDate] should be an ISO 8601 string and is normally in
  /// the format yyyy-mm-dd.
  String formatTitle(String mediaType, String title,
      [String releaseDate, seasonNumber, episodeNumber]) {
    var buffer = new StringBuffer(title);
    if (seasonNumber != null && episodeNumber != null) {
      buffer.write(' S');
      buffer.write(seasonNumber.toString().padLeft(2, '0'));
      buffer.write('E');
      buffer.write(episodeNumber.toString().padLeft(2, '0'));
    } else if (releaseDate != null) {
      buffer.write(' (');
      buffer
          .write(new DateFormat.y("en_US").format(DateTime.parse(releaseDate)));
      buffer.write(' )');
    }
    return buffer.toString();
  }
}

class TraktCredentials {

  String id;
  String secret;

  TraktCredentials({
    @required this.id,
    @required this.secret
  });

}

/// Object representing the state of the current request.
abstract class VendorSubscription {
  // Disconnected.
  bool disconnected = false;

  dynamic disconnect();
}