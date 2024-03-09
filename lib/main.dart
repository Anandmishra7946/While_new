import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'view_model/wrapper/wrapper.dart';
import 'view_model/providers/providers_list.dart';
import 'utils/routes/routes.dart';
import 'utils/routes/routes_name.dart';

late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeApp() async {
  await setupFirebaseMessaging();
  await setupDynamicLinks();
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> setupDynamicLinks() async {
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    handleDynamicLink(dynamicLinkData);
  }).onError((error) {
    log('Dynamic Links $error');
  });

  final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  if (initialLink != null) {
    handleDynamicLink(initialLink);
  }
}

void handleDynamicLink(PendingDynamicLinkData dynamicLinkData) {
  final Uri deepLink = dynamicLinkData.link;
  log('Dynamic Link  Navigating to ${deepLink.toString()}');
  // Your navigation logic
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('FCM Background  Handling background message: ${message.messageId}');
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    mq = MediaQuery.of(context).size;
    setSystemUIOverlayStyle();
    return MultiProvider(
      providers: providersList,
      child: const MaterialApp(
        title: 'While',
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.wrapper,
        onGenerateRoute: Routes.generateRoute,
        home: Wrapper(),
      ),
    );
  }
}

void setSystemUIOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
}
