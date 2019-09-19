import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vinora/home_page.dart';
import 'package:vinora/requests/google_map_requests.dart';
class GetUserLocation extends StatefulWidget {
  @override
  _GetUserLocationState createState() => _GetUserLocationState();
  
}

class _GetUserLocationState extends State<GetUserLocation> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map()
      
            );
          }
        
          
}
class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;
  GoogleMapsServices _googleMapsServices=GoogleMapsServices();
  TextEditingController locationController=TextEditingController();
  TextEditingController destinationController=TextEditingController();
  static LatLng _initialPosition;
  LatLng _lastPosition=_initialPosition;
  final Set<Marker> _markers={};
  final Set<Polyline> _polyLines={};
  double distance=0;
  String destinationPoint=null;
  LatLng preLocation;
  double speed=0;
  @override
  void initState() {
    
    super.initState();
    _getUserLocation();
      }
    @override
  void setState(fn) {
    if(_initialPosition!=null&&preLocation!=null){
      _markers.remove(preLocation.toString()); 
    _markers.add(Marker(
        markerId: MarkerId(_initialPosition.toString()),
        position: _initialPosition,
        
        icon: BitmapDescriptor.defaultMarker));
    }
    super.setState(fn);
  }
      @override
      Widget build(BuildContext context) {

        return  _initialPosition==null?Container(
          alignment: Alignment.center,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ): Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 10.0,
                  
                  
                ),
                
                
                onMapCreated: onCreated,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: _markers,
                onCameraMove: _onCameraMove,
                polylines: _polyLines,
                

                ),
       
                                      Positioned(
                    top: 50.0,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.0, 5.0),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ],
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: locationController,
                        decoration: InputDecoration(
                          icon: Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            width: 10,
                            height: 10,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                          ),
                          hintText: "Current Location",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                        ),
                      ),
                    ),
                  ),
    
                  Positioned(
                    top: 105.0,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.0, 5.0),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ],
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: destinationController,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) {
                          sendRequest(value);
                          destinationPoint=value;
                        },
                        decoration: InputDecoration(
                          icon: Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            width: 10,
                            height: 10,
                            child: Icon(
                              Icons.local_taxi,
                              color: Colors.black,
                            ),
                          ),
                          hintText: "destination?",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Align(alignment: Alignment.bottomCenter,child: Text("Distance : "+distance.toStringAsFixed(3)+" km "+"Speed :"+speed.toStringAsFixed(3)+" km/s",
                    style:TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,),),
                  ),
                  
  
                                      // Positioned(
                                      //   top:40,
                                      //   right: 10,
                                      //   child: FloatingActionButton(
                                      //     onPressed: _onAddMarkerPressed,
                                      //     tooltip: "add marker",
                                      //     backgroundColor: black,
                                      //     child: Icon(Icons.add_location,color: Colors.white,),
                                      //                                         ),
                                          
                                      //                                       )
                                                                          ],
                                                                        );
                                                                    }
                                                                  
                                                                    void onCreated(GoogleMapController controller) {
                                                                      setState(() {
                                                                       mapController=controller; 
                                                                      });
                                                        }
                                                      
                                                        void _onCameraMove(CameraPosition position) {
                                                          setState(() {
                                                            _lastPosition=position.target;
                                                          });
                                          
                                            }
                                          
                                            void _onAddMarkerPressed() {
                                              setState(() {
                                               _markers.add(Marker(markerId: MarkerId(_lastPosition.toString()),position: _lastPosition,infoWindow: InfoWindow(
                                                 title: "remember here",
                                                 snippet: "good place",
    
                                               ),
                                               icon: BitmapDescriptor.defaultMarker));
                                              });
    
      }
      void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    
  }


      List<LatLng> convertToLatLng(List points){
        List<LatLng> result=<LatLng>[];
        for(int i=0;i<points.length;i++){
          if(i%2!=0){
            result.add(LatLng(points[i-1],points[i]));

          }
        }
        return result;
      }
       List decodePoly(String poly) {
        var list = poly.codeUnits;
        var lList = new List();
        int index = 0;
        int len = poly.length;
        int c = 0;
    // repeating until all attributes are decoded
        do {
          var shift = 0;
          int result = 0;
    
          // for decoding value of one attribute
          do {
            c = list[index] - 63;
            result |= (c & 0x1F) << (shift * 5);
            index++;
            shift++;
          } while (c >= 32);
          /* if value is negetive then bitwise not the value */
          if (result & 1 == 1) {
            result = ~result;
          }
          var result1 = (result >> 1) * 0.00001;
          lList.add(result1);
        } while (index < len);
    
    /*adding to previous value as done in encoding */
        for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    
        
    
        return lList;
      }
    
      void _getUserLocation() async {
        Position position=await Geolocator().getCurrentPosition(desiredAccuracy: prefix0.LocationAccuracy.high);
        _initialPosition=LatLng(position.latitude,position.longitude);
        preLocation=_initialPosition;
        setState(() {
          var location=new Location();
        location.onLocationChanged().listen((LocationData currentLocation) async{
        List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(currentLocation.latitude,currentLocation.longitude );
        _initialPosition=LatLng(currentLocation.latitude,currentLocation.longitude);
         locationController.text=placemark[0].name;
         speed=(currentLocation.speed)/1000;
         preLocation=_initialPosition;
         //Toast.show("abc", context, duration: 1, gravity:  Toast.BOTTOM);
         if(destinationPoint!=null){
           List<Placemark> placemark1 =await Geolocator().placemarkFromAddress(destinationPoint);
        double latitude = placemark1[0].position.latitude;
        double longitude = placemark1[0].position.longitude;
        getDistance(_initialPosition.latitude,_initialPosition.longitude,latitude,longitude);
         }
         
         
    });
        });
        
          
     
      }

      void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    _createRoute(route);
    setState(() {
     getDistance(_initialPosition.latitude, _initialPosition.longitude, latitude, longitude) ;
    });
    
    
  }

  void _createRoute(String encodedPoly){
    setState(() {
      _polyLines.add(Polyline(polylineId: PolylineId(_lastPosition.toString()),
      width: 3,
      points: convertToLatLng(decodePoly(encodedPoly)),
      color: Colors.black),
      
      );
    });
  }
    
    getDistance(a,b,c,d) async{
        double distance1 = await (Geolocator().distanceBetween(a, b, c, d))/1000;
        setState(() {
         distance=distance1; 
         //Toast.show("get Distance called${distance1.toString()}", context, duration: 1, gravity:  Toast.CENTER);
        });
        
    
  }
  
}