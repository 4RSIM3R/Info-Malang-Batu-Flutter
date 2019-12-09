import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';
import '../resources/maps_provider.dart';
import '../models/list_item_maps_pin.dart';

class MapsBloc {

    final _mapsProvider = MapsProvider();
    final _locationPermission = PublishSubject<PermissionStatus>();
    final _requestLocationResult = PublishSubject<PermissionStatus>();
    final _listItemMapsPin = PublishSubject<ListItemMapsPin>();

    Observable<PermissionStatus> get permissionStatus => _locationPermission.stream;
    Observable<PermissionStatus> get requestLocationPermissionResult => _requestLocationResult.stream;

    checkLocationPermission() async {
        final permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
        _locationPermission.sink.add(permissionStatus);
    }

    Future<void> requestLocationPermission() async {
        final Map<PermissionGroup, PermissionStatus> permissionRequestResult = await PermissionHandler().requestPermissions([PermissionGroup.location]);
        final PermissionStatus permissionStatusResult = permissionRequestResult[PermissionGroup.location];
        _requestLocationResult.sink.add(permissionStatusResult);
    }

    getListMapsPin() async {
        final listMapsPin = await _mapsProvider.getMapsPin();
        _listItemMapsPin.sink.add(listMapsPin);
    }

    dispose() {
        _locationPermission.close();
        _requestLocationResult.close();
        _listItemMapsPin.close();
    }

}
