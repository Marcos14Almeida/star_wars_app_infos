import 'package:http/http.dart' as http;

///
/// A class representing the SWAP API
///
class SWAPI {

  final String _endpoint = "https://swapi.co/api";

  /// Common method to invoke the HTTP request
  _callAPI(url) async {
    String restURL = "$url?format=json";
    //print(" URL call: $restURL");
    Uri uri = Uri.parse(Uri.encodeFull(restURL));
    return http.get(uri, headers: {"Content-type": "application/json", 'charset':'utf-8'});
  }

  /// An example of using a specific API method
  getRoot() async {
    return _callAPI("$_endpoint/");
  }

  /// Generic Call using URL from API result
  getRawDataFromURL(url) async {
    return _callAPI(url);
  }


}