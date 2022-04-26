import 'dart:io';
import 'package:enough_mail/enough_mail.dart';

String userName = 'Asma KERMICHE';
String password = 'artific2022';

void main() async {
  await mailExample();
}

/// High level mail API example
Future<void> mailExample() async {
  String domain = 'esi.dz';
  final email = 'artificcontactpro@gmail.com';
  print('discovering settings for  $email...');
  final config = await Discover.discover(email);
  if (config == null) {
    // note that you can also directly create an account when
    // you cannot autodiscover the settings:
    // Compare [MailAccount.fromManualSettings] and [MailAccount.fromManualSettingsWithAuth]
    // methods for details
    print('Unable to autodiscover settings for $email');
    return;
  }
  print('connecting to ${config.displayName}.');
  final account =
  MailAccount.fromDiscoveredSettings('my account', email, password, config);
  final mailClient = MailClient(account, isLogEnabled: true);
  try {
    await mailClient.connect();
    print('connected');
    final mailboxes =
    await mailClient.listMailboxesAsTree(createIntermediate: false);
    print(mailboxes);
    await mailClient.selectInbox();
    final messages = await mailClient.fetchMessages(count: 20);
    for (final msg in messages) {
      print(msg);
    }
    mailClient.eventBus.on<MailLoadEvent>().listen((event) {
      print('New message at ${DateTime.now()}:');
      print(event.message);
    });
    await mailClient.startPolling();
  } on MailException catch (e) {
    print('High level API failed with $e');
  }
}