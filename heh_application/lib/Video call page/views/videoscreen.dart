import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';

class VideoCallScreen extends StatefulWidget {
   VideoCallScreen({Key? key, required this.bookingDetail}) : super(key: key);
  static String? channelName;
  BookingDetail bookingDetail;
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine engine;
  bool isTokenExpiring = false;
  int tokenRole = 1;
  int tokenExpireTime = 45;
  String token = "";

  static String serverUrl = "https://agora-token-server-i5zg.onrender.com";
  static String appID = "1405b81aefdb475a94c00cc139ed7450";

  final AgoraClient client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
    username: sharedCurrentUser!.firstName,
    tokenUrl: serverUrl,
    appId: appID,
    channelName: VideoCallScreen.channelName!,
  ));

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    // engine.leaveChannel();
    // releaseAgora();
    changeStatus();
    super.dispose();
  }
  Future<void> changeStatus () async {
    if (sharedCurrentUser!.role!.name == "Physiotherapist" && widget.bookingDetail.shorttermStatus ==2){

        widget.bookingDetail.shorttermStatus = 3;
        await CallAPI().updateBookingDetailStatus(widget.bookingDetail);


        // Navigator.popUntil(context, ModalRoute.withName('/shortTerm'));
    }

  }

  Future<void> initAgora() async {
    await client.initialize();
  }

  Future<void> releaseAgora() async {
    await client.release();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Gọi Video"),
          ),
          body: SafeArea(
              child: Stack(children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
            ),
            AgoraVideoButtons(
              client: client,
              enabledButtons: const [
                BuiltInButtons.callEnd,
                BuiltInButtons.toggleCamera,
                BuiltInButtons.toggleMic,
                BuiltInButtons.switchCamera,
              ],
            )
          ])),
        ));
  }

  // Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
  //   // Prepare the Url
  //   String url =
  //       '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}';
  //
  //   // Send the request
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     // If the server returns an OK response, then parse the JSON.
  //     Map<String, dynamic> json = jsonDecode(response.body);
  //     String newToken = json['rtcToken'];
  //     debugPrint('Token Received: $newToken');
  //     // Use the token to join a channel or renew an expiring token
  //     setToken(newToken);
  //   } else {
  //     // If the server did not return an OK response,
  //     // then throw an exception.
  //     throw Exception(
  //         'Failed to fetch a token. Make sure that your server URL is valid');
  //   }
  // }
  //
  // void setToken(String newToken) async {
  //   token = newToken;
  //
  //   if (isTokenExpiring) {
  //     // Renew the token
  //     engine.renewToken(token);
  //     isTokenExpiring = false;
  //     showMessage("Token renewed");
  //   } else {
  //     // Join a channel.
  //     showMessage("Token received, joining a channel...");
  //
  //     await engine.joinChannel(
  //       token: token,
  //       channelId: channelName,
  //       // info: "",
  //       uid: 1,
  //       options: const ChannelMediaOptions(),
  //     );
  //   }
  // }
}

Widget showMessage(String message) {
  return Text(message);
}
