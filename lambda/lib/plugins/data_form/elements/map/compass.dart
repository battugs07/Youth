import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';

class CompassLayerOptions extends LayerOptions {
  CompassLayerOptions({Key? key, Stream<Null>? rebuild})
      : super(key: key, rebuild: rebuild);
}

class CompassLayer extends StatefulWidget {
  final CompassLayerOptions options;
  final MapState map;
  final Stream<void> stream;

  CompassLayer(this.options, this.map, this.stream);

  @override
  _CompassLayerState createState() => _CompassLayerState();
}

class _CompassLayerState extends State<CompassLayer> {
  bool _hasPermissions = true;
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;

  @override
  initState() {
    super.initState();
    // _fetchPermissionStatus();
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (status == PermissionStatus.granted) {
        setState(() => _hasPermissions = true);
      } else {
        Permission.locationAlways.status.then((status) {
          if (status == PermissionStatus.granted) {
            setState(() => _hasPermissions = true);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );

        return Positioned(
            bottom: 40,
            left: 10,
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              child: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Transform.rotate(
                  angle: (direction * (math.pi / 180) * -1),
                  child: Image.asset('assets/images/north.png'),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          ElevatedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_hasPermissions) {
        return _buildCompass();
      } else {
        return _buildPermissionSheet();
      }
    });
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: Text('Read Value'),
            onPressed: () async {
              final CompassEvent tmp = await FlutterCompass.events!.first;
              setState(() {
                _lastRead = tmp;
                _lastReadAt = DateTime.now();
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$_lastRead',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '$_lastReadAt',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompassLayerPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    return CompassLayer(options as CompassLayerOptions, mapState, stream);
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is CompassLayerOptions;
  }
}
