import 'package:flutter/material.dart';
import 'element_option.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './map/compass.dart';
import 'dart:async';

class MapWidget extends StatefulWidget {
  final ElementOption option;
  final bool? obscureText;
  final int? maxLines;
  final TextInputType? keyboardType;

  MapWidget(this.option,
      {Key? key,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1})
      : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
//User location
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double> _centerCurrentLocationStreamController;
  bool showUserLocation = false;
  String locationText = "";

  //DRAW
  bool drawing = false;
  bool drawCanSave = false;
  Polygon? drawPolygon;
  Polyline? drawPolyline;
  LatLng? drawPoint;
  @override
  void initState() {
    super.initState();

    _centerOnLocationUpdate = CenterOnLocationUpdate.never;
    _centerCurrentLocationStreamController = StreamController<double>();
  }

  void showUserLocationToggle() {
//    print(baseMapIndex);
    if (showUserLocation) {
      setState(() {
        showUserLocation = false;
        _centerOnLocationUpdate = CenterOnLocationUpdate.never;
      });
    } else {
      setState(() {
        showUserLocation = true;
        _centerOnLocationUpdate = CenterOnLocationUpdate.always;
        _centerCurrentLocationStreamController.add(15);
      });
    }
  }

  void onChange(String value) {
    setState(() {
      if (widget.option.meta["formType"] == "Number") {
        widget.option.onChange(widget.option.component, int.parse(value));
      } else {
        widget.option.onChange(widget.option.component, value);
      }
    });
  }

  List<LayerOptions> getLayers() {
    List<LayerOptions> layers = [];

    layers.add(TileLayerOptions(
        urlTemplate: "https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
        subdomains: ['mt0', 'mt1', 'mt2', 'mt3']));

    layers.add(LocationMarkerLayerOptions(
      showAccuracyCircle: showUserLocation,
      showHeadingSector: showUserLocation,
    ));

    if (drawPoint != null) {
      layers.add(MarkerLayerOptions(
        markers: [
          Marker(
            width: 38.0,
            height: 38.0,
            point: drawPoint!,
            builder: (ctx) => SvgPicture.asset("assets/images/gemtel.svg"),
          ),
        ],
      ));
    }
    return layers;
  }

  List<LayerOptions> getOtherLayers() {
    List<LayerOptions> layers = [];

    if (showUserLocation) {
      layers.add(CompassLayerOptions());
    }

    return layers;
  }

  List<MapPlugin> getPlugin() {
    List<MapPlugin> plugins = [
      CompassLayerPlugin(),
    ];

    plugins.add(LocationMarkerPlugin(
      centerCurrentLocationStream:
          _centerCurrentLocationStreamController.stream,
      centerOnLocationUpdate: _centerOnLocationUpdate,
    ));

    return plugins;
  }

  void draw() {
    if (drawing) {
      if (drawPoint != null) {
        // drawLayer!.addEvent!();

        setState(() {
          drawing = false;
          drawCanSave = false;
          // drawPoint = null;
          widget.option.onChange(widget.option.component,
              "{\"lng\":${drawPoint!.longitude}, \"lat\":${drawPoint!.latitude}}");
          locationText =
              "Уртраг: ${drawPoint!.longitude}, \n Өрөгрөг: ${drawPoint!.latitude}";
        });
      }
    } else {
      setState(() {
        drawing = true;
        drawCanSave = false;
        drawPoint = null;
      });
    }
  }

  void drawEvent(TapPosition tapPosition, LatLng point) {
    if (drawing) {
      setState(() {
        drawPoint = point;

        drawCanSave = true;
      });
    }
  }

  Widget build(BuildContext context) {
    var undur = MediaQuery.of(context).size.height - 260;
    return Stack(children: <Widget>[
      Container(
        height: undur,
        child: FlutterMap(
          nonRotatedLayers: getOtherLayers(),
          layers: getLayers(),
          options: MapOptions(
            allowPanningOnScrollingParent: false,
            center: new LatLng(47.91876, 106.91736),
            plugins: getPlugin(),
            zoom: 13.0,
            onTap: drawEvent,
          ),
        ),
      ),
      Positioned(
        child: new Text(locationText,
            style: new TextStyle(color: Colors.white, fontSize: 12.0)),
        top: 10,
        left: 10,
      ),
      Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              draw();
            },
            child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: drawing
                      ? drawCanSave
                          ? Color(0xff027f2b)
                          : Color(0xffce3303)
                      : Color(0xff376bee),
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 5.0,
                      // has the effect of softening the shadow
                      spreadRadius: 1.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Icon(
                      !drawing
                          ? Icons.add_outlined
                          : drawCanSave
                              ? Icons.add_task_rounded
                              : Icons.add_outlined,
                      color: Colors.white,
                      size: 23,
                    ),
                  ],
                )),
          )),
      Positioned(
          bottom: 75,
          right: 10,
          child: GestureDetector(
            onTap: () {
              showUserLocationToggle();
            },
            child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: showUserLocation
                      ? Color(0xff376bee)
                      : Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 5.0,
                      // has the effect of softening the shadow
                      spreadRadius: 1.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 6,
                    ),
                    Icon(
                      Icons.circle,
                      color: showUserLocation
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color(0xff376bee),
                      size: 34,
                    ),
                  ],
                )),
          ))
    ]);
  }
}
