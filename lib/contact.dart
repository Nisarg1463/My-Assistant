// See installation notes below regarding AndroidManifest.xml and Info.plist

import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

List<Contact> contacts = [];
bool permissionDenied = false;

// void getContacts() async {
//   if (!await FlutterContacts.requestPermission()) {
//     permissionDenied = true;
//   } else {
//     contacts = await FlutterContacts.getContacts();
//   }
// }

Future<void> getContacts() async {
  if (await getPermission().isGranted) {
    contacts = await ContactsService.getContacts(withThumbnails: false);
  }
}

Future<PermissionStatus> getPermission() async {
  final PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.denied) {
    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.contacts].request();
    return permissionStatus[Permission.contacts] ?? PermissionStatus.values[0];
  } else {
    return permission;
  }
}
