import 'package:http/http.dart' as http;
import 'dart:convert';
/*
const GOOGLE_API_KEY = 'AIzaSyCDyXURCDZXWL4lE9jeYTV5drRuutLNgak';

// search for google maps static api
class LocationHelper {
  static String generateLocationPreviewImage(
      {double? latitude, double? longitude}) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap &markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=$GOOGLE_API_KEY";
  }

}
*/

const MAPBOX_API_KEY =
    'pk.eyJ1IjoiZGVtaWFuMjAyMSIsImEiOiJja3dpOGl6YXMwbDJ2Mm5sNTNiM2NmN2xzIn0.QNli89KGJAB8lZklFjP0uw';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double? latitude, double? longitude}) {
    //return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l($longitude,$latitude)/$longitude,$latitude,14.25,0,0/600x300?access_token=$MAPBOX_API_KEY';
      return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-l($longitude,$latitude)/$longitude,$latitude,14.25,0,60/600x300?access_token=$MAPBOX_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async{
    final url = Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?limit=1&access_token=$MAPBOX_API_KEY');
    final response = await http.get(url);
    var teste = json.decode(response.body);
    return teste['features'][0]['place_name'];
  }
}
