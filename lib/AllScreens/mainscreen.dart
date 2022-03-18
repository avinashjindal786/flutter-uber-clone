
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_uber_clone/AllScreens/SearchScreen.dart';
import 'package:flutter_uber_clone/AllWidget/Divider.dart';
import 'package:flutter_uber_clone/AllWidget/progressDialog.dart';
import 'package:flutter_uber_clone/Assistants/AssistantMethods.dart';
import 'package:flutter_uber_clone/DataHandler/appData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen="main";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  List<LatLng> pLineCoordinates=[];
  Set<Polyline> polylineSet={};


  Position currentPosition;
  var geoLocator=Geolocator();
  double bottomPaddingOfMap=0;

  void locatePosition()async{
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;

    LatLng latLngPosition=LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition=new CameraPosition(target: latLngPosition,zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address=await AssistantMethods.searchCoordinateAddress(position,context);
    print("this is your address"+ address);
  }

  GlobalKey<ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldkey,

      drawer: Container(
        color: Colors.white,
        width: 255,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png",height: 65.0,width: 65.0,),
                      SizedBox(width: 16,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name",style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Brand-Bold"
                          ),),
                          SizedBox(height: 2,),
                          Text("Profile@gamil.com",style: TextStyle(
                              fontSize: 10.0,
                              fontFamily: "Brand-Bold"
                          ),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(height: 20,),
              //drawer body
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History",style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile",style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About",style: TextStyle(fontSize: 15.0),),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom:bottomPaddingOfMap ),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController=controller;

              setState(() {
                bottomPaddingOfMap=300.0;
              });
              locatePosition();
            },
          ),
          //Hamburger button for drawer
          Positioned(
            top: 45,
            left: 22,
            child: GestureDetector(
              onTap: (){
                scaffoldkey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,0.7
                      )
                    )
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu,color: Colors.black,),
                  radius: 20,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 270.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18.0)),
                boxShadow:[
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    offset: Offset(0.7,0.7),
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi There",style: TextStyle(
                        fontSize: 12.0),),
                    Text("Where to?",style: TextStyle(
                        fontSize: 20.0,fontFamily: "Brand_Bold"),),
                    SizedBox(height: 20.0,),

                    GestureDetector(
                      onTap: () async{

                         var res=await Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                         if(res=="obtainDirection")
                           {
                             await getPlaceDirection();
                           }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow:[
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              offset: Offset(0.7,0.7),
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search,color: Colors.yellow,),
                              SizedBox(width:10.0 ,),
                              Text("Search Drop off"),
                            ],
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 24.0,),
                    Row(
                      children: [
                        Icon(Icons.home,color: Colors.grey,),
                        SizedBox(width: 12.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<AppData>(context).picUpLocation !=null
                                  ?
                              Provider.of<AppData>(context).picUpLocation.placeName
                                  :
                                  "Add Home"
                            ),
                            SizedBox(height: 4.0,),
                            Text("Your living home address",style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    DividerWidget(),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Icon(Icons.work,color: Colors.grey,),
                        SizedBox(width: 12.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add work"),
                            SizedBox(height: 4.0,),
                            Text("Your office address",style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                          ],
                        )
                      ],
                    )


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> getPlaceDirection()async
  {
    var initialPos=Provider.of<AppData>(context,listen: false).picUpLocation;
    var finalPos=Provider.of<AppData>(context,listen: false).dropOffLocation;

    var pickUpLaLng=LatLng(initialPos.latitude, initialPos.longitute);
    var dropOffLapLng=LatLng(finalPos.latitude, finalPos.longitute);

    showDialog(
      context: context,
      builder: (BuildContext context)=>ProgressDialog(massage:"Please Wait....",);
    );

    var details=await AssistantMethods.obtainDirectionDetails(pickUpLaLng, dropOffLapLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints=PolylinePoints();
    List<PointLatLng> decodedPointsResult=polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();
    if(decodedPointsResult.isNotEmpty)
      {
        decodedPointsResult.forEach((PointLatLng pointLatLng) {
         pLineCoordinates.add(LatLng(pickUpLaLng.latitude,pointLatLng.longitude));
        });
      }

    polylineSet.clear();
    setState(() {
      Polyline polyline=Polyline(
        polylineId: PolylineId("polylineId"),
        color: Colors.pink,
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if(pickUpLaLng.latitude>dropOffLapLng.latitude&&pickUpLaLng.longitude>dropOffLapLng.longitude)
      {
        latLngBounds=LatLngBounds(southwest: dropOffLapLng, northeast: pickUpLaLng);
      }
     else if(pickUpLaLng.longitude>dropOffLapLng.longitude)
      {
        latLngBounds=LatLngBounds(southwest: LatLng(pickUpLaLng.latitude,dropOffLapLng.longitude), northeast: LatLng(dropOffLapLng.latitude,pickUpLaLng.longitude));
      } else if(pickUpLaLng.latitude>dropOffLapLng.latitude)
      {
        latLngBounds=LatLngBounds(southwest: LatLng(dropOffLapLng.latitude,pickUpLaLng.longitude), northeast: LatLng(pickUpLaLng.latitude,dropOffLapLng.longitude));
      }else
        {
          latLngBounds=LatLngBounds(southwest: pickUpLaLng, northeast: dropOffLapLng);

        }
     
     newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }
}
